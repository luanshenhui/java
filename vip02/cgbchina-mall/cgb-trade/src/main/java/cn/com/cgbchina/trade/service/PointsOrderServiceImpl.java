package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.related.model.InfoOutSystemModel;
import cn.com.cgbchina.related.service.InfoOutSystemService;
import cn.com.cgbchina.trade.dao.*;
import cn.com.cgbchina.trade.dto.OrderDetailDto;
import cn.com.cgbchina.trade.dto.OrderInfoDto;
import cn.com.cgbchina.trade.dto.OrderReturnDetailDto;
import cn.com.cgbchina.trade.model.*;

import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

import static com.google.common.base.Preconditions.checkArgument;

/**
 * Created by 11141021040453 on 16-4-15.
 */
@Service
@Slf4j
public class PointsOrderServiceImpl implements PointsOrderService {

	private final static JsonMapper JSON_MAPPER = JsonMapper.nonEmptyMapper();
	private final static DateTimeFormatter DFT = DateTimeFormat.forPattern("yyyyMMdd");// 字符串转时间

	private enum OrderEnum {
        ZERO("0"), ONE("1"), Z3ONE("0001"), Z3TWO("0002"), Z3THREE("0003"), Z3FOUR("0004"), Z3FIVE("0005"), jpArea("00") // 常规礼品分区代码																															// jpArea;
        , cxArea("01") // 促销分区代码 cxArea
        , djArea("02") // 白金顶级分区代码 djArea
        , xwArea("03") // 希望分区代码 xwArea
        , zzArea("04") // 增值服务分区代码 zzArea
        , ncmArea("05") // 新聪明卡分区代码 ncmArea
        , ocmArea("06") // 旧聪明卡分区代码 ocmArea
        , bjArea("07"); // 半价分区代码 bjArea

        private String value;

		OrderEnum(String value) {
			this.value = value;
		}

		private String getValue() {
			return value;
		}
	}

