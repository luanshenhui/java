package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.related.model.CfgPriceSystemModel;
import cn.com.cgbchina.related.service.CfgPriceSystemService;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.rest.visit.model.payment.PointsMallReturnGoodsInfo;
import cn.com.cgbchina.trade.dao.*;
import cn.com.cgbchina.trade.dto.OrderPartBackDto;
import cn.com.cgbchina.trade.dto.RevocationOrderDto;
import cn.com.cgbchina.trade.exception.TradeException;
import cn.com.cgbchina.trade.manager.OrderPartBackManager;
import cn.com.cgbchina.trade.manager.OrderSubManager;
import cn.com.cgbchina.trade.model.*;
import cn.com.cgbchina.user.dto.MessageDto;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.service.NewMessageService;
import cn.com.cgbchina.user.service.VendorService;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkNotNull;

/**
 * Created by yuxinxin on 16-4-29.
 */

@Service
@Slf4j
public class OrderPartBackServiceImpl implements OrderPartBackService {
	@Resource
	private OrderPartBackManager orderPartBackManager;
	@Resource
	private OrderSubDao orderSubDao;
	@Resource
	private TblOrderHistoryDao tblOrderHistoryDao;
	@Resource
	private OrderSubManager orderSubManager;
	@Resource
	private OrderReturnTrackDetailDao orderReturnTrackDetailDao;
	@Resource
	private OrderMainDao orderMainDao;
	@Resource
	private TblOrdermainHistoryDao tblOrdermainHistoryDao;
	@Resource
	private TblOrderExtend1Dao tblOrderExtend1Dao;
	@Resource
	private ItemService itemService;
	@Resource
	private VendorService vendorService;
	@Resource
	private GoodsPayWayService goodsPayWayService;
	@Resource
	private CfgPriceSystemService cfgPriceSystemService;
	@Resource
	NewMessageService newMessageService;

	@Value("#{app.merchId}")
	private String orderMerchentId;

	/**
	 * 审核撤单 供应商(广发)端使用此方法
	 *
	 * @param orderSubModel
	 * @return
	 */
	@Override
	public Response<Boolean> updateRevocation(OrderSubModel orderSubModel, String memo, String memoExt, User user) {
		Response<Boolean> response = new Response<Boolean>();
		try {
			// 校验orderSubModel是否为空
			checkArgument(!(orderSubModel == null), "orderSubModel.is.null");
			String orderId=orderSubModel.getOrderId();
			checkArgument(StringUtils.isNotBlank(orderId),"orderId.be.null");
			String updateFlag="orderSub";
			orderSubModel = orderSubDao.findById(orderId);
			if (orderSubModel == null) {
				TblOrderHistoryModel tblOrderHistoryModel = tblOrderHistoryDao.findById(orderId);
				if (tblOrderHistoryModel == null) {
					log.error("OrderPartBackServiceImpl.updateRevocation.error.orderSubModel.can.not.be.null");
					response.setError("OrderServiceImpl.findOrderInfo.error.orderSubModel.can.not.be.null");
					return response;
				}
				updateFlag="history";
				orderSubModel = new OrderSubModel();
				BeanMapper.copy(tblOrderHistoryModel, orderSubModel);
			}
			if (!Contants.SUB_ORDER_STATUS_0308.equals(orderSubModel.getCurStatusId())){
				log.error("撤单管理 order status changed orderID:"+orderId);
				response.setError("订单ID："+orderId+",订单状态发生改变无法撤单！");
				return  response;
			}

			OrderReturnTrackDetailModel orderReturnTrackDetailModel = new OrderReturnTrackDetailModel();
			// 更新订单表中的订单状态
			orderSubModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0312);
			orderSubModel.setCurStatusNm("已撤单");
			orderSubModel.setSaleAfterStatus(Contants.SUB_ORDER_STATUS_0312);
			orderSubModel.setModifyOper(user.getId());

			// 向履历model中添加数据
			orderReturnTrackDetailModel.setMemo(memo);
			orderReturnTrackDetailModel.setMemoExt(memoExt);
			orderReturnTrackDetailModel.setOrderId(orderSubModel.getOrderId());// 订单号
			orderReturnTrackDetailModel.setOrdertypeId(orderSubModel.getOrdertypeId());// 业务类型
			orderReturnTrackDetailModel.setOrdertypeNm(orderSubModel.getOrdertypeNm());// 业务名称
			orderReturnTrackDetailModel.setOperationType(0);// 0是撤单 1是退货
			orderReturnTrackDetailModel.setCreateOper(user.getId());
			orderReturnTrackDetailModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0312);// 状态
			orderReturnTrackDetailModel.setCurStatusNm("已撤单");// 状态名称

