/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.trade.service;

import static com.google.common.base.Preconditions.checkArgument;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import cn.com.cgbchina.trade.exception.TradeException;
import com.google.common.base.Strings;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.utils.DistributedLocks;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.LocalDateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.trade.dao.OrderMainDao;
import cn.com.cgbchina.trade.dao.OrderReturnTrackDetailDao;
import cn.com.cgbchina.trade.dao.OrderSubDao;
import cn.com.cgbchina.trade.dao.TblOrderExtend1Dao;
import cn.com.cgbchina.trade.dao.TblOrderHistoryDao;
import cn.com.cgbchina.trade.dto.OrderInfoDto;
import cn.com.cgbchina.trade.dto.RequestOrderDto;
import cn.com.cgbchina.trade.manager.OrderReturnManager;
import cn.com.cgbchina.trade.manager.OrderSubManager;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderReturnTrackDetailModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.TblOrderExtend1Model;
import cn.com.cgbchina.trade.model.TblOrderHistoryModel;
import cn.com.cgbchina.user.dto.MessageDto;
import cn.com.cgbchina.user.service.NewMessageService;
import lombok.extern.slf4j.Slf4j;

/**
 *
 * @author 11150721040343
 * @version 1.0
 * @Since 2016/7/11
 */
@Service
@Slf4j
public class OrderReturnServiceImpl implements OrderReturnService {
	@Resource
	private OrderSubDao orderSubDao;
	@Resource
	private OrderMainDao orderMainDao;
	@Resource
	private TblOrderHistoryDao tblOrderHistoryDao;
	@Resource
	private TblOrderExtend1Dao tblOrderExtend1Dao;
	@Resource
	private OrderReturnTrackDetailDao orderReturnTrackDetailDao;
	@Resource
	private OrderReturnManager orderReturnManager;
	@Resource
	OrderSubManager orderSubManager;
	@Resource
	NewMessageService newMessageService;
	@Resource
	private ItemService itemService;
	@Value("#{app.timeStart}")
	private String timeStart;
	@Value("#{app.timeEnd}")
	private String timeEnd;
	@Autowired
	private JedisTemplate jedisTemplate;


	// 判断非空
	private Boolean isNotBlank(String str) {
		if (StringUtils.isNotBlank(str) && StringUtils.isNotBlank(str.trim().replace(" ", "")))
			return Boolean.TRUE;
		return Boolean.FALSE;
	}