	@Resource
	OrderSubDao orderSubDao;
	@Resource
	TblOrderHistoryDao tblOrderHistoryDao;
	@Resource
	OrderPartBackDao orderPartBackDao;
	@Resource
	OrderMainDao orderMainDao;
	@Resource
	OrderTransDao orderTransDao;
	@Resource
	OrderDoDetailDao orderDoDetailDao;
	@Resource
	OrderReturnTrackDetailDao orderReturnTrackDetailDao;
	@Resource
	TblOrdermainHistoryDao tblOrdermainHistoryDao;
	@Resource
	TblOrderExtend1Dao tblOrderExtend1Dao;
	@Resource
	InfoOutSystemService infoOutSystemService;
	@Resource
	ItemService itemService;
	@Resource
	OrderVirtualDao orderVirtualDao;
	@Resource
	GoodsPayWayService goodsPayWayService;
	@Resource
	GoodsService goodsService;

	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	/**
	 * 查找账户
	 *
	 * @param pageNo
	 * @return
	 */
	public Response<Pager<OrderInfoDto>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
											  @Param("orderId") String orderId, @Param("goodsType") String goodsType,
											  @Param("curStatusId") String curStatusId, @Param("sourceId") String sourceId,
											  @Param("goodsId") String goodsId, @Param("memberName") String memberName, @Param("vendorSnm") String vendorSnm,
											  @Param("startTime") String startTime, @Param("endTime") String endTime, @Param("cardno") String cardno,
											  @Param("custType") String custType, @Param("limitFlag") String limitFlag, @Param("") User user, @Param("searchType")String searchType) {
		// 构造返回值及参数
		Response<Pager<OrderInfoDto>> response = new Response<Pager<OrderInfoDto>>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Map<String, Object> paramMap = Maps.newHashMap();
		// 默认选择逻辑删除
		paramMap.put("delFlag", Contants.DEL_INTEGER_FLAG_0);
		// 积分商城
		paramMap.put("ordertypeId", Contants.BUSINESS_TYPE_JF);
		// 判断订单账号是否为空
		if (StringUtils.isNotBlank(orderId)) {
			paramMap.put("orderId", orderId.trim());
		}
		// 判断订单类型是否为空
		if (StringUtils.isNotBlank(goodsType)) {
			paramMap.put("goodsType", goodsType);
		}
		// 判断订单状态是否为空
		if (StringUtils.isNotBlank(curStatusId)) {
			paramMap.put("curStatusId", curStatusId);
		}
		// 判断渠道是否为空
		if (StringUtils.isNotBlank(sourceId)) {
			paramMap.put("sourceId", sourceId);
		}
// Start 2016。10。28 yanjie.cao 试运行功能优化之订单管理缺少供应商名称查询
		// 判断供应商名称为空
		if (StringUtils.isNotBlank(vendorSnm)) {
			paramMap.put("vendorSnm", vendorSnm.trim());
		}
//  End
		// 判断单品编码是否为空
		if (StringUtils.isNotBlank(goodsId)) {
			Response<List<String>> itemCodeListByMidOrXidResponse = itemService.findItemCodeListByMidOrXid(goodsId);
			if (!itemCodeListByMidOrXidResponse.isSuccess()) {
				log.error("OrderService find ,itemService findItemCodeListByMidOrXid be wrong");
				response.setError("ItemServiceImpl.findItemCodeListByMidOrXid.error");
				return response;
			}
			List<String> itemCodeListByMidOrXidResponseResult = itemCodeListByMidOrXidResponse.getResult();
			if (itemCodeListByMidOrXidResponseResult != null && !itemCodeListByMidOrXidResponseResult.isEmpty()) {
				paramMap.put("goodsIdList", itemCodeListByMidOrXidResponseResult);
			}
		}
		// 判断客户名称是否为空
		if (StringUtils.isNotBlank(memberName)) {
			paramMap.put("memberName", memberName);
		}
		// searchType为空时表示初始化查询订单，默认为一个月
		if(Strings.isNullOrEmpty(searchType)){
			Date today = new Date();
			startTime = DateHelper.date2string(DateHelper.addDay(today, -30), DateHelper.YYYY_MM_DD);
			endTime =  DateHelper.date2string(today, DateHelper.YYYY_MM_DD);
		}
		// 判断时间是否为空
		if (StringUtils.isNotBlank(startTime)) {
			paramMap.put("startTime", startTime);
		}
		if (StringUtils.isNotBlank(endTime)) {
			paramMap.put("endTime", endTime);
		}
		// 判断银行卡号是否为空
		if (StringUtils.isNotBlank(cardno)) {
			paramMap.put("cardno", cardno);
		}
		// 判断客户级别是否为空
		if (StringUtils.isNotBlank(custType)) {
			paramMap.put("custType", custType);
		}
		try {
			// 获取子订单列表数据
			// 获取子订单列表数据 六个月之前订单取自history表
			Pager<OrderSubModel> pager = new Pager<>();
			List<OrderSubModel> orderSubModelList = new ArrayList<OrderSubModel>();
			Long total=0L;
			if (StringUtils.isEmpty(limitFlag)) {
				pager = orderSubDao.findLikeByPage(paramMap, pageInfo.getOffset(), pageInfo.getLimit());
				orderSubModelList = pager.getData();
				total=pager.getTotal();
			} else {
				Pager<TblOrderHistoryModel> pagerTblOrderHistory = tblOrderHistoryDao.findLikeByPage(paramMap,
						pageInfo.getOffset(), pageInfo.getLimit());
				List<TblOrderHistoryModel> tblOrderHistoryModelList = pagerTblOrderHistory.getData();
				for (TblOrderHistoryModel tblOrderHistoryModel : tblOrderHistoryModelList) {
					OrderSubModel orderSubModel = new OrderSubModel();
					BeanMapper.copy(tblOrderHistoryModel, orderSubModel);
					orderSubModelList.add(orderSubModel);
				}
				total=pagerTblOrderHistory.getTotal();
			}
			// 获取单品xid
			List<ItemModel> itemModelList = Lists.newArrayList();
			if (orderSubModelList != null && !orderSubModelList.isEmpty()) {
				List<String> itemCodeList = Lists.newArrayList();
				for (OrderSubModel orderSubModel : orderSubModelList) {
					itemCodeList.add(orderSubModel.getGoodsId());
				}
				// 去重 itemCode
				HashSet itemCodeSet = new HashSet(itemCodeList);
				itemCodeList.clear();
				itemCodeList.addAll(itemCodeSet);
				Response<List<ItemModel>> itemModelReponse = new Response<>();
				itemModelReponse = itemService.findByCodesAll(itemCodeList);
				if (!itemModelReponse.isSuccess() || itemModelReponse.getResult() == null
						|| itemModelReponse.getResult().isEmpty()) {
					log.error("OrderService find ,itemService findByCodesAll be empty");
					response.setError("ItemModelList.be.null");
					return response;
				}
				itemModelList = itemModelReponse.getResult();
			}
			List<OrderInfoDto> orderInfoDtos = new ArrayList<OrderInfoDto>();
			OrderInfoDto orderInfoDto = null;
			// 遍历orderSubModel，构造返回值
			for (OrderSubModel orderSubModel : orderSubModelList) {
				orderInfoDto = new OrderInfoDto();
				orderInfoDto.setOrderSubModel(orderSubModel);
				/*
				 * 设置设置查看物流权限标识 当订单类型为实物-SUB_ORDER_TYPE_00且订单状态为SUB_ORDER_STATUS_0309-已发货，
				 * SUB_ORDER_STATUS_0380-拒绝签收，SUB_ORDER_STATUS_0381-无人签收， SUB_ORDER_STATUS_0310-已签收，
				 * SUB_ORDER_STATUS_0334-退货申请，SUB_ORDER_STATUS_0327-退货成功， SUB_ORDER_STATUS_0335-拒绝退货申请时 拥有查看物流标识
				 * true——拥有
				 */
				if (Contants.SUB_ORDER_TYPE_00.equals(orderSubModel.getGoodsType())) {
					if (Contants.SUB_ORDER_STATUS_0309.equals(orderSubModel.getCurStatusId())
							|| Contants.SUB_ORDER_STATUS_0310.equals(orderSubModel.getCurStatusId())
							|| Contants.SUB_ORDER_STATUS_0380.equals(orderSubModel.getCurStatusId())
							|| Contants.SUB_ORDER_STATUS_0381.equals(orderSubModel.getCurStatusId())
							|| Contants.SUB_ORDER_STATUS_0334.equals(orderSubModel.getCurStatusId())
							|| Contants.SUB_ORDER_STATUS_0335.equals(orderSubModel.getCurStatusId())
							|| Contants.SUB_ORDER_STATUS_0327.equals(orderSubModel.getCurStatusId())) {
						orderInfoDto.setOrderTransFlag(Boolean.TRUE);

					} else {
						orderInfoDto.setOrderTransFlag(Boolean.FALSE);
					}
				} else {
					orderInfoDto.setOrderTransFlag(Boolean.FALSE);
				}
				// set xid
				String itemcode = orderSubModel.getGoodsId();
				if (StringUtils.isNotBlank(itemcode)) {
					for (ItemModel itemModel : itemModelList) {
						if (itemcode.equals(itemModel.getCode())) {
							// 单品编码
							orderInfoDto.setMid(itemModel.getMid());
							// 礼品编码
							orderInfoDto.setXid(itemModel.getXid());
						}
					}
				}
				orderInfoDtos.add(orderInfoDto);
			}
			response.setResult(new Pager<OrderInfoDto>(total, orderInfoDtos));
			return response;
		} catch (Exception e) {
			log.error("PointsOrderServiceImpl.find.qury.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("PointsOrderServiceImpl.find.qury.error");
			return response;
		}
	}

	/**
	 * 查看订单详情
	 *
	 * @param orderId
	 * @param user
	 * @return
	 */
	@Override
	public Response<OrderDetailDto> findOrderInfo(@Param("id") String orderId, @Param("") User user) {
		Response<OrderDetailDto> response = new Response<OrderDetailDto>();
		try {
			String customerId = user.getCustId();
			OrderDetailDto orderDetailDto = new OrderDetailDto();
			checkArgument(StringUtils.isNotBlank(orderId), "orderId.can.not.be.empty");
			// 获取子订单详情
			OrderSubModel orderSubModel = null;
			orderSubModel = orderSubDao.findById(orderId);
			if (orderSubModel == null) {
				TblOrderHistoryModel tblOrderHistoryModel = tblOrderHistoryDao.findById(orderId);
				if (tblOrderHistoryModel == null) {
					log.error("PointsOrderServiceImpl.findOrderInfo.error.orderSubModel.can.not.be.null");
					response.setError("orderSubModel.be.null");
					return response;
				}
				orderSubModel = new OrderSubModel();
				BeanMapper.copy(tblOrderHistoryModel, orderSubModel);
			}
			if (!Contants.BUSINESS_TYPE_JF.equals(orderSubModel.getOrdertypeId())) {
				log.error("OrderService findOrderInfo error,OrdertypeId.be.wrong");
				response.setError("ordertypeId.be.wrong");
				return response;
			}
			// 校验主订单号
			String ordermainId = orderSubModel.getOrdermainId();
			checkArgument(StringUtils.isNotBlank(ordermainId), "ordermainId.can.not.be.empty");
			// 获取主订单收货人信息
			OrderMainModel orderMainModel = null;
			orderMainModel = orderMainDao.findById(ordermainId);
			if (orderMainModel == null) {
				TblOrdermainHistoryModel tblOrdermainHistoryModel = tblOrdermainHistoryDao.findById(ordermainId);
				if (tblOrdermainHistoryModel == null) {
					log.error("PointsOrderServiceImpl.findOrderInfo.error.orderMainModel.can.not.be.null");
					response.setError("orderMainModel.be.null");
					return response;
				}
				orderMainModel = new OrderMainModel();
				BeanMapper.copy(tblOrdermainHistoryModel, orderMainModel);
			}
			// 获取物流信息
			OrderTransModel orderTransModel = null;
			orderTransModel = orderTransDao.findByOrderId(orderId);
			// 获取订单履历
			OrderDoDetailModel orderDoDetailModel = null;
			List<OrderDoDetailModel> orderDoDetailModels = new ArrayList<OrderDoDetailModel>();
			orderDoDetailModels = orderDoDetailDao.findByOrderId(orderId);
			// 构造返回值DTO
			// 支付日期（yyyyMMdd转换为yyyy-MM-dd）
			if (orderSubModel.getBonusTrnDate() != null && orderSubModel.getBonusTrnDate().length() == 8) {
				DateTime startTime = DFT.parseDateTime(orderSubModel.getBonusTrnDate());
				orderSubModel.setBonusTrnDate(sdf.format(startTime.toDate()));
			}
			// 时间（HHmmss转换为HH:mm:ss）
			if (orderSubModel.getBonusTrnTime() != null && orderSubModel.getBonusTrnTime().length() == 6) {
				Date time = new SimpleDateFormat("HHmmss").parse(orderSubModel.getBonusTrnTime());
				orderSubModel.setBonusTrnTime(new SimpleDateFormat("HH:mm:ss").format(time));
			}
			List<TblOrderExtend1Model> tblOrderExtend1ModelList = Lists.newArrayList();
			tblOrderExtend1ModelList = tblOrderExtend1Dao.findListByOrderId(orderId);
			if (tblOrderExtend1ModelList != null && !tblOrderExtend1ModelList.isEmpty()) {
				TblOrderExtend1Model tblOrderExtend1Model = new TblOrderExtend1Model();
				tblOrderExtend1Model = tblOrderExtend1ModelList.get(0);
				orderDetailDto.setTblOrderExtend1Model(tblOrderExtend1Model);
			}
			orderDetailDto.setOrderSubModel(orderSubModel);
			orderDetailDto.makeVoucherFlag();
			orderDetailDto.makeBonusTotalFlag();
			orderDetailDto.makeUitdrtamtFlag();
			String cardNo = orderMainModel.getCardno();
			String cardNo1 = orderMainModel.getCardno();
			if (StringUtils.isNotBlank(cardNo)) {
				cardNo = StringUtils.leftPad(StringUtils.right(cardNo, 4), StringUtils.length(cardNo), "*");
				orderMainModel.setCardno(cardNo);
			}
			orderDetailDto.setOrderMainModel(orderMainModel);
			orderDetailDto.setOrderTransModel(orderTransModel);
			orderDetailDto.setOrderDoDetailModels(orderDoDetailModels);
			// 获取为020码
			if (Contants.SUB_ORDER_TYPE_02.equals(orderSubModel.getGoodsType())) {
				Response<List<InfoOutSystemModel>> listResponse = new Response<>();
				listResponse = infoOutSystemService.findByOrderIdDesc(orderId);
				if (!listResponse.isSuccess()) {
					log.error("OrderService findOrderInfo error, infoOutSystemService.findByOrderIdDesc.failed");
					response.setError("infoOutSystemService.findByOrderIdDesc.failed");
					return response;
				}
				List<InfoOutSystemModel> infoOutSystemModelList = Lists.newArrayList();
				infoOutSystemModelList = listResponse.getResult();
				if (infoOutSystemModelList != null && !infoOutSystemModelList.isEmpty()) {
					InfoOutSystemModel infoOutSystemModel = new InfoOutSystemModel();
					infoOutSystemModel = infoOutSystemModelList.get(0);
					String verifyCode = infoOutSystemModel.getVerifyCode();
					String validateStatus = infoOutSystemModel.getValidateStatus();
					// 使用状态 00-未使用 01-已使用
					orderDetailDto.setValidateStatus(validateStatus);
					// 商城
					if (StringUtils.isNotBlank(customerId)) {
						orderDetailDto.setVerifyCode(verifyCode);
					} else {
						// 脱敏 显示后三位
						String newVerifyCode = StringUtils.leftPad(StringUtils.right(verifyCode, 3),
								StringUtils.length(verifyCode), "*");
						orderDetailDto.setVerifyCode(newVerifyCode);
					}
				}
			}
			// 获取单品编码
			String itemCode = orderSubModel.getGoodsId();
			checkArgument(StringUtils.isNotBlank(itemCode), "itemCode.can.not.be.empty");
			Response<ItemModel> itemModelResponse = itemService.findByCodeAll(itemCode);
			// Response<ItemModel>itemModelResponse=itemService.findByItemcode(itemCode);
			if (!itemModelResponse.isSuccess() || itemModelResponse.getResult() == null) {
				log.error("OrderService findOrderInfo error, itemService findByItemcode failed");
				response.setError("itemModel.be.null");
				return response;
			}
			ItemModel itemModel = new ItemModel();
			itemModel = itemModelResponse.getResult();
			orderDetailDto.setMid(itemModel.getMid());
			// 礼品编码
			orderDetailDto.setXid(itemModel.getXid());

			String goodsPaywayId = orderSubModel.getGoodsPaywayId();
			String goodsCode = orderSubModel.getGoodsCode();
			if (StringUtils.isBlank(goodsPaywayId)) {
				log.error("OrderService findOrderInfo error,orderId:" + orderSubModel.getOrderId()
						+ "goodsPaywayId be null");
				response.setError("goodsPaywayId.be.empty");
				return response;
			}
			if (StringUtils.isBlank(goodsCode)) {
				log.error(
						"OrderService findOrderInfo error,orderId:" + orderSubModel.getOrderId() + "goodsCode be null");
				response.setError("goodsCode.be.empty");
				return response;
			}
			Response<TblGoodsPaywayModel> tblGoodsPaywayModelResponse = goodsPayWayService
					.findGoodsPayWayInfo(goodsPaywayId);
			if (!tblGoodsPaywayModelResponse.isSuccess() || tblGoodsPaywayModelResponse.getResult() == null) {
				log.error("OrderService findOrderInfo error,tblGoodsPaywayModel.be.empty");
				response.setError("tblGoodsPaywayModel.be.empty");
				return response;
			}
			TblGoodsPaywayModel tblGoodsPaywayModel = tblGoodsPaywayModelResponse.getResult();
			Response<GoodsModel> goodsModelResponse = goodsService.findById(goodsCode);
			if (!goodsModelResponse.isSuccess() || goodsModelResponse.getResult() == null) {
				log.error("OrderService findOrderInfo error,goodsModel.be.empty");
				response.setError("goodsModel.be.empty");
				return response;
			}
			GoodsModel goodsModel = goodsModelResponse.getResult();
			String memberLevel = tblGoodsPaywayModel.getMemberLevel();
			String regionType = goodsModel.getRegionType();
			if (OrderEnum.cxArea.getValue().equals(regionType)) {
				// doNothing
			} else if (OrderEnum.djArea.getValue().equals(regionType)) {
				if (OrderEnum.Z3FIVE.getValue().equals(memberLevel)) {
					orderDetailDto.setExchangeName("积分+现金");
				} else if (OrderEnum.Z3TWO.getValue().equals(memberLevel)) {
					orderDetailDto.setExchangeName("顶级/增值白金");
				} else {
					orderDetailDto.setExchangeName("顶级/增值白金");
				}
			} else if (OrderEnum.xwArea.getValue().equals(regionType)) {
				if (OrderEnum.Z3FIVE.getValue().equals(memberLevel)) {
					orderDetailDto.setExchangeName("积分+现金");
				} else {
					orderDetailDto.setExchangeName("积分兑换价");
				}
			} else if (OrderEnum.zzArea.getValue().equals(regionType)) {
				if (OrderEnum.Z3FIVE.getValue().equals(memberLevel)) {
					orderDetailDto.setExchangeName("积分+现金");
				} else {
					orderDetailDto.setExchangeName("积分兑换价");
				}
			} else {
				if (OrderEnum.Z3ONE.getValue().equals(memberLevel)) {
					orderDetailDto.setExchangeName("尊越/臻享白金");
				} else if (OrderEnum.Z3TWO.getValue().equals(memberLevel)) {
					orderDetailDto.setExchangeName("顶级/增值白金");
				} else if (OrderEnum.Z3THREE.getValue().equals(memberLevel)) {
					orderDetailDto.setExchangeName("VIP");
				} else if (OrderEnum.Z3FOUR.getValue().equals(memberLevel)) {
					orderDetailDto.setExchangeName("生日折扣");
				} else if (OrderEnum.Z3FIVE.getValue().equals(memberLevel)) {
					orderDetailDto.setExchangeName("积分+现金");
				} else {
					orderDetailDto.setExchangeName("金普价");
				}
			}
			// 虚拟商品获取其他信息
			if (Contants.SUB_ORDER_TYPE_01.equals(orderSubModel.getGoodsType())) {
				List<OrderVirtualModel> orderVirtualModelList = orderVirtualDao.findByOrderId(orderId);
				if (orderVirtualModelList == null || orderVirtualModelList.isEmpty()) {
					log.error("OrderService findOrderInfo error,orderVirtualModelList.be.empty");
					response.setError("orderVirtualModelList.be.empty");
					return response;
				}
				// 理论只有一条 获取第一个
				OrderVirtualModel orderVirtualModel = orderVirtualModelList.get(0);
				String memberNm = orderVirtualModel.getVirtualMemberNm();
				String memberId = orderVirtualModel.getVirtualMemberId();
				String aviationType = orderVirtualModel.getVirtualAviationType();
				String attachName = orderVirtualModel.getAttachName();
				String attachIdentityCard = orderVirtualModel.getAttachIdentityCard();
				String entryCard = orderVirtualModel.getEntryCard();
//				当附属卡号未填时,entryId 为主卡号 此时页面不显示附属卡号 ,当附属卡号为主卡号时同上
				if (StringUtils.isNotEmpty(cardNo1)&&cardNo1.equals(entryCard)){
					entryCard=null;
					orderVirtualModel.setEntryCard(null);
				}
				orderDetailDto.setOrderVirtualModel(orderVirtualModel);
				if (StringUtils.isNotEmpty(memberId) || StringUtils.isNotEmpty(memberNm)
						|| StringUtils.isNotEmpty(aviationType) || StringUtils.isNotEmpty(attachName)
						|| StringUtils.isNotEmpty(attachIdentityCard) ||StringUtils.isNotEmpty(entryCard)) {
					orderDetailDto.setOtherFlag(Boolean.TRUE);
				}
			}

			response.setResult(orderDetailDto);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("PointsOrderServiceImpl findOrderInfo.error", Throwables.getStackTraceAsString(e));
			response.setError("PointsOrderServiceImpl.findOrderInfo.error");
			return response;
		}

	}

	/**
	 * 通过订单id查询退货信息或撤单信息
	 *
	 * @param orderId
	 * @return
	 */
	@Override
	public Response<OrderReturnDetailDto> findOrderReturnDetail(String orderId) {
		Response<OrderReturnDetailDto> response = new Response<>();
		try {
			checkArgument(StringUtils.isNotBlank(orderId), "orderId.can.not.be.empty");
			List<OrderReturnTrackDetailModel> orderReturnTrackDetailModels = Lists.newArrayList();
			Map<String, Object> paramMap = Maps.newHashMap();
			paramMap.put("orderId", orderId);
			orderReturnTrackDetailModels = orderReturnTrackDetailDao.findAllByOrderId(paramMap);
			if (orderReturnTrackDetailModels == null || orderReturnTrackDetailModels.isEmpty()) {
				response.setError("orderRrturnTrackDetailModels.be.null");
				return response;
			}
			String status = orderReturnTrackDetailModels.get(orderReturnTrackDetailModels.size() - 1).getCurStatusNm();
			OrderReturnDetailDto orderReturnDetailDto = new OrderReturnDetailDto();
			orderReturnDetailDto.setStatus(status);
			orderReturnDetailDto.setOrderRrturnTrackDetailModels(orderReturnTrackDetailModels);
			response.setResult(orderReturnDetailDto);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("PointsOrderServiceImpl.findOrderReturnDetail.error,error code: {}",
					Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("PointsOrderServiceImpl findOrderReturnDetail error,cause:{}",
					Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;

		}
	}
}