			// 向订单履历中插入
			OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
			orderDoDetailModel.setOrderId(orderSubModel.getOrderId());
			orderDoDetailModel.setDoUserid(user.getId());
			orderDoDetailModel.setStatusId(Contants.SUB_ORDER_STATUS_0312);
			orderDoDetailModel.setStatusNm("已撤单");
			orderDoDetailModel.setUserType("2");
			orderDoDetailModel.setDelFlag(0);
			orderDoDetailModel.setCreateOper(user.getId());

			// 一期订单线下退款 线上更新订单状态和插入履历 二期全部线上处理
			// 撤销订单
			Boolean result = orderSubManager.revokeOrder(orderSubModel, orderReturnTrackDetailModel, orderDoDetailModel,
					user, null,updateFlag);

			MessageDto messageDto = new MessageDto();
			// 推送消息
			messageDto.setCreateOper(user.getId());
			messageDto.setUserType(Contants.ORDER_USER_TYPE_01);
			messageDto.setCustId(orderSubModel.getCreateOper());
			messageDto.setOrderStatus(Contants.SUB_ORDER_STATUS_0312);
			messageDto.setGoodName(orderSubModel.getGoodsNm());
			messageDto.setOrderId(orderSubModel.getOrderId());
			messageDto.setVendorId(orderSubModel.getVendorId());
			newMessageService.insertUserMessage(messageDto);