	/**
	 * 查询退货
	 * 
	 * @param user
	 * @param pageNo
	 * @param size
	 * @param ordermainId
	 * @param startTime
	 * @param endTime
	 * @param curStatusId
	 * @param goodsNm
	 * @param sourceId
	 * @param orderType
	 * @return
	 */
	@Override
	public Response<Pager<RequestOrderDto>> find(User user, Integer pageNo, Integer size, String ordermainId,
			String orderId, String startTime, String endTime, String curStatusId, String goodsNm, String sourceId,
			String orderType) {
		Response<Pager<RequestOrderDto>> response = new Response<Pager<RequestOrderDto>>();
		Map<String, Object> paramMap = Maps.newHashMap();
		List<RequestOrderDto> requestOrderDtos = Lists.newArrayList();
		PageInfo pageInfo = new PageInfo(pageNo, size);

		// 默认选择逻辑删除
		paramMap.put("delFlag", Contants.DEL_INTEGER_FLAG_0);
		if (StringUtils.isNotEmpty(curStatusId)) {
			paramMap.put("curStatusId", curStatusId);// 订单状态
		}
		if (StringUtils.isNotEmpty(startTime)) {
			paramMap.put("startTime", startTime);// 下单开始时间
		}
		if (StringUtils.isNotEmpty(endTime)) {
			paramMap.put("endTime", endTime);// 下单结束时间
		}
		if (StringUtils.isNotEmpty(ordermainId)) {
			paramMap.put("ordermainId", ordermainId);// 主订单号
		}
		if (StringUtils.isNotEmpty(orderId)) {
			paramMap.put("orderId", orderId);// 订单号
		}
		if (StringUtils.isNotEmpty(sourceId)) {
			paramMap.put("sourceId", sourceId);// 渠道
		}
		if (StringUtils.isNotEmpty(goodsNm)) {
			paramMap.put("goodsNm", goodsNm);// 商品名称
		}
		String vendorId = user.getVendorId();
		if (StringUtils.isNotEmpty(vendorId)) {
			paramMap.put("vendorId", vendorId);// 供应商Id
		}
		if (StringUtils.isNotEmpty(orderType) && "2".equals(orderType)) {
			paramMap.put("orderType", orderType);// 业务类型：积分
			paramMap.put("orderTypeJF", Contants.BUSINESS_TYPE_JF);
//			paramMap.put("goodsType", Contants.SUB_ORDER_TYPE_00);
		} else {
			paramMap.put("orderType", Contants.CERATE_TYPE_ADMIN_0);// 业务类型：广发商城
			paramMap.put("orderTypeYG", Contants.BUSINESS_TYPE_YG);
			paramMap.put("orderTypeFQ", Contants.BUSINESS_TYPE_FQ);
		}
		try {
			// 查询子订单数据
			Pager<OrderSubModel> pager = orderSubDao.findLikeByPageForBack(paramMap, pageInfo.getOffset(),
					pageInfo.getLimit());
			List<OrderSubModel> orderSubModelList = pager.getData();
			// 遍历orderSubModel，构造返回值
			for (OrderSubModel orderSubModel : orderSubModelList) {
				RequestOrderDto requestOrderDto = new RequestOrderDto();
				//处理敏感数据
				//处理ordersub敏感信息
				orderSubModel.setCardno("");
				orderSubModel.setBankNbr("");
				orderSubModel.setAcctNo("");
				orderSubModel.setCardnoBenefit("");
				orderSubModel.setValidateCode("");
				orderSubModel.setBonusTraceNo("");
				orderSubModel.setMsgContent("");
				orderSubModel.setBankNbr2("");

				requestOrderDto.setOrderSubModel(orderSubModel);
				if (isNotBlank(orderSubModel.getOrdermainId())) {
					OrderMainModel orderMainModel = orderMainDao.findById(orderSubModel.getOrdermainId());
					if (orderMainModel == null) {
						response.setError("orderMainModel.can.not.be.null");
						return response;
					}
					requestOrderDto.setOrderMainModel(orderMainModel);
				}

				// 银行订单号
				TblOrderExtend1Model tblOrderExtend1Model = tblOrderExtend1Dao
						.findByOrderId(orderSubModel.getOrderId());
				if (tblOrderExtend1Model != null) {
					requestOrderDto.setTblOrderExtend1Model(tblOrderExtend1Model);
				}
				// 单品Id
				// 分期编码
				String goodsId = orderSubModel.getGoodsId();
				ItemModel itemModel = itemService.findById(goodsId);
				if (itemModel != null) {
					requestOrderDto.setMid(itemModel.getMid());
					requestOrderDto.setXid(itemModel.getXid());
				}
				requestOrderDtos.add(requestOrderDto);
			}
			response.setResult(new Pager<RequestOrderDto>(pager.getTotal(), requestOrderDtos));
			return response;
		} catch (Exception e) {
			log.error("reject goods query error{}", Throwables.getStackTraceAsString(e));
			response.setError("reject.goods.query.error");
			return response;
		}

	}

	/**
	 * 根据orderId查询退货撤单履历表
	 * 
	 * @param orderId
	 * @return
	 */
	public Response<List<OrderReturnTrackDetailModel>> findReturnTrackByOrderId(String orderId) {
		Response<List<OrderReturnTrackDetailModel>> response = new Response<>();
		try {
			// 检验orderId是否为空
			checkArgument(StringUtils.isNotBlank(orderId), "orderId is null");
			// 根据orderId查找撤单履历表
			List<OrderReturnTrackDetailModel> orderReturnTrackDetailModels = orderReturnTrackDetailDao
					.findReturnByOrderId(orderId);
			if (orderReturnTrackDetailModels == null) {
				response.setError("orderReturnTrackDetailModels.null");
				return response;
			} else {
				response.setResult(orderReturnTrackDetailModels);
				return response;
			}
		} catch (Exception e) {
			log.info("find.orderReturnTrackDetail.error{}", Throwables.getStackTraceAsString(e));
			response.setError("find.orderReturnTrackDetail.error");
			return response;
		}
	}

	/**
	 * 供应商拒绝退货申请
	 * 
	 * @param orderSubModel
	 * @param orderReturnTrackDetailModelNew
	 * @param orderDoDetailModel
	 * @return
	 */
	public Response<Map<String, Object>> refuseReturn(OrderSubModel orderSubModel,
			OrderReturnTrackDetailModel orderReturnTrackDetailModelNew, OrderDoDetailModel orderDoDetailModel,
			User user) {
		Response<Map<String, Object>> result = new Response<>();
		Map<String, Object> map = Maps.newHashMap();
		MessageDto messageDto = new MessageDto();
		String orderId=orderSubModel.getOrderId();
		// 获取分布式锁
		String lockId = DistributedLocks.acquireLockWithTimeout(jedisTemplate, "ORFR" + orderId, 50, 10000);
		if (lockId == null) {
			log.info("OrderReturnServiceImpl refuseReturn repeat actions，orderId："+orderId);
			result.setError("updateOrderSignVendor.repeat.actions");
			return result;
		}
		try {
			// 推送消息
			messageDto.setCreateOper(user.getId());
			messageDto.setUserType(Contants.ORDER_USER_TYPE_01);
			messageDto.setCustId(orderSubModel.getCreateOper());
			messageDto.setOrderStatus(orderSubModel.getCurStatusId());
			messageDto.setGoodName(orderSubModel.getGoodsNm());
			messageDto.setOrderId(orderSubModel.getOrderId());
			messageDto.setVendorId(orderSubModel.getVendorId());
			// 退货事务
			Boolean resultFlag = orderReturnManager.updateReturnVendor(orderSubModel, orderDoDetailModel,
					orderReturnTrackDetailModelNew, messageDto);

			if ((Boolean.FALSE).equals(resultFlag)) {
				DistributedLocks.releaseLock(jedisTemplate, "ORFR" + orderId,lockId);
				result.setError("current.order.status.illegal");
				return result;
			} else {
				DistributedLocks.releaseLock(jedisTemplate, "ORFR" + orderId,lockId);
				map.put("result", Boolean.TRUE);
				result.setResult(map);
				return result;
			}
		}catch (IllegalArgumentException e){
			DistributedLocks.releaseLock(jedisTemplate, "ORFR" + orderId,lockId);
			result.setError(e.getMessage());
			return result;
		} catch (Exception e) {
			DistributedLocks.releaseLock(jedisTemplate, "ORFR" + orderId,lockId);
			log.info("OrderReturnServiceImpl.refuseReturn.error{}", Throwables.getStackTraceAsString(e));
			result.setError("OrderReturnServiceImpl.refuseReturn.error");
			return result;
		}
	}