			response.setResult(result);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (TradeException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("订单ID：" + orderSubModel.getOrderId() + "撤单失败");
			response.setError("订单ID：" + orderSubModel.getOrderId() + "撤单失败");
			return response;
		}

	}

	/**
	 * 审核撤单 供应商(积分)端使用此方法
	 * 
	 * @param orderSubModel 订单信息
	 * @param memo 撤单原因
	 * @param memoExt 撤单说明
	 * @return 撤单是否成功
	 */
	@Override
	public Response <Boolean> updatePointRevocation(OrderSubModel orderSubModel, String memo, String memoExt, User user) {
		// 交易总金额
		String cal_mon = "0.00";
		String isBirth = null;
		Response<Boolean> response = Response.newResponse();
		try {

			// 校验订单是否超过180天，订单不能撤销。
			TblOrderHistoryModel tblOrderHistoryModel = tblOrderHistoryDao.findById(orderSubModel.getOrderId());
			if (tblOrderHistoryModel != null) {
				log.error("order.time.out");
				response.setError("order.time.out");
				return response;
			}
			String updateFlag="orderSub";
			// 校验订单状态是否改变
			// 不是支付成功状态
			if (!Contants.SUB_ORDER_STATUS_0308.equals(orderSubModel.getCurStatusId())) {
				log.error("order.status.change");
				response.setError("order.status.change");
				return response;
			}

			// 银联商户号是否存才
			Response<VendorInfoDto> vendorResponse = vendorService.findById(orderSubModel.getVendorId());
			if (!vendorResponse.isSuccess()) {
				log.error(vendorResponse.getError());
				response.setError(vendorResponse.getError());
				return response;
			}
			if (Strings.isNullOrEmpty(vendorResponse.getResult().getUnionPayNo())) {
				log.error("order.unionPayNo.is.null");
				response.setError("order.unionPayNo.is.null");
				return response;
			}
			// 查询商品支付方式，获取是否生日价格，清算金额
			Response<TblGoodsPaywayModel> goodsResponse = goodsPayWayService
					.findGoodsPayWayInfo(orderSubModel.getGoodsPaywayId());
			if (!goodsResponse.isSuccess()) {
				log.error(goodsResponse.getError());
				response.setError(goodsResponse.getError());
				return response;
			}
			if (goodsResponse.getResult() != null) {
				isBirth = goodsResponse.getResult().getIsBirth();
				// 如果为生日价购买的话，需取得生日折扣比例
				if ("1".equals(isBirth)) {
					Response<List<CfgPriceSystemModel>> priceResponse = cfgPriceSystemService
							.findByPriceSystemId(Contants.BIRTH_CODE);
					if (!priceResponse.isSuccess()) {
						log.error("order.birth.is.error");
						response.setError("order.birth.is.error");
						return response;
					}
					// 判断关键数据是否为空
					// 设置交易总金额
					if (priceResponse.getResult() != null && priceResponse.getResult().size() != 0
							&& priceResponse.getResult().get(0).getArgumentOther() != null
							&& goodsResponse.getResult().getCalMoney() != null) {
						cal_mon = new BigDecimal(priceResponse.getResult().get(0).getArgumentOther().toString())
								.multiply(new BigDecimal(goodsResponse.getResult().getCalMoney().toString()))
								.setScale(2, BigDecimal.ROUND_HALF_UP).toString();
					} else {
						cal_mon = goodsResponse.getResult().getCalMoney() == null ? cal_mon
								: goodsResponse.getResult().getCalMoney().toString();
					}
				} else {
					cal_mon = goodsResponse.getResult().getCalMoney() == null ? cal_mon
							: goodsResponse.getResult().getCalMoney().toString();
				}
			}
			// 插入撤单信息
			// 更新订单表中的订单状态
			orderSubModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0312);
			orderSubModel.setCurStatusNm("已撤单");
			orderSubModel.setSaleAfterStatus(Contants.SUB_ORDER_STATUS_0312);
			orderSubModel.setModifyOper(user.getId());

			// 插入取消订单表
			// 向履历model中添加数据
			OrderReturnTrackDetailModel orderReturnTrackDetailModel = new OrderReturnTrackDetailModel();
			orderReturnTrackDetailModel.setMemo(memo);
			orderReturnTrackDetailModel.setMemoExt(memoExt);
			orderReturnTrackDetailModel.setOrderId(orderSubModel.getOrderId());// 订单号
			orderReturnTrackDetailModel.setOrdertypeId(orderSubModel.getOrdertypeId());// 业务类型
			orderReturnTrackDetailModel.setOrdertypeNm(orderSubModel.getOrdertypeNm());// 业务名称
			orderReturnTrackDetailModel.setOperationType(0);// 0是撤单 1是退货
			orderReturnTrackDetailModel.setCreateOper(orderSubModel.getModifyOper());
			orderReturnTrackDetailModel.setModifyOper(orderSubModel.getModifyOper());
			orderReturnTrackDetailModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0312);// 状态
			orderReturnTrackDetailModel.setCurStatusNm("已撤单");// 状态名称

			// 向订单履历中插入
			OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
			orderDoDetailModel.setOrderId(orderSubModel.getOrderId());
			orderDoDetailModel.setDoUserid(user.getId());
			orderDoDetailModel.setStatusId(Contants.SUB_ORDER_STATUS_0312);
			orderDoDetailModel.setStatusNm("已撤单");
			orderDoDetailModel.setUserType("2");
			orderDoDetailModel.setDelFlag(0);
			orderDoDetailModel.setCreateOper(orderSubModel.getModifyOper());
			orderDoDetailModel.setModifyOper(orderSubModel.getModifyOper());

			// 整理发送外部接口数据
			PointsMallReturnGoodsInfo pointsMallReturnGoodsInfo = new PointsMallReturnGoodsInfo();
			pointsMallReturnGoodsInfo.setOrderId(orderSubModel.getOrderId());// 小订单号
			pointsMallReturnGoodsInfo.setOrderNumber(orderSubModel.getOrdermainId());// 大订单号
			pointsMallReturnGoodsInfo.setChannel("MALL");// 渠道标识
			pointsMallReturnGoodsInfo.setOrderTime(orderSubModel.getCreateTime()); // 订单生成时间
			pointsMallReturnGoodsInfo.setOperTime(new Date());// 请款退货时间
			pointsMallReturnGoodsInfo.setAcrdNo(orderSubModel.getCardno());// 账号
			pointsMallReturnGoodsInfo.setTradeMoney(new BigDecimal(cal_mon));// 交易总金额
			pointsMallReturnGoodsInfo.setCashMoney(orderSubModel.getTotalMoney());// 现金支付金额
			pointsMallReturnGoodsInfo.setIntegralMoney(new BigDecimal("0.00"));// 积分抵扣金额
			pointsMallReturnGoodsInfo.setMerId(orderMerchentId);// 商城商户号
			pointsMallReturnGoodsInfo.setMerno(""); // 小商户号
			pointsMallReturnGoodsInfo.setQsvendorNo(vendorResponse.getResult().getUnionPayNo());// 银联商户号
			pointsMallReturnGoodsInfo.setCategoryNo("");// 计费费率编号
			pointsMallReturnGoodsInfo.setOrderNbr("");// 银行订单号
			pointsMallReturnGoodsInfo.setStagesNum("");// 分期期数
			pointsMallReturnGoodsInfo.setOperId("");// 操作员
			pointsMallReturnGoodsInfo.setPayee("");//01行方    不送或空值代表客户

			// 撤单数据更新
			Boolean result = orderSubManager.revokeOrder(orderSubModel, orderReturnTrackDetailModel, orderDoDetailModel,
					user, pointsMallReturnGoodsInfo,updateFlag);

			MessageDto messageDto = new MessageDto();
			// 推送消息
			messageDto.setCreateOper(user.getId());
			messageDto.setUserType(Contants.ORDER_USER_TYPE_01);
			messageDto.setCustId(orderSubModel.getCreateOper());
			messageDto.setOrderStatus(Contants.SUB_ORDER_STATUS_0312);
			messageDto.setGoodName(orderSubModel.getGoodsNm());
			messageDto.setOrderId(orderSubModel.getOrderId());
			messageDto.setVendorId(orderSubModel.getVendorId());
			newMessageService.insertUserMessage(messageDto);
			response.setResult(Boolean.TRUE);

			return response;
		} catch (TradeException e) {
			log.error("订单ID：" + orderSubModel.getOrderId() + "撤单失败");
			response.setError("订单ID：" + orderSubModel.getOrderId() + "撤单失败");
			return response;
		}catch (Exception e) {
			log.error("订单ID：" + orderSubModel.getOrderId() + "撤单失败");
			response.setError("订单ID：" + orderSubModel.getOrderId() + "撤单失败");
			return response;
		}
	}

	/**
	 * 供应商撤单 新更改后的撤单查询
	 * 
	 * @param pageNo 页面数
	 * @param size 页面条数
	 * @param startTime 开始时间
	 * @param endTime 结束时间
	 * @param orderId 子订单号
	 * @param sourceId 渠道
	 * @param ordertypeId 业务类型
	 * @param tblFlag 是否查询历史数据：1查询历史数据
	 * @param ordermainId 主订单号
	 * @param user 供应商信息
	 * @return 列表数据
	 */
	@Override
	public Response<Pager<OrderPartBackDto>> findRevocationAll(Integer pageNo, Integer size, String startTime,
			String endTime, String orderId, String sourceId, String ordertypeId, String tblFlag, String ordermainId,
			User user) {

		// 构造返回值及参数
		Response<Pager<OrderPartBackDto>> response = Response.newResponse();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Map<String, Object> paramMap = Maps.newHashMap();
		// 判断主订单号为空
		if (StringUtils.isNotEmpty(ordermainId)) {
			paramMap.put("ordermainId", ordermainId.trim());
		}
		// 判断订单号为空
		if (StringUtils.isNotEmpty(orderId)) {
			paramMap.put("orderId", orderId.trim());
		}
		// 判断商城是否查询100天之内的数据
		// 判断订单时间
		if (StringUtils.isNotEmpty(startTime)) {
			paramMap.put("startTime", startTime);
		}
		// 判断订单时间
		if (StringUtils.isNotEmpty(endTime)) {
			paramMap.put("endTime", endTime);
		}
		// 判断分期类型为空
		if (StringUtils.isNotEmpty(ordertypeId)) {
			paramMap.put("ordertypeId", ordertypeId);
		}
		if (StringUtils.isNotEmpty(sourceId)) {
			paramMap.put("sourceId", sourceId);
		}
		// 供应商Id
		String vendorId = user.getVendorId();
		if (StringUtils.isNotEmpty(vendorId)) {
			paramMap.put("vendorId", vendorId);
		}
		try {
			// 获取子订单列表数据
			Pager<OrderSubModel> pager = new Pager<>();
			List<OrderSubModel> orderSubModelList = Lists.newArrayList();
			// 获取子订单列表数据 6个月之前订单取自history表
			if ("1".equals(tblFlag)) {
				Pager<TblOrderHistoryModel> pagerTblOrderHistory = tblOrderHistoryDao.findLikeByPagePart(paramMap,
						pageInfo.getOffset(), pageInfo.getLimit());
				List<TblOrderHistoryModel> tblOrderHistoryModelList = pagerTblOrderHistory.getData();
				for (TblOrderHistoryModel tblOrderHistoryModel : tblOrderHistoryModelList) {
					OrderSubModel orderSubModel = new OrderSubModel();
					BeanMapper.copy(tblOrderHistoryModel, orderSubModel);
					orderSubModelList.add(orderSubModel);
				}
			} else {
				// 最近订单数据
				pager = orderSubDao.findLikeByPagePart(paramMap, pageInfo.getOffset(), pageInfo.getLimit());
				orderSubModelList = pager.getData();
			}

			List<OrderPartBackDto> orderPartBackDtos = Lists.newArrayList();
			// 遍历orderSubModel，构造返回值
			for (OrderSubModel orderSubModel : orderSubModelList) {
				OrderPartBackDto orderPartBackDto = new OrderPartBackDto();
				// 查询撤单原因
				List<OrderReturnTrackDetailModel>  orderReturnTrackDetailModelList = orderReturnTrackDetailDao.findByOrderId(orderSubModel.getOrderId());
				for (OrderReturnTrackDetailModel orderReturnTrackDetailModel : orderReturnTrackDetailModelList) {
					OrderReturnTrackDetailModel orderReturnTrackDetailModelData = new OrderReturnTrackDetailModel();
					BeanMapper.copy(orderReturnTrackDetailModel, orderReturnTrackDetailModelData);
					orderPartBackDto.setOrderReturnTrackDetailModel(orderReturnTrackDetailModelData);
				}
				//处理ordersub敏感信息
                 orderSubModel.setCardno("");
				 orderSubModel.setBankNbr("");
				 orderSubModel.setAcctNo("");
			  	 orderSubModel.setCardnoBenefit("");
				 orderSubModel.setValidateCode("");
				 orderSubModel.setBonusTraceNo("");
				 orderSubModel.setMsgContent("");
				 orderSubModel.setBankNbr2("");
				orderPartBackDto.setOrderSubModel(orderSubModel);
				// 银行订单号
				List<TblOrderExtend1Model> tblOrderExtend1ModelList=tblOrderExtend1Dao.findListByOrderId(orderSubModel.getOrderId());
				if (tblOrderExtend1ModelList!=null&&!tblOrderExtend1ModelList.isEmpty()) {
					orderPartBackDto.setTblOrderExtend1Model(tblOrderExtend1ModelList.get(0));
				}
				// 单品Id
				// 分期编码
				String goodsId = orderSubModel.getGoodsId();
				ItemModel itemModel = itemService.findById(goodsId);
				if (itemModel != null) {
					orderPartBackDto.setMid(itemModel.getMid());
					orderPartBackDto.setXid(itemModel.getXid());
				}
				orderPartBackDtos.add(orderPartBackDto);
			}
			response.setResult(new Pager<>(pager.getTotal(), orderPartBackDtos));
			return response;
		} catch (Exception e) {
			log.error("OrderPartBackServiceImpl.find.qury.error{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderPartBackServiceImpl.find.qury.error");
			return response;
		}
	}

	/**
	 * 批量更新
	 *
	 * @param updateAll
	 * @return
	 */
	public Response<Integer> updateAllRevocation(List<String> updateAll) {
		Response<Integer> response = new Response<Integer>();
		try {
			checkNotNull(updateAll, "updateAll is Null");
			Map<String, Object> paramMap = Maps.newHashMap();
			paramMap.put("idList", updateAll);
			// 更新
			Integer count = orderSubManager.updateAllRevocation(paramMap);
			if (count > 0) {
				response.setResult(count);
				return response;
			} else {
				response.setError("update.all.revocation.error");
				return response;
			}
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.info("update.all.revocation.error", Throwables.getStackTraceAsString(e));
			response.setError("update.all.revocation.error");
			return response;
		}
	}

	/**
	 * 批量更新退货状态
	 *
	 * @param rejectGoodsList
	 * @return
	 */
	@Override
	public Response<Integer> updateAllRejectGoods(List<Long> rejectGoodsList) {
		Response<Integer> response = new Response<Integer>();
		try {
			checkNotNull(rejectGoodsList, "id is Null");
			Map<String, Object> params = Maps.newHashMap();
			params.put("rejectGoodsList", rejectGoodsList);
			// 更新操作 批量更新退货状态
			Integer count = orderPartBackManager.updateAllGoodsStatus(params);
			// 履历表添加数据
			OrderReturnTrackModel orderReturnTrackModel = new OrderReturnTrackModel();
			// 循环取出退货单ID 然后循环插入履历表
			for (Long id : rejectGoodsList) {
				orderReturnTrackModel.setPartbackId(id);// 退货单ID
				orderReturnTrackModel.setStatus(Contants.CURSTAUSID_0327);// 退货单状态
				// 0334退货成功
				orderReturnTrackModel.setDelFlag(Contants.DEL_FG_0);// 删除状态
				// 0是未删除
				// 向履历表中插入
				orderPartBackManager.insert(orderReturnTrackModel);
			}
			if (count > 0) {
				response.setResult(count);
				return response;
			} else {
				response.setError("update.all.reject.goods.error");
				return response;
			}
		} catch (NullPointerException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.info("update all reject goods error", Throwables.getStackTraceAsString(e));
			response.setError("update.all.reject.goods.error");
			return response;
		}
	}

	/**
	 * 撤单导出
	 * 
	 * @param dataMap
	 * @param user
	 * @return
	 */
	@Override
	public Response<List<RevocationOrderDto>> exportRevocation(Map<String, Object> dataMap, User user) {
		// 构造返回值及参数
		Response<List<RevocationOrderDto>> response = new Response<>();
		Map<String, Object> paramMap = Maps.newHashMap();
		PageInfo pageInfo = new PageInfo();
		// 剔除无值得条件
		for (Object key : dataMap.keySet()) {
			String keyTemp = String.valueOf(key);
			String valueTemp = String.valueOf(dataMap.get(key));
			System.out.println(keyTemp + "------------------------" + valueTemp);
			if (null != valueTemp && !"".equals(valueTemp))
				paramMap.put(keyTemp, valueTemp);
		}
		// 获取供应商ID
		String vendorId = user.getVendorId();
		checkArgument(StringUtils.isNotEmpty(vendorId), "vendorId.can.not.be.empty");
		paramMap.put("vendorId", vendorId);

		try {
			// 获取子订单列表数据
			// 获取子订单列表数据 100天之前订单取自history表
			Pager<OrderSubModel> pager = new Pager<>();
			List<OrderSubModel> orderSubModelList = Lists.newArrayList();
			List<RevocationOrderDto> revocationOrderDtoList = Lists.newArrayList();
			pager = orderSubDao.findLikeByPagePart(paramMap, 0, 20);
			orderSubModelList = pager.getData();
			Pager<TblOrderHistoryModel> pagerTblOrderHistory = tblOrderHistoryDao.findLikeByPage(paramMap, 0, 20);
			List<TblOrderHistoryModel> tblOrderHistoryModelList = pagerTblOrderHistory.getData();
			for (TblOrderHistoryModel tblOrderHistoryModel : tblOrderHistoryModelList) {
				OrderSubModel orderSubModel = new OrderSubModel();
				BeanMapper.copy(tblOrderHistoryModel, orderSubModel);
				orderSubModelList.add(orderSubModel);
			}
			for (OrderSubModel orderSubModel : orderSubModelList) {
				RevocationOrderDto revocationOrderDto = new RevocationOrderDto();
				revocationOrderDto.setOrderId(orderSubModel.getOrderId());
				revocationOrderDto.setOrdermainId(orderSubModel.getOrdermainId());
				revocationOrderDto.setGoodsNm(orderSubModel.getGoodsNm());
				revocationOrderDto.setCurStatusNm(orderSubModel.getCurStatusNm());
				// 将数据库中订单创建时间格式化，分别取出日期和时间
				Date createTime = orderSubModel.getCreateTime();
				DateTime dateTime = new DateTime(createTime);
				String createDateNew = dateTime.toString("MM/dd/yyyy");
				String createTimeNew = dateTime.toString("HH:mm:ss");
				// 下单日期
				revocationOrderDto.setCreateDate(createDateNew);
				// 下单时间
				revocationOrderDto.setCreateTime(createTimeNew);
				OrderMainModel orderMainModel = orderMainDao.findById(orderSubModel.getOrdermainId());
				if (orderMainModel == null) {
					TblOrdermainHistoryModel orderMainModel1 = tblOrdermainHistoryDao
							.findById(orderSubModel.getOrdermainId());
					if (orderMainModel1 != null) {
						BeanMapper.copy(orderMainModel1, orderMainModel);
					}
				}
				if (orderMainModel != null) {
					revocationOrderDto.setOrdermainDesc(orderMainModel.getOrdermainDesc());
				}
				// 银行订单号
				TblOrderExtend1Model tblOrderExtend1Model = tblOrderExtend1Dao
						.findByOrderId(orderSubModel.getOrderId());
				if (tblOrderExtend1Model != null) {
					revocationOrderDto.setOrdernbr(tblOrderExtend1Model.getOrdernbr());
				}
				// 分期编码
				String goodsId = orderSubModel.getGoodsId();
				ItemModel itemModel = itemService.findById(goodsId);
				if (itemModel != null) {
					revocationOrderDto.setGoodsMid(itemModel.getMid());
				}
				revocationOrderDtoList.add(revocationOrderDto);
			}
			response.setResult(revocationOrderDtoList);
			return response;
		} catch (Exception e) {
			log.error("OrderPartBackServiceImpl.exportRevocation.error{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderPartBackServiceImpl.exportRevocation.error");
			return response;
		}
	}

	/**
	 * 根据订单ID查询订单信息
	 *
	 * @param orderId 订单ID
	 * @return 订单信息
	 */
	@Override
	public Response<OrderSubModel> findbyOrderId(String orderId) {
		Response response = Response.newResponse();
		OrderSubModel orderSubModel = new OrderSubModel();
		if (Strings.isNullOrEmpty(orderId)) {
			log.error("orderSubModel is null");
			response.setError("orderSubModel.is.null");
			return response;
		}

		try {
			// 查询订单表，如果不为空，返回数据
			OrderSubModel order = orderSubDao.findById(orderId);
			if (order != null) {
				response.setResult(order);
				return response;
			}
			// 查询订单历史表，如果不为空，返回数据
			TblOrderHistoryModel orderHistory = tblOrderHistoryDao.findById(orderId);
			if (orderHistory != null) {
				BeanMapper.copy(orderHistory, orderSubModel);
				response.setResult(orderSubModel);
				return response;
			}
			// 没查到数据
			response.setError("OrderServiceImpl.find.qury.error");
			return response;

		} catch (Exception e) {
			log.error("OrderServiceImpl find qury error");
			response.setError("OrderServiceImpl.find.qury.error");
			return response;
		}
	}
}