	/**
	 * 供应商同意退货申请
	 * 
	 * @param paramMap
	 * @return
	 */
	public Response agreeReturn(Map<String, String> paramMap, User user) {

		Response response = Response.newResponse();
		if (paramMap.isEmpty()) {
			log.error("OrderReturnService.agreeReturn.error,paramMap be empty");
			response.setError("orderSubModel.is.null");
			return response;
		}
		String orderId = paramMap.get("orderId");
		if (StringUtils.isBlank(orderId)){
			log.error("OrderReturnService.agreeReturn.error,orderId be empty" );
			response.setError("orderId.can.not.be.empty");
			return response;
		}
		// 获取分布式锁
		String lockId = DistributedLocks.acquireLockWithTimeout(jedisTemplate, "VRMA" + orderId, 50, 10000);
		if (lockId == null) {
			log.info("OrderReturnServiceImpl agreeReturn repeat actions，orderId："+orderId);
			response.setError("updateOrderSignVendor.repeat.actions");
			return response;
		}
		try {
			String typeFlag = paramMap.get("typeFlag");
			String vendorId = user.getVendorId();
			String userId = user.getId();
			String season = paramMap.get("season");
			String supplement = paramMap.get("supplement");
			// 校验订单ID,供应商ID，区分标示
//			checkArgument(StringUtils.isNotBlank(orderId), "orderId.can.not.be.empty");
			checkArgument(StringUtils.isNotBlank(vendorId) || StringUtils.isNotBlank(userId),
					"vendorId.and.userId.be.empty");
//			app端退货申请理由为空
//			checkArgument(StringUtils.isNotBlank(season), "season.be.empty");
			// 查询当前表单数据
			OrderSubModel orderSubModel = orderSubDao.findById(orderId);
			// 校验返回结果是否为空
			if (orderSubModel == null) {
				DistributedLocks.releaseLock(jedisTemplate, "VRMA" + orderId,lockId);
				response.setError("orderSubModel.is.null");
				return response;
			}
			Map<String, Object> map = new HashMap<>();
			map.put("orderSubModel", orderSubModel);
			map.put("vendorId", vendorId);
			map.put("season", season);
			map.put("supplement", supplement);
			map.put("userType", Contants.VENDOR_USER_TYPE_2);
			map.put("id", userId);
			// 校验订单是否超过180天，订单不能撤销。
			TblOrderHistoryModel tblOrderHistoryModel = tblOrderHistoryDao.findById(orderSubModel.getOrderId());
			if (tblOrderHistoryModel != null) {
				DistributedLocks.releaseLock(jedisTemplate, "VRMA" + orderId,lockId);
				log.error("order.time.out");
				response.setError("order.time.out");
				return response;
			}

			// 状态已经改变，不允许修改订单
			if (Strings.isNullOrEmpty(typeFlag)) {
				if (!Contants.SUB_ORDER_STATUS_0334.equals(orderSubModel.getCurStatusId())) {
					DistributedLocks.releaseLock(jedisTemplate, "VRMA" + orderId,lockId);
					log.error("current.order.status.illegal");
					response.setError("current.order.status.illegal");
					return response;
				}
			}else {
				if (!(Contants.SUB_ORDER_STATUS_0310.equals(orderSubModel.getCurStatusId())
						|| Contants.SUB_ORDER_STATUS_0335.equals(orderSubModel.getCurStatusId()))){
					DistributedLocks.releaseLock(jedisTemplate, "VRMA" + orderId,lockId);
					log.error("current.order.status.illegal");
					response.setError("current.order.status.illegal");
					return response;
				}
			}
			// 广发商城的业务
			if (!Contants.BUSINESS_TYPE_JF.equals(orderSubModel.getOrdertypeId())) {
				// 供应商退货
				int hour = LocalDateTime.now().getHourOfDay();
				// 业务1800至2400不能点击退货
				if (Integer.parseInt(timeStart) <= hour && hour <= Integer.parseInt(timeEnd)) {
					DistributedLocks.releaseLock(jedisTemplate, "VRMA" + orderId,lockId);
					log.error("current.order.not.time");
					response.setError("current.order.not.time");
					return response;
				}
			}

			// 当为供应商系统时状态置为 退货成功
			map.put("curStatusId", Contants.SUB_ORDER_STATUS_0327);
			map.put("curStatusNm", Contants.SUB_ORDER_RETURN_SUCCEED);
			response = updateReturn(map);
			DistributedLocks.releaseLock(jedisTemplate, "VRMA" + orderId,lockId);
			return response;
		} catch (IllegalArgumentException e) {
			DistributedLocks.releaseLock(jedisTemplate, "VRMA" + orderId,lockId);
			log.error("OrderReturnService.agreeReturn.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("OrderReturnServiceImpl.refuseReturn.error");
			return response;
		}catch (TradeException e) {
			DistributedLocks.releaseLock(jedisTemplate, "VRMA" + orderId,lockId);
			log.error("OrderReturnService.agreeReturn.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError("OrderReturnServiceImpl.refuseReturn.error");
			return response;
		}catch (Exception e) {
			DistributedLocks.releaseLock(jedisTemplate, "VRMA" + orderId,lockId);
			log.error("OrderReturnService.agreeReturn.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderReturnServiceImpl.refuseReturn.error");
			return response;
		}
	}

	private Response updateReturn(Map<String, Object> paramMap) throws Exception {
		OrderSubModel orderSubModel = (OrderSubModel) paramMap.get("orderSubModel");
		String id = (String) paramMap.get("id");
		String season = (String) paramMap.get("season");
		String supplement = (String) paramMap.get("supplement");
		String curStatusId = (String) paramMap.get("curStatusId");
		String curStatusNm = (String) paramMap.get("curStatusNm");
		String userType = (String) paramMap.get("userType");
		OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
		Response response = Response.newResponse();

		orderSubModel.setCurStatusId(curStatusId);
		orderSubModel.setCurStatusNm(curStatusNm);
		// 构造订单履历信息
		orderDoDetailModel.setOrderId(orderSubModel.getOrderId());
		orderDoDetailModel.setModifyOper(id);
		orderDoDetailModel.setCreateOper(id);
		orderDoDetailModel.setStatusId(curStatusId);
		orderDoDetailModel.setStatusNm(curStatusNm);
		orderDoDetailModel.setDoUserid(id);
		orderDoDetailModel.setUserType(userType);
		orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);
		// 构造退货履历信息
		OrderReturnTrackDetailModel orderRrturnTrackDetailModel = new OrderReturnTrackDetailModel();
		orderRrturnTrackDetailModel.setOrderId(orderSubModel.getOrderId());
		orderRrturnTrackDetailModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0327);
		orderRrturnTrackDetailModel.setCurStatusNm(Contants.SUB_ORDER_RETURN_SUCCEED);
		orderRrturnTrackDetailModel.setOrdertypeId(orderSubModel.getOrdertypeId());
		orderRrturnTrackDetailModel.setOrdertypeNm(orderSubModel.getOrdertypeNm());
		orderRrturnTrackDetailModel.setOperationType(Contants.ORDER_INTEGER_PARTBACK_OPERATIONTYPE_RETURN);
		orderRrturnTrackDetailModel.setMemo(StringUtils.isNotBlank(season) ? season.trim() : null);
		orderRrturnTrackDetailModel.setMemoExt(StringUtils.isNotBlank(supplement) ? supplement.trim() : null);
		orderRrturnTrackDetailModel.setDoDesc("卖家同意退货，等待收货");
		orderRrturnTrackDetailModel.setCreateOper(id);
		orderRrturnTrackDetailModel.setModifyOper(id);

		// 退货
		Boolean bool = orderSubManager.updateReturnVendor(orderSubModel, orderDoDetailModel, orderRrturnTrackDetailModel);

		// 推送消息
		MessageDto messageDto = new MessageDto();
		messageDto.setCreateOper(id);
		messageDto.setUserType(Contants.ORDER_USER_TYPE_01);
		messageDto.setCustId(orderSubModel.getCreateOper());
		messageDto.setOrderStatus(Contants.SUB_ORDER_STATUS_0327);
		messageDto.setGoodName(orderSubModel.getGoodsNm());
		messageDto.setOrderId(orderSubModel.getOrderId());
		messageDto.setVendorId(orderSubModel.getVendorId());
		newMessageService.insertUserMessage(messageDto);

		response.setResult(bool);
		return response;

	}
}
