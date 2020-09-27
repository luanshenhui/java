package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.*;
import cn.com.cgbchina.item.model.*;
import cn.com.cgbchina.item.service.*;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.item.service.PromotionPayWayService;
import cn.com.cgbchina.related.model.InfoOutSystemModel;
import cn.com.cgbchina.related.model.TblParametersModel;
import cn.com.cgbchina.related.service.BusinessService;
import cn.com.cgbchina.related.service.InfoOutSystemService;
import cn.com.cgbchina.rest.visit.model.order.O2OOrderInfo;
import cn.com.cgbchina.rest.visit.model.point.QueryPointResult;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfo;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfoResult;
import cn.com.cgbchina.rest.visit.service.coupon.CouponService;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.rest.visit.service.point.PointService;
import cn.com.cgbchina.trade.dao.*;
import cn.com.cgbchina.trade.dto.*;
import cn.com.cgbchina.trade.exception.TradeException;
import cn.com.cgbchina.trade.manager.*;
import cn.com.cgbchina.trade.model.*;
import cn.com.cgbchina.user.dto.MessageDto;
import cn.com.cgbchina.user.model.ACardCustToelectronbankModel;
import cn.com.cgbchina.user.model.EspCustNewModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.*;
import com.fasterxml.jackson.databind.JavaType;
import com.google.common.base.Joiner;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.exception.ServiceException;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.utils.DistributedLocks;
import com.spirit.user.User;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Strings.nullToEmpty;

/**
 * Created by yanjie.cao on 16-4-25.
 */
@Service
@Slf4j
public class OrderServiceImpl extends OrderDisplayService implements OrderService {
	private final static JavaType javaType = JsonMapper.JSON_NON_EMPTY_MAPPER.createCollectionType(ArrayList.class,
			OrderItemAttributeDto.class);
	private final static JsonMapper JSON_MAPPER = JsonMapper.nonEmptyMapper();
	private final static DateTimeFormatter DFT = DateTimeFormat.forPattern("yyyyMMdd");// 字符串转时间
	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	private enum OrderEnum {
		ZERO("0"), ONE("1"),TWO("2"), Z3ONE("0001"), Z3TWO("0002"), Z3THREE("0003"), Z3FOUR("0004"), Z3FIVE("0005"), jpArea("00") // 常规礼品分区代码																															// jpArea;
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
	OrderMainDao orderMainDao;
	@Resource
	OrderTransDao orderTransDao;
	@Resource
	OrderDoDetailDao orderDoDetailDao;
//	@Resource
//	OrderPartBackDao orderPartBackDao;
//	@Resource
//	OrderReturnTrackDao orderReturnTrackDao;
	@Resource
	TblEspCustCartDao tblEspCustCartDao;
	@Resource
	OrderVirtualDao orderVirtualDao;
	@Resource
	GoodsService goodsService;
	@Resource
	ItemService itemService;
	@Resource
	VendorService vendorService;
	@Resource
	CartServiceImpl cartService;
	@Resource
	MemberAddressService memberAddressService;
	@Resource
	PointRelatedService pointRelatedService;
	@Resource
	GoodsPayWayService goodsPayWayService;
	@Resource
	PointsPoolService pointsPoolService;
	@Resource
	MallPromotionService mallPromotionService;
	@Resource
	GoodsDetailService goodsDetailService;
	@Resource
	NewMessageService newMessageService;
	@Resource
	OrderSubManager orderSubManager;
	@Resource
	OrderTransManager orderTransManager;
	@Resource
	OrderDodetailManger orderDodetailManager;
	@Resource
	OrderMainManager orderMainManager;
	@Resource
	OrderReturnTrackManager orderReturnTrackManager;
	@Resource
	EspCustCartManager espCustCartManager;
	@Resource
	PriorJudgeService priorJudgeService;
	@Resource
	EspCustNewService espCustNewService;
	@Resource
	private PointService pointService;
	@Value("#{app.merchId}")
	String merchId;
	@Value("#{app.returl}")
	String returl;
	@Value("#{app.mainPrivateKey}")
	String mainPrivateKey;
	@Value("#{app.payAddress}")
	String payAddress;
	@Value("#{app.timeStart}")
	private String timeStart;
	@Value("#{app.timeEnd}")
	private String timeEnd;
	@Resource
	PaymentService paymentService;
	@Resource
	TblOrderHistoryDao tblOrderHistoryDao;
	@Resource
	TblOrdermainHistoryDao tblOrdermainHistoryDao;
	@Resource
	OrderReturnTrackDetailDao orderReturnTrackDetailDao;
	@Resource
	OrderTieinSaleService orderTieinSaleService;
	@Resource
	OrderDealService orderDealService;
	@Resource
	SmsMessageService smsMessageService;
	@Resource
	TblOrderExtend1Dao tblOrderExtend1Dao;
	@Resource
	InfoOutSystemService infoOutSystemService;
	@Resource
	OrderOutSystemService orderOutSystemService;
	@Resource
	PromotionPayWayService promotionPayWayService;
	@Resource
	AuctionRecordService auctionRecordService;
	@Resource
	OrderBackupDao orderBackupDao;
	@Resource
	PriceSystemService priceSystemService;
	@Resource
	ACardCustToelectronbankService aCardCustToelectronbankService;
	@Resource
	OrderTradeManager orderTradeManager;
	@Resource
	CouponService couponService;
	@Resource
	private CfgIntegraltypeService cfgIntegraltypeService;
	@Resource
	CouponScaleService couponScaleService;
	@Resource
	private OrderFQMainServiceImpl orderMainService;
	@Resource
	private OrderJFMainServiceImpl orderJFMainService;
	@Resource
	private OrderSubServiceImpl orderSubService;
	@Resource
	private RedisService redisService;
	@Autowired
	private JedisTemplate jedisTemplate;
	@Resource
	BusinessService businessService;



	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	DateFormat dfyyyymmdd = new SimpleDateFormat("yyyy-MM-dd");
	DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	/*
	 * // 本地缓存 private final LoadingCache<String, Optional<OrderSubModel>> cache;
	 *
	 * @Resource OrderPartBackManager orderPartBackManager;
	 *
	 * // 构造函数 public OrderServiceImpl() { cache = CacheBuilder.newBuilder().expireAfterAccess(5,
	 * TimeUnit.MINUTES).build(new CacheLoader<String, Optional<OrganiseModel>>() {
	 *
	 * @Override public Optional<OrganiseModel> load(String code) throws Exception {
	 *//* 允许为空 *//*
				 * return Optional.fromNullable(orderSubDao.findById(code)); } }); }
				 */

	/**
	 * @param pageNo
	 * @param size
	 * @param orderId 订单编号
	 * @param goodsType 订单类型
	 * @param sourceId 渠道
	 * @param startTime 开始时间
	 * @param endTime 中支时间
	 * @param goodsNm 商品名称
	 * @param memberName 客户
	 * @param vendorSnm 供应商
	 * @param curStatusId 订单状态
	 * @param ordertypeId 分期数
	 * @return
	 */
	@Override
	public Response<Pager<OrderInfoDto>> find(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("orderId") String orderId, @Param("goodsType") String goodsType, @Param("sourceId") String sourceId,
			@Param("startTime") String startTime, @Param("endTime") String endTime, @Param("goodsNm") String goodsNm,
			@Param("goodsId") String goodsId, @Param("cardno") String cardno, @Param("memberName") String memberName,
			@Param("vendorSnm") String vendorSnm, @Param("curStatusId") String curStatusId,
			@Param("ordertypeId") String ordertypeId, @Param("ordermainId") String ordermainId,
			@Param("limitFlag") String limitFlag, @Param("type") String type, @Param("") User user, @Param("searchType")String searchType) {
		// 构造返回值及参数
		Response<Pager<OrderInfoDto>> response = new Response<Pager<OrderInfoDto>>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Map<String, Object> paramMap = Maps.newHashMap();
		// 默认选择逻辑删除
		paramMap.put("delFlag", Contants.DEL_INTEGER_FLAG_0);
		// 判断分期类型为空
		if (StringUtils.isNotBlank(ordertypeId)) {
			paramMap.put("ordertypeId", ordertypeId);
		}
		// 广发 内管 供应商
		if (!Contants.BUSINESS_TYPE_JF.equals(ordertypeId)) {
			List<String> orderTypeIdList = Lists.newArrayList();
			// 商城默认不处理“虚拟商品”订单
			paramMap.put("goodsTypeFlag", Contants.SUB_ORDER_TYPE_01);
			// 非积分订单
			orderTypeIdList.add(Contants.BUSINESS_TYPE_YG);
			orderTypeIdList.add(Contants.BUSINESS_TYPE_FQ);
			paramMap.put("ordertypeIds", orderTypeIdList);
		}
		// 判断订单账号是否为空
		if (StringUtils.isNotBlank(orderId)) {
			paramMap.put("orderId", orderId.trim());
		}
		// 判断订单类型是否为空
		if (StringUtils.isNotBlank(goodsType)) {
			paramMap.put("goodsType", goodsType);
		}
		// 判断渠道是否为空
		if (StringUtils.isNotBlank(sourceId)) {
			paramMap.put("sourceId", sourceId);
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
		// 判断商品名称为空
		if (StringUtils.isNotBlank(goodsNm)) {
			paramMap.put("goodsNm", goodsNm.trim());
		}
		// 判断商品编码为空
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
		// 判断银行卡号为空
		if (StringUtils.isNotBlank(cardno)) {
			paramMap.put("cardno", cardno.trim());
		}
		// 判断客户名称为空
		if (StringUtils.isNotBlank(memberName)) {
			paramMap.put("memberName", memberName);
		}
		// 判断供应商为空
		if (StringUtils.isNotBlank(vendorSnm)) {
			paramMap.put("vendorSnm", vendorSnm.trim());
		}
		// 区分type为空内管系统 type -1，2，3，4，5供应商系统不同tap
		if (StringUtils.isEmpty(type)) {
			// 判断订单类型为空
			if (StringUtils.isNotBlank(curStatusId)) {
				paramMap.put("curStatusId", curStatusId);
			}
		} else {
			switch (type) {
			// 所有订单
			case Contants.VENDOR_ORDER_TYPE_1:
				paramMap.put("typeFlag1", "1");
				paramMap.put("curStatusId1", Contants.SUB_ORDER_STATUS_0301);
				if (StringUtils.isNotBlank(curStatusId)) {
					paramMap.put("curStatusId", curStatusId);
				}
				break;
			// 发货处理中
			case Contants.VENDOR_ORDER_TYPE_2:
				paramMap.put("curStatusId", Contants.SUB_ORDER_STATUS_0306);
				break;
			// 待发货订单
			case Contants.VENDOR_ORDER_TYPE_3:
				// 待发货状态码为支付成功
				paramMap.put("curStatusId", Contants.SUB_ORDER_STATUS_0308);
				break;
			// 已发货订单
			case Contants.VENDOR_ORDER_TYPE_4:
				paramMap.put("curStatusId", Contants.SUB_ORDER_STATUS_0309);
				break;
			// 已签收订单
			case Contants.VENDOR_ORDER_TYPE_5:
				paramMap.put("typeFlag", "1");
				paramMap.put("curStatusId", Contants.SUB_ORDER_STATUS_0310);
				paramMap.put("curStatusId1", Contants.SUB_ORDER_STATUS_8888);
				break;
			// 默认所有订单
			default:
				break;
			}
		}
		// 根据type添加供应商ID
		if (StringUtils.isNotBlank(type)) {
			// 获取供应商ID
			String vendorId = user.getVendorId();
			checkArgument(StringUtils.isNotBlank(vendorId), "vendorId.can.not.be.empty");
			paramMap.put("vendorId", vendorId);
			paramMap.put("vendorUser", "true");
			paramMap.put("type", type);
		}
		// 判断主订单号为空
		if (StringUtils.isNotBlank(ordermainId)) {
			paramMap.put("ordermainId", ordermainId.trim());
		}
		try {
			// 获取子订单列表数据
			// 获取子订单列表数据 六个月之前订单取自history表
			Pager<OrderSubModel> pager = new Pager<>();
			Long total=0L;
			List<OrderSubModel> orderSubModelList = new ArrayList<OrderSubModel>();
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
			// 获取单品mid
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
				// 置订单是否使用优惠券及积分标识 true-使用
				orderInfoDto.makeBonusTotalFlag();
				orderInfoDto.makeVoucherFlag();
				orderInfoDto.makeUitdrtamtFlag();
				/*
				 * 设置设置查看物流权限标识 当订单类型为实物-SUB_ORDER_TYPE_00且订单状态为SUB_ORDER_STATUS_0309-已发货，
				 * SUB_ORDER_STATUS_0380-拒绝签收，SUB_ORDER_STATUS_0381-无人签收， SUB_ORDER_STATUS_0310-已签收，
				 * SUB_ORDER_STATUS_0334-退货申请，SUB_ORDER_STATUS_0327-退货成功， SUB_ORDER_STATUS_0335-拒绝退货申请时 拥有查看物流标识
				 * true——拥有
				 */
				if (Contants.SUB_ORDER_TYPE_00.equals(orderSubModel.getGoodsType())) {
					if (Contants.SUB_ORDER_STATUS_0309.equals(orderSubModel.getCurStatusId())
							|| Contants.SUB_ORDER_STATUS_0380.equals(orderSubModel.getCurStatusId())
							|| Contants.SUB_ORDER_STATUS_0381.equals(orderSubModel.getCurStatusId())
							|| Contants.SUB_ORDER_STATUS_0310.equals(orderSubModel.getCurStatusId())
							|| Contants.SUB_ORDER_STATUS_0334.equals(orderSubModel.getCurStatusId())
							|| Contants.SUB_ORDER_STATUS_0327.equals(orderSubModel.getCurStatusId())
							|| Contants.SUB_ORDER_STATUS_0335.equals(orderSubModel.getCurStatusId())) {
						orderInfoDto.setOrderTransFlag(Boolean.TRUE);

					} else {
						orderInfoDto.setOrderTransFlag(Boolean.FALSE);
					}
				} else {
					orderInfoDto.setOrderTransFlag(Boolean.FALSE);
				}
				// set mid
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
				// 售价
				if (Contants.BUSINESS_TYPE_YG.equals(orderSubModel.getOrdertypeId())) {
					orderInfoDto.setPrice(orderSubModel.getTotalMoney());
				}
				if (Contants.BUSINESS_TYPE_FQ.equals(orderSubModel.getOrdertypeId())) {
					BigDecimal totalMoney = orderSubModel.getTotalMoney();
					BigDecimal uitdrtamt = orderSubModel.getUitdrtamt();
					BigDecimal voucherPrice = orderSubModel.getVoucherPrice();
					BigDecimal price = BigDecimal.ZERO.setScale(2);
					if (totalMoney != null) {
						price = price.add(totalMoney);
					}
					if (uitdrtamt != null) {
						price = price.add(uitdrtamt);
					}
					if (voucherPrice != null) {
						price = price.add(voucherPrice);
					}
					Integer stagesNum = orderSubModel.getStagesNum();
					if (stagesNum == null || stagesNum == 0) {
						log.error("OrderService find ,orderId:" + orderSubModel.getOrderId() + ",stagesNum be wrong");
						response.setError("stagesNum.be.wrong");
						return response;
					}
					// 总价%分期数
					price = price.divide(new BigDecimal(stagesNum.intValue()), 2, BigDecimal.ROUND_DOWN);
					orderInfoDto.setPrice(price);
				}
				orderInfoDtos.add(orderInfoDto);
			}
			response.setResult(new Pager<OrderInfoDto>(total, orderInfoDtos));
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl.find.qury.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.find.qury.error");
			return response;
		}
	}

	/**
	 * 查看订单详情(接口用)
	 *
	 * @param orderId
	 * @return
	 */
	@Override
	public Response<OrderDetailDto> findOrderInfoByRestFull(@Param("id") String orderId) {
		Response<OrderDetailDto> response = new Response<OrderDetailDto>();
		try {
			// 校验
			// String customerId = user.getCustId();
			// String vendorId = user.getVendorId();
			OrderDetailDto orderDetailDto = new OrderDetailDto();
			checkArgument(StringUtils.isNotBlank(orderId), "orderId.can.not.be.empty");
			// 获取子订单详情
			OrderSubModel orderSubModel = null;
			orderSubModel = orderSubDao.findById(orderId);
			if (orderSubModel == null) {
				TblOrderHistoryModel tblOrderHistoryModel = tblOrderHistoryDao.findById(orderId);
				if (tblOrderHistoryModel == null) {
					log.error("OrderServiceImpl.findOrderInfo.error.orderSubModel.can.not.be.null");
					response.setError("OrderServiceImpl.findOrderInfo.error.orderSubModel.can.not.be.null");
					return response;
				}
				orderSubModel = new OrderSubModel();
				BeanMapper.copy(tblOrderHistoryModel, orderSubModel);
			}
			// if (StringUtils.isNotBlank(customerId)) {
			// if (!user.getId().equals(orderSubModel.getCreateOper())) {
			// throw new Exception("orderId.be.wrong");
			// }
			// }
			// if (StringUtils.isNotBlank(vendorId)) {
			// if (!vendorId.equals(orderSubModel.getVendorId())) {
			// throw new Exception("orderId.be.wrong");
			// }
			// }
			// 校验主订单号
			String ordermainId = orderSubModel.getOrdermainId();
			checkArgument(StringUtils.isNotBlank(ordermainId), "ordermainId.can.not.be.empty");
			// 获取主订单收货人信息
			OrderMainModel orderMainModel = null;
			orderMainModel = orderMainDao.findById(ordermainId);
			if (orderMainModel == null) {
				TblOrdermainHistoryModel tblOrdermainHistoryModel = tblOrdermainHistoryDao.findById(ordermainId);
				if (tblOrdermainHistoryModel == null) {
					log.error("OrderServiceImpl.findOrderInfo.error.orderMainModel.can.not.be.null");
					response.setError("OrderServiceImpl.findOrderInfo.error.orderMainModel.can.not.be.null");
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
			orderDetailDto.setOrderMainModel(orderMainModel);
			orderDetailDto.setOrderTransModel(orderTransModel);
			orderDetailDto.setOrderDoDetailModels(orderDoDetailModels);
			// 获取为020码
			if (Contants.SUB_ORDER_TYPE_02.equals(orderSubModel.getGoodsType())) {
				Response<List<InfoOutSystemModel>> listResponse = new Response<>();
				listResponse = infoOutSystemService.findByOrderIdDesc(orderId);
				if (!listResponse.isSuccess()) {
					log.error("infoOutSystemService.findByOrderIdDesc.failed");
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
					// if (StringUtils.isNotBlank(customerId)) {
					// orderDetailDto.setVerifyCode(verifyCode);
					// } else {
					// 脱敏 显示后三位
					String newVerifyCode = StringUtils.leftPad(StringUtils.right(verifyCode, 3),
							StringUtils.length(verifyCode), "*");
					orderDetailDto.setVerifyCode(newVerifyCode);
					// }
				}
			}
			// 获取单品编码
			String itemCode = orderSubModel.getGoodsId();
			checkArgument(StringUtils.isNotBlank(itemCode), "itemCode.can.not.be.empty");
			Response<ItemModel> itemModelResponse = itemService.findByCodeAll(itemCode);
			// Response<ItemModel>itemModelResponse=itemService.findByItemcode(itemCode);
			if (!itemModelResponse.isSuccess() || itemModelResponse.getResult() == null) {
				log.error("itemService findByItemcode failed");
				response.setError("itemModel.be.null");
				return response;
			}
			ItemModel itemModel = new ItemModel();
			itemModel = itemModelResponse.getResult();
			orderDetailDto.setMid(itemModel.getMid());
			// 售价
			if (Contants.BUSINESS_TYPE_YG.equals(orderSubModel.getOrdertypeId())) {
				orderDetailDto.setPrice(orderSubModel.getTotalMoney());
			}
			if (Contants.BUSINESS_TYPE_FQ.equals(orderSubModel.getOrdertypeId())) {
				BigDecimal totalMoney = orderSubModel.getTotalMoney();
				BigDecimal uitdrtamt = orderSubModel.getUitdrtamt();
				BigDecimal voucherPrice = orderSubModel.getVoucherPrice();
				BigDecimal price = BigDecimal.ZERO.setScale(2);
				if (totalMoney != null) {
					price = price.add(totalMoney);
				}
				if (uitdrtamt != null) {
					price = price.add(uitdrtamt);
				}
				if (voucherPrice != null) {
					price = price.add(voucherPrice);
				}
				Integer stagesNum = orderSubModel.getStagesNum();
				if (stagesNum == null || stagesNum == 0) {
					log.error("stagesNum.be.wrong");
					response.setError("stagesNum.be.wrong");
					return response;
				}
				// 总价%分期数
				price = price.divide(new BigDecimal(stagesNum.intValue()), 2, BigDecimal.ROUND_DOWN);
				orderDetailDto.setPrice(price);
			}

			response.setResult(orderDetailDto);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("OrderServiceImpl findOrderInfo.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl findOrderInfo.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.findOrderInfo.error");
			return response;
		}

	}

	/**
	 * @param pageNo
	 * @param size
	 * @param ordermainId
	 * @param curStatusId
	 * @param startTime
	 * @param endTime
	 * @param limitFlag
	 * @param user
	 * @return
	 */

	public Response<Pager<OrderMallManageDto>> findMall(@Param("pageNo") Integer pageNo, @Param("size") Integer size,
			@Param("ordermainId") String ordermainId, @Param("curStatusId") String curStatusId,
			@Param("startTime") String startTime, @Param("endTime") String endTime,
			@Param("limitFlag") String limitFlag, @Param("") User user, @Param("mallType") String mallType) {
		// 获取用户ID
		String userId = user.getId();
		// 构造返回值及参数
		Response<Pager<OrderMallManageDto>> response = new Response<Pager<OrderMallManageDto>>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Map<String, Object> paramMap = Maps.newHashMap();
		checkArgument(StringUtils.isNotBlank(userId), "userId.can.not.be.empty");
		paramMap.put("createOper", userId);
		// 默认选择逻辑删除
		paramMap.put("delFlag", Contants.DEL_INTEGER_FLAG_0);
		// 商城
		List<String> orderTypeIdList = Lists.newArrayList();
		if (OrderEnum.ONE.getValue().equals(mallType)) {
			// 商城默认不处理“虚拟商品”订单
			paramMap.put("goodsTypeFlag", Contants.SUB_ORDER_TYPE_01);
			// 非积分订单
			orderTypeIdList.add(Contants.BUSINESS_TYPE_YG);
			orderTypeIdList.add(Contants.BUSINESS_TYPE_FQ);
			paramMap.put("orderTypeIdList", orderTypeIdList);
		}
		// 积分商城
		if (OrderEnum.ZERO.getValue().equals(mallType)) {
			// 积分商城
			orderTypeIdList.add(Contants.BUSINESS_TYPE_JF);
			paramMap.put("orderTypeIdList", orderTypeIdList);
		}
		//广发,积分商城
		if (OrderEnum.TWO.getValue().equals(mallType)) {
			orderTypeIdList.add(Contants.BUSINESS_TYPE_YG);
			orderTypeIdList.add(Contants.BUSINESS_TYPE_FQ);
			orderTypeIdList.add(Contants.BUSINESS_TYPE_JF);
			paramMap.put("orderTypeIdList", orderTypeIdList);
		}
		// 判断时间是否为空
		if (StringUtils.isNotBlank(startTime)) {
			paramMap.put("startTime", startTime);
		}
		if (StringUtils.isNotBlank(endTime)) {
			paramMap.put("endTime", endTime);
		}
		// 判断商品名称为空
		if (StringUtils.isNotBlank(ordermainId)) {
			paramMap.put("ordermainId", ordermainId.trim());
		}
		// 判断订单状态
		if (StringUtils.isNotBlank(curStatusId)) {
			paramMap.put("curStatusId", curStatusId);
		}
		try {
			// 获取子订单列表数据
			// 获取子订单列表数据 六个月之前订单取自history表
			Pager<String> pager = new Pager<>();
			List<String> mainIds = Lists.newArrayList();
			List<OrderMallManageDto> orderMallManageDtos = Lists.newArrayList();
			// 获取主订单
			if (StringUtils.isEmpty(limitFlag)) {
				pager = orderSubDao.findMainIdLikeByPage(paramMap, pageInfo.getOffset(), pageInfo.getLimit());
			} else {
				pager = tblOrderHistoryDao.findMainIdLikeByPage(paramMap, pageInfo.getOffset(), pageInfo.getLimit());
			}

			mainIds = pager.getData();
			if (mainIds == null || mainIds.isEmpty()) {
				response.setResult(new Pager<OrderMallManageDto>(pager.getTotal(), orderMallManageDtos));
				return response;
			}
			// 获取主订单下子订单信息
			for (String orderMainId : mainIds) {
//				是否继续支付标识
				Boolean payOffFlag= Boolean.FALSE;
				paramMap.put("ordermainId", orderMainId);
				OrderMallManageDto orderMallManageDto = new OrderMallManageDto();

				List<OrderSubModel> orderSubModels = Lists.newArrayList();
				List<OrderInfoDto> orderInfoDtos = Lists.newArrayList();
				OrderMainModel orderMainModel = new OrderMainModel();
				// 获取主订单信息
				orderMainModel = orderMainDao.findById(orderMainId);
				if (orderMainModel == null) {
					TblOrdermainHistoryModel tblOrdermainHistoryModel = new TblOrdermainHistoryModel();
					tblOrdermainHistoryModel = tblOrdermainHistoryDao.findById(orderMainId);
					if (tblOrdermainHistoryModel == null) {
						log.error(
								"OrderService findMall error orderMainId:" + orderMainId + ",orderMainModel be empty");
						response.setError("OrderServiceImpl.findMall.error.tblOrdermainHistoryModel.can.not.be.null");
						return response;
					}
					orderMainModel = new OrderMainModel();
					BeanMapper.copy(tblOrdermainHistoryModel, orderMainModel);
				}
				orderMallManageDto.setOrderMainModel(orderMainModel);
				if(Contants.SUB_ORDER_STATUS_0301.equals(orderMainModel.getCurStatusId())){
					payOffFlag=Boolean.TRUE;
				}
				// 获取子订单信息
				if (StringUtils.isEmpty(limitFlag)) {
					orderSubModels = orderSubDao.findAllSelection(paramMap);
				} else {
					List<TblOrderHistoryModel> orderHistoryModels = Lists.newArrayList();
					orderHistoryModels = tblOrderHistoryDao.findAllSelection(paramMap);
					for (TblOrderHistoryModel tblOrderHistoryModel : orderHistoryModels) {
						OrderSubModel orderSubModel = new OrderSubModel();
						BeanMapper.copy(tblOrderHistoryModel, orderSubModel);
						orderSubModels.add(orderSubModel);
					}
				}

				// 获取单品mid
				List<ItemModel> itemModelList = Lists.newArrayList();
				List<TblGoodsPaywayModel> tblGoodsPaywayModelList = Lists.newArrayList();
				List<GoodsModel> goodsModelList = Lists.newArrayList();
				if (orderSubModels != null && !orderSubModels.isEmpty()) {
					List<String> itemCodeList = Lists.newArrayList();
					List<String> goodsPayWayIdList = Lists.newArrayList();
					List<String> goodsCodeList = Lists.newArrayList();
					for (OrderSubModel orderSubModel : orderSubModels) {
						if (StringUtils.isNotBlank(orderSubModel.getGoodsId()))
							itemCodeList.add(orderSubModel.getGoodsId());
						if (StringUtils.isNotBlank(orderSubModel.getGoodsPaywayId()))
							goodsPayWayIdList.add(orderSubModel.getGoodsPaywayId());
						if (StringUtils.isNotBlank(orderSubModel.getGoodsCode()))
							goodsCodeList.add(orderSubModel.getGoodsCode());
					}
					// 去重 itemCode
					HashSet itemCodeSet = new HashSet(itemCodeList);
					itemCodeList.clear();
					itemCodeList.addAll(itemCodeSet);
					Response<List<ItemModel>> itemModelReponse = new Response<>();
					itemModelReponse = itemService.findByCodesAll(itemCodeList);
					if (!itemModelReponse.isSuccess() || itemModelReponse.getResult() == null
							|| itemModelReponse.getResult().isEmpty()) {
						log.error("OrderService findMall error orderMainId:" + orderMainId
								+ ",itemService findByCodesAll failed");
						response.setError("ItemModelList.be.null");
						return response;
					}
					itemModelList = itemModelReponse.getResult();
					// 积分商城查询
					if (OrderEnum.ZERO.getValue().equals(mallType)||OrderEnum.TWO.getValue().equals(mallType)) {
						// 去重 goodsPayWayId
						HashSet goodsPayWayIdSet = new HashSet(goodsPayWayIdList);
						goodsPayWayIdList.clear();
						goodsPayWayIdList.addAll(goodsPayWayIdSet);
						Response<List<TblGoodsPaywayModel>> tblGoodsPaywayModelsResponse = goodsPayWayService
								.findByGoodsPayWayIdList(goodsPayWayIdList);
						if (!tblGoodsPaywayModelsResponse.isSuccess()
								|| tblGoodsPaywayModelsResponse.getResult() == null
								|| tblGoodsPaywayModelsResponse.getResult().isEmpty()) {
							log.error("OrderService findMall error orderMainId:" + orderMainId
									+ ",goodsPayWayService findByGoodsPayWayIdList failed");
							response.setError("tblGoodsPaywayModelList.be.empty");
							return response;
						}
						tblGoodsPaywayModelList = tblGoodsPaywayModelsResponse.getResult();
						// 去重 GoodsCode
						HashSet goodsCodeSet = new HashSet(goodsCodeList);
						goodsCodeList.clear();
						goodsCodeList.addAll(goodsCodeSet);
						Response<List<GoodsModel>> goodsModelResponse = goodsService.findByCodes(goodsCodeList);
						if (!goodsModelResponse.isSuccess() || goodsModelResponse.getResult() == null
								|| goodsModelResponse.getResult().isEmpty()) {
							log.error("OrderService findMall error orderMainId:" + orderMainId
									+ ",goodsService findByCodes failed");
							response.setError("goodsModelList.be.empty");
							return response;
						}
						goodsModelList = goodsModelResponse.getResult();
					}
				}

				for (OrderSubModel orderSubModel : orderSubModels) {
					OrderInfoDto orderInfoDto = new OrderInfoDto();
					orderInfoDto.setOrderSubModel(orderSubModel);
					if (!Contants.SUB_ORDER_STATUS_0301.equals(orderSubModel.getCurStatusId())){
						payOffFlag=Boolean.FALSE;
					}
					// 置订单是否使用优惠券及积分标识 true-使用
					orderInfoDto.makeBonusTotalFlag();
					orderInfoDto.makeVoucherFlag();
					orderInfoDto.makeUitdrtamtFlag();
					/*
					 * 设置设置查看物流权限标识 当订单类型为实物-SUB_ORDER_TYPE_00且订单状态为SUB_ORDER_STATUS_0309-已发货，
					 * SUB_ORDER_STATUS_0380-拒绝签收，SUB_ORDER_STATUS_0381-无人签收， SUB_ORDER_STATUS_0310-已签收，
					 * SUB_ORDER_STATUS_0334-退货申请，SUB_ORDER_STATUS_0327-退货成功， SUB_ORDER_STATUS_0335-拒绝退货申请时 拥有查看物流标识
					 * true——拥有
					 */
					if (Contants.SUB_ORDER_TYPE_00.equals(orderSubModel.getGoodsType())) {
						if (Contants.SUB_ORDER_STATUS_0309.equals(orderSubModel.getCurStatusId())
								|| Contants.SUB_ORDER_STATUS_0380.equals(orderSubModel.getCurStatusId())
								|| Contants.SUB_ORDER_STATUS_0381.equals(orderSubModel.getCurStatusId())
								|| Contants.SUB_ORDER_STATUS_0310.equals(orderSubModel.getCurStatusId())
								|| Contants.SUB_ORDER_STATUS_0334.equals(orderSubModel.getCurStatusId())
								|| Contants.SUB_ORDER_STATUS_0327.equals(orderSubModel.getCurStatusId())
								|| Contants.SUB_ORDER_STATUS_0335.equals(orderSubModel.getCurStatusId())) {
							orderInfoDto.setOrderTransFlag(Boolean.TRUE);

						} else {
							orderInfoDto.setOrderTransFlag(Boolean.FALSE);
						}
					} else {
						orderInfoDto.setOrderTransFlag(Boolean.FALSE);
					}
					// set mid xid
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

					// 售价
					if (Contants.BUSINESS_TYPE_YG.equals(orderSubModel.getOrdertypeId())) {
						orderInfoDto.setPrice(orderSubModel.getTotalMoney());
					}
					if (Contants.BUSINESS_TYPE_FQ.equals(orderSubModel.getOrdertypeId())) {
						BigDecimal totalMoney = orderSubModel.getTotalMoney();
						BigDecimal uitdrtamt = orderSubModel.getUitdrtamt();
						BigDecimal voucherPrice = orderSubModel.getVoucherPrice();
						BigDecimal price = BigDecimal.ZERO.setScale(2);
						if (totalMoney != null)
							price = price.add(totalMoney);
						if (uitdrtamt != null)
							price = price.add(uitdrtamt);
						if (voucherPrice != null)
							price = price.add(voucherPrice);
						Integer stagesNum = orderSubModel.getStagesNum();
						if (stagesNum == null || stagesNum == 0) {
							log.error("OrderService findMall orderId:" + orderSubModel.getOrderId()
									+ ",stagesNum.be.wrong");
							response.setError("stagesNum.be.wrong");
							return response;
						}
						// 总价%分期数
						price = price.divide(new BigDecimal(stagesNum.intValue()), 2, BigDecimal.ROUND_DOWN);
						orderInfoDto.setPrice(price);
					}
					// 积分商城
					if (Contants.BUSINESS_TYPE_JF.equals(orderSubModel.getOrdertypeId())) {
						String goodsPaywayId = orderSubModel.getGoodsPaywayId();
						String goodsCode = orderSubModel.getGoodsCode();
						if (StringUtils.isBlank(goodsPaywayId)) {
							log.error("orderId:" + orderSubModel.getOrderId() + "goodsPaywayId be null");
							response.setError("goodsPaywayId.be.empty");
							return response;
						}
						if (StringUtils.isBlank(goodsCode)) {
							log.error("orderId:" + orderSubModel.getOrderId() + "goodsCode be null");
							response.setError("goodsCode.be.empty");
							return response;
						}
						TblGoodsPaywayModel tblGoodsPaywayModel = new TblGoodsPaywayModel();
						for (TblGoodsPaywayModel tblGoodsPaywayModelEach : tblGoodsPaywayModelList) {
							if (goodsPaywayId.equals(tblGoodsPaywayModelEach.getGoodsPaywayId()))
								tblGoodsPaywayModel = tblGoodsPaywayModelEach;
						}
						GoodsModel goodsModel = new GoodsModel();
						for (GoodsModel goodsModelEach : goodsModelList) {
							if (goodsCode.equals(goodsModelEach.getCode()))
								goodsModel = goodsModelEach;
						}
						String memberLevel = tblGoodsPaywayModel.getMemberLevel();
						String regionType = goodsModel.getRegionType();
						if (OrderEnum.cxArea.getValue().equals(regionType)) {
							// doNothing
						} else if (OrderEnum.djArea.getValue().equals(regionType)) {
							if (OrderEnum.Z3FIVE.getValue().equals(memberLevel)) {
								orderInfoDto.setExchangeName("积分+现金");
							} else if (OrderEnum.Z3TWO.getValue().equals(memberLevel)) {
								orderInfoDto.setExchangeName("顶级/增值白金");
							} else {
								orderInfoDto.setExchangeName("顶级/增值白金");
							}
						} else if (OrderEnum.xwArea.getValue().equals(regionType)) {
							if (OrderEnum.Z3FIVE.getValue().equals(memberLevel)) {
								orderInfoDto.setExchangeName("积分+现金");
							} else {
								orderInfoDto.setExchangeName("积分兑换价");
							}
						} else if (OrderEnum.zzArea.getValue().equals(regionType)) {
							if (OrderEnum.Z3FIVE.getValue().equals(memberLevel)) {
								orderInfoDto.setExchangeName("积分+现金");
							} else {
								orderInfoDto.setExchangeName("积分兑换价");
							}
						} else {
							if (OrderEnum.Z3ONE.getValue().equals(memberLevel)) {
								orderInfoDto.setExchangeName("尊越/臻享白金");
							} else if (OrderEnum.Z3TWO.getValue().equals(memberLevel)) {
								orderInfoDto.setExchangeName("顶级/增值白金");
							} else if (OrderEnum.Z3THREE.getValue().equals(memberLevel)) {
								orderInfoDto.setExchangeName("VIP");
							} else if (OrderEnum.Z3FOUR.getValue().equals(memberLevel)) {
								orderInfoDto.setExchangeName("生日折扣");
							} else if (OrderEnum.Z3FIVE.getValue().equals(memberLevel)) {
								orderInfoDto.setExchangeName("积分+现金");
							} else {
								orderInfoDto.setExchangeName("金普价");
							}
						}
					}
					orderInfoDtos.add(orderInfoDto);
				}
				orderMallManageDto.setOrderInfoDtos(orderInfoDtos);
				orderMallManageDto.setPayOffFlag(payOffFlag);
				orderMallManageDtos.add(orderMallManageDto);
			}
			response.setResult(new Pager<OrderMallManageDto>(pager.getTotal(), orderMallManageDtos));
			return response;

		} catch (Exception e) {
			log.error("OrderServiceImpl.findMall.qury.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.findMall.qury.error");
			return response;
		}

	}

	/**
	 * 查看订单详情
	 *
	 * @param orderId
	 * @return
	 */
	@Override
	public Response<OrderDetailDto> findOrderInfo(@Param("id") String orderId, @Param("") User user) {
		Response<OrderDetailDto> response = new Response<OrderDetailDto>();
		try {
			// 校验
			String customerId = user.getCustId();
			String vendorId = user.getVendorId();
			OrderDetailDto orderDetailDto = new OrderDetailDto();
			checkArgument(StringUtils.isNotBlank(orderId), "orderId.can.not.be.empty");
			// 获取子订单详情
			OrderSubModel orderSubModel = null;
			orderSubModel = orderSubDao.findById(orderId);
			if (orderSubModel == null) {
				TblOrderHistoryModel tblOrderHistoryModel = tblOrderHistoryDao.findById(orderId);
				if (tblOrderHistoryModel == null) {
					log.error("OrderServiceImpl.findOrderInfo.error.orderSubModel.can.not.be.null");
					response.setError("OrderServiceImpl.findOrderInfo.error.orderSubModel.can.not.be.null");
					return response;
				}
				orderSubModel = new OrderSubModel();
				BeanMapper.copy(tblOrderHistoryModel, orderSubModel);
			}
			if (StringUtils.isNotBlank(customerId)) {
				if (!user.getId().equals(orderSubModel.getCreateOper())) {
					throw new Exception("orderId.be.wrong");
				}
			}
			if (StringUtils.isNotBlank(vendorId)) {
				if (!vendorId.equals(orderSubModel.getVendorId())) {
					throw new Exception("orderId.be.wrong");
				}
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
					log.error("OrderServiceImpl.findOrderInfo.error.orderMainModel.can.not.be.null");
					response.setError("OrderServiceImpl.findOrderInfo.error.orderMainModel.can.not.be.null");
					return response;
				}
				orderMainModel = new OrderMainModel();
				BeanMapper.copy(tblOrdermainHistoryModel, orderMainModel);
			}
			// 获取物流信息
			OrderTransModel orderTransModel = null;
			orderTransModel = orderTransDao.findByOrderId(orderId);
			// 获取订单履历
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
				//如果O2O商品则修改手机号
				orderMainModel.setContMobPhone(orderMainModel.getCsgPhone1());
				//修改收货人姓名
				orderSubModel.setMemberName(orderMainModel.getCsgName());
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
			// 售价
			if (Contants.BUSINESS_TYPE_YG.equals(orderSubModel.getOrdertypeId())) {
				orderDetailDto.setPrice(orderSubModel.getTotalMoney());
			}
			if (Contants.BUSINESS_TYPE_FQ.equals(orderSubModel.getOrdertypeId())) {
				BigDecimal totalMoney = orderSubModel.getTotalMoney();
				BigDecimal uitdrtamt = orderSubModel.getUitdrtamt();
				BigDecimal voucherPrice = orderSubModel.getVoucherPrice();
				BigDecimal price = BigDecimal.ZERO.setScale(2);
				if (totalMoney != null) {
					price = price.add(totalMoney);
				}
				if (uitdrtamt != null) {
					price = price.add(uitdrtamt);
				}
				if (voucherPrice != null) {
					price = price.add(voucherPrice);
				}
				Integer stagesNum = orderSubModel.getStagesNum();
				if (stagesNum == null || stagesNum == 0) {
					log.error("OrderService findOrderInfo error,orderId:" + orderId + "stagesNum.be.wrong");
					response.setError("stagesNum.be.wrong");
					return response;
				}
				// 总价%分期数
				price = price.divide(new BigDecimal(stagesNum.intValue()), 2, BigDecimal.ROUND_DOWN);
				orderDetailDto.setPrice(price);
			}
			if (Contants.BUSINESS_TYPE_JF.equals(orderSubModel.getOrdertypeId())) {
				String goodsPaywayId = orderSubModel.getGoodsPaywayId();
				String goodsCode = orderSubModel.getGoodsCode();
				if (StringUtils.isBlank(goodsPaywayId)) {
					log.error("OrderService findOrderInfo error,orderId:" + orderSubModel.getOrderId()
							+ "goodsPaywayId be null");
					response.setError("goodsPaywayId.be.empty");
					return response;
				}
				if (StringUtils.isBlank(goodsCode)) {
					log.error("OrderService findOrderInfo error,orderId:" + orderSubModel.getOrderId()
							+ "goodsCode be null");
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
			}

			response.setResult(orderDetailDto);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("OrderServiceImpl findOrderInfo.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl findOrderInfo.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.findOrderInfo.error");
			return response;
		}

	}

	/**
	 * 供应商更新订单状态 包括 签收，拒绝签收，无人签收
	 *
	 * @Param orderId 子订单Id
	 * @Param curStatusId 订单类型区分标示位
	 * @Param vendorId 供应商Id return
	 */
	@Override
	public Response<Map<String, Boolean>> updateOrderSignVendor(Map<String, Object> map) {
		Response<Map<String, Boolean>> response = new Response<>();
//		Map<String, Boolean> responseMap = new HashMap<>();
		if (map.isEmpty()) {
			log.error("OrderService updateOrderSignVendor error paramMap be empty");
			response.setError("OrderService.updateOrderSignVendor.error.paramMap.be.empty");
			return response;
		}
		String orderId = (String) map.get("orderId");
		// 获取分布式锁
		String lockId = DistributedLocks.acquireLockWithTimeout(jedisTemplate, "OSV" + orderId, 50, 10000);
		if (lockId == null) {
			log.info("orderService updateOrderSignVendor repeat actions，orderId："+orderId);
			response.setError("updateOrderSignVendor.repeat.actions");
			return response;
		}
		try {
			String curStatusId = (String) map.get("curStatusId");
			String receiver = (String) map.get("receiver");
			String receiveTime = (String) map.get("receiveTime");
			String id = (String) map.get("id");

			// 校验订单ID
			checkArgument(StringUtils.isNotBlank(orderId), "orderId.can.not.be.empty");
			checkArgument(StringUtils.isNotBlank(curStatusId), "curStatusId.be.empty");
			OrderSubModel orderSubModel = new OrderSubModel();
			orderSubModel = orderSubDao.findById(orderId);
			// 校验返回结果是否为空
			if (orderSubModel == null) {
				TblOrderHistoryModel tblOrderHistoryModel = tblOrderHistoryDao.findById(orderId);
				if (tblOrderHistoryModel == null) {
					DistributedLocks.releaseLock(jedisTemplate, "OSV" + orderId,lockId);
					log.error("OrderService.updateOrderSignVendor.error.orderSubModel.be.null");
					response.setError("orderSubModel.be.null");
					return response;
				}
				orderSubModel = new OrderSubModel();
				BeanMapper.copy(tblOrderHistoryModel, orderSubModel);
			}
			// 更新更新人ID
			orderSubModel.setModifyOper(id);
			Map<String, Object> paramMap = new HashMap<>();
			switch (curStatusId) {

			case Contants.VENDOR_ORDER_UPDATE_TYPE_SIGNED:
				// 已签收 当订单状态未发生改变时将"已发货"状态置为"已签收"状态
				checkArgument(StringUtils.isNotBlank(receiver), "receiver.be.empty");
				checkArgument(StringUtils.isNotBlank(receiveTime), "receiveTime.be.empty");
				// 供应商操作标识
				orderSubModel.setVendorOperFlag("1");
				orderSubModel.setReceiver(receiver);
				orderSubModel.setReceivedTime(sdf.parse(receiveTime));
				orderSubModel.setGoodssendFlag("2");
				paramMap.put("orderSubModel", orderSubModel);
				paramMap.put("targetCurStatusId", Contants.SUB_ORDER_STATUS_0309);
				paramMap.put("curStatusId", Contants.SUB_ORDER_STATUS_0310);
				paramMap.put("curStatusNm", Contants.SUB_ORDER_SIGNED);
				paramMap.put("receiver", receiver);
				paramMap.put("receiveTime", receiveTime);
				response = updateSignVendor(paramMap);
				break;

			case Contants.VENDOR_ORDER_UPDATE_TYPE__SIGNED_REFUSED:
				// 拒签 当订单状态未发生改变时将"已发货"状态置为"拒绝签收"状态
				// 供应商操作标识
				orderSubModel.setVendorOperFlag("1");
				paramMap.put("orderSubModel", orderSubModel);
				paramMap.put("targetCurStatusId", Contants.SUB_ORDER_STATUS_0309);
				paramMap.put("curStatusId", Contants.SUB_ORDER_STATUS_0380);
				paramMap.put("curStatusNm", Contants.SUB_ORDER_SIGNED_REFUSED);
				response = updateSignVendor(paramMap);

				break;

			case Contants.VENDOR_ORDER_UPDATE_TYPE_SIGNED_NONE:
				// 无人签收 当订单状态未发生改变时将"已发货"状态置为"无人签收"状态
				// 供应商操作标识
				orderSubModel.setVendorOperFlag("1");
				paramMap.put("orderSubModel", orderSubModel);
				paramMap.put("targetCurStatusId", Contants.SUB_ORDER_STATUS_0309);
				paramMap.put("curStatusId", Contants.SUB_ORDER_STATUS_0381);
				paramMap.put("curStatusNm", Contants.SUB_ORDER_SIGNED_NONE);
				response = updateSignVendor(paramMap);
				break;

			default:
				// 当订单状态都不是以上情况时默认出错
				DistributedLocks.releaseLock(jedisTemplate, "OSV" + orderId, lockId);
				log.error("OrderService.updateOrderSignVendor.error.curStatusId.be.wrong");
				response.setError("OrderService.updateOrderSignVendor.error.curStatusId.be.wrong");
				return response;
			}
			DistributedLocks.releaseLock(jedisTemplate, "OSV" + orderId, lockId);
			return response;

		} catch (IllegalArgumentException e) {
			DistributedLocks.releaseLock(jedisTemplate, "OSV" + orderId, lockId);
			log.error("OrderService updateOrderSignVendor error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (TradeException e) {
			DistributedLocks.releaseLock(jedisTemplate, "OSV" + orderId, lockId );
			log.error("OrderService updateOrderSignVendor error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			DistributedLocks.releaseLock(jedisTemplate, "OSV" + orderId, lockId);
			log.error("OrderService updateOrderSignVendor error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderService.updateOrderSignVendor.error");
			return response;
		}

	}

	/**
	 * 广发商城前台 取消订单
	 *
	 * @param paramMap
	 * @return
	 */
	@Override
	public Response<Map<String, Object>> updateOrderMall(Map<String, Object> paramMap) {
		Response<Map<String, Object>> response = new Response<>();
		Map<String, Object> responseMap = new HashMap<>();
		try {
			if (paramMap.isEmpty()) {
				log.error("OrderService.updateOrderMall.error.paramMap.be.empty");
				response.setError("OrderService.updateOrderMall.error.paramMap.be.empty");
				return response;
			}
			String ordermainId = (String) paramMap.get("ordermainId");
			User user = (User) paramMap.get("user");
			// 校验订单ID
			checkArgument(StringUtils.isNotBlank(ordermainId), "ordermainId.can.not.be.empty");
			OrderMainModel orderMainModel = new OrderMainModel();
			orderMainModel = orderMainDao.findById(ordermainId);
			// 校验返回结果是否为空
			if (orderMainModel == null) {
				log.error("OrderService.updateOrderMall.error.orderMainModel.be.null");
				response.setError("OrderService.updateOrderMall.error.orderMainModel.be.null");
				return response;
			}
			if (!Contants.SUB_ORDER_STATUS_0301.equals(orderMainModel.getCurStatusId())) {
				responseMap.put("result", Boolean.FALSE);
				responseMap.put("error", "statusChanged");
				response.setResult(responseMap);
				return response;
			}
			orderMainModel.setCurStatusId(Contants.SUB_ORDER_STATUS_7777);
			orderMainModel.setCurStatusNm(Contants.SUB_ORDER_CANCELED);
			orderMainModel.setModifyOper(user.getId());

			String ordertypeId = orderMainModel.getOrdertypeId();
			String id = user.getId();
			List<OrderSubModel> orderSubModels = orderSubDao.findByOrderMainId(ordermainId);
			if (orderSubModels == null || orderSubModels.isEmpty()) {
				log.error("orderMainManager updateCancelOrder orderSubModels be empty");
				throw new TradeException("orderSubModels.be.empty");
			}
			List<OrderDoDetailModel> orderDoDetailModels = Lists.newArrayList();
			List<String> itemCodeList = Lists.newArrayList();
			List<Map<String, Object>> paramList = Lists.newArrayList();
			List<String> goodsPayWayIdList = Lists.newArrayList();
			for (OrderSubModel orderSubModel : orderSubModels) {
				if (!Contants.SUB_ORDER_STATUS_0301.equals(orderSubModel.getCurStatusId())) {
					log.error("orderId:"+orderSubModel.getOrderId()+",curStatusId changed");
					throw new TradeException("orderSub.changed");
				}
				//积分商城
				if (Contants.BUSINESS_TYPE_JF.equals(ordertypeId)){
					Map<String,Object>itemMap=Maps.newHashMap();
					String goodsId = orderSubModel.getGoodsId();
					if (StringUtils.isEmpty(goodsId)) {
						log.error("orderId:" + orderSubModel.getOrderId() + ",goodsId be empty");
						throw new TradeException("goodsId.be.null");
					}
					//单品编码
					itemMap.put("goodsId",goodsId);
					//数量
					itemMap.put("stock",orderSubModel.getGoodsNum());
					paramList.add(itemMap);
					if (StringUtils.isNotEmpty(orderSubModel.getGoodsPaywayId())) {
						goodsPayWayIdList.add(orderSubModel.getGoodsPaywayId());
					}
				} else {
					//广发商城
					// 荷兰拍回滚redis库存
					if (Contants.PROMOTION_PROM_TYPE_STRING_50.equals(orderSubModel.getActType())
							|| Contants.PROMOTION_PROM_TYPE_STRING_40.equals(orderSubModel.getActType())
							|| Contants.PROMOTION_PROM_TYPE_STRING_30.equals(orderSubModel.getActType())
							|| Contants.PROMOTION_PROM_TYPE_STRING_20.equals(orderSubModel.getActType())
							|| Contants.PROMOTION_PROM_TYPE_STRING_10.equals(orderSubModel.getActType())) {

						Map<String, Object> proMap = Maps.newHashMap();
						proMap.put("promId", orderSubModel.getActId());
						proMap.put("periodId", orderSubModel.getPeriodId() == null ? null : orderSubModel.getPeriodId().toString());
						proMap.put("itemCode", orderSubModel.getGoodsId());
						// 接口需要“-”代表回滚
						proMap.put("itemCount", orderSubModel.getGoodsNum());
						proMap.put("orderId", orderSubModel.getOrderId());
						proMap.put("actType", orderSubModel.getActType());
						paramList.add(proMap);
					} else {
						// 普通单品更新db库存，团购、折扣、秒杀、满减 活动单品不回滚库存
						String goodsId = orderSubModel.getGoodsId();
						if (StringUtils.isBlank(goodsId)) {
							log.error("orderId:" + orderSubModel.getOrderId() + ",goodsId be empty");
							throw new TradeException("goodsId.be.null");
						}
						itemCodeList.add(goodsId);
					}
				}
				orderSubModel.setCurStatusNm(Contants.SUB_ORDER_CANCELED);
				orderSubModel.setCurStatusId(Contants.SUB_ORDER_STATUS_7777);
				orderSubModel.setModifyOper(id);

				OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
				orderDoDetailModel.setOrderId(orderSubModel.getOrderId());
				orderDoDetailModel.setModifyOper(id);
				orderDoDetailModel.setCreateOper(id);
				orderDoDetailModel.setStatusId(Contants.SUB_ORDER_STATUS_7777);
				orderDoDetailModel.setStatusNm(Contants.SUB_ORDER_CANCELED);
				orderDoDetailModel.setDoUserid(id);
				orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_3);
				orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);
				orderDoDetailModels.add(orderDoDetailModel);
			}
			Map<String, Integer> itemStockmap = Maps.newHashMap();
			List<String> countList = Lists.newArrayList();
			if (Contants.BUSINESS_TYPE_JF.equals(ordertypeId)) {
				// 积分商城
				for (Map<String, Object> paramItemMap : paramList) {
					String itemCode = (String) paramItemMap.get("goodsId");
					Integer stock = (Integer) paramItemMap.get("stock");
					if (itemStockmap.get(itemCode) == null) {
						itemStockmap.put(itemCode, stock);
					} else {
						itemStockmap.put(itemCode, itemStockmap.get(itemCode) + stock);
					}
				}
				//释放生日资格
				if (goodsPayWayIdList != null && !goodsPayWayIdList.isEmpty()) {
					List<String> goodsPayWayIdBirthList = Lists.newArrayList();
					Response<List<TblGoodsPaywayModel>> tblGoodsPaywayModelsResponse = goodsPayWayService
							.findByGoodsPayWayIdList(goodsPayWayIdList);
					if (!tblGoodsPaywayModelsResponse.isSuccess()
							|| tblGoodsPaywayModelsResponse.getResult() == null
							|| tblGoodsPaywayModelsResponse.getResult().isEmpty()) {
						log.error("orderMainManager updateCancelOrder error,goodsPayWayService findByGoodsPayWayIdList failed");
						throw new TradeException("tblGoodsPaywayModelList.be.empty");
					}
					for (TblGoodsPaywayModel tblGoodsPaywayModel : tblGoodsPaywayModelsResponse.getResult()) {
						if ("1".equals(tblGoodsPaywayModel.getIsBirth())) {
							goodsPayWayIdBirthList.add(tblGoodsPaywayModel.getGoodsPaywayId());
						}
					}
					// 去重 goodsPayWayId
					if (goodsPayWayIdBirthList != null && !goodsPayWayIdBirthList.isEmpty()) {
						HashSet goodsPayWayBirthIdSet = new HashSet(goodsPayWayIdBirthList);
						goodsPayWayIdBirthList.clear();
						goodsPayWayIdBirthList.addAll(goodsPayWayBirthIdSet);
						for (String goodsPayId : goodsPayWayIdList) {
							// 如果是生日价格，恢复积分生日价格使用次数
							if (goodsPayWayIdBirthList.indexOf(goodsPayId) >=0) {
								countList.add("1");
							}
						}
					}
				}

			}else {
				//广发商城
				// 回滚普通单品库存
				if (itemCodeList != null && !itemCodeList.isEmpty()) {
					// 以单品为单位区分
					for (String itemCode : itemCodeList) {
						if (itemStockmap.get(itemCode) == null) {
							itemStockmap.put(itemCode, 1);
						} else {
							itemStockmap.put(itemCode, itemStockmap.get(itemCode) + 1);
						}
					}
				}
			}
			orderMainManager.updateCancelOrder(orderMainModel, user, itemStockmap, countList, orderSubModels, orderDoDetailModels, paramList);
			ExecutorService executorService = Executors.newFixedThreadPool(orderSubModels.size());
			for (final OrderSubModel orderSubModel : orderSubModels) {
				executorService.submit(new Runnable() {
					public void run() {
						try {
							insertUserMessage(orderSubModel, Boolean.FALSE);
						} catch (Exception e) {
							log.error("我的消息插入失败,error:{}",Throwables.getStackTraceAsString(e));
						}
					}
				});
			}
			responseMap.put("result", Boolean.TRUE);
			response.setResult(responseMap);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("OrderService updateOrderMall error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (TradeException e) {
			log.error("OrderService updateOrderMall error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderService updateOrderMall error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderService.updateOrderMall.error");
			return response;
		}
	}




	// 供应商签收 拒签 无人签收校验
	private Response<Map<String, Boolean>> updateSignVendor(Map<String, Object> paramMap) throws Exception {
		OrderSubModel orderSubModel = (OrderSubModel) paramMap.get("orderSubModel");
		String targetCurStatusId = (String) paramMap.get("targetCurStatusId");
		String curStatusId = (String) paramMap.get("curStatusId");
		String curStatusNm = (String) paramMap.get("curStatusNm");

		Response<Map<String, Boolean>> response = new Response<>();
		Map<String, Boolean> responseMap = new HashMap<>();
		OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
		// 订单履历
		// 订单状态排他性校验
		if (targetCurStatusId.equals(orderSubModel.getCurStatusId())) {
			orderDoDetailModel.setOrderId(orderSubModel.getOrderId());
			orderDoDetailModel.setModifyOper(orderSubModel.getModifyOper());
			orderDoDetailModel.setCreateOper(orderSubModel.getModifyOper());
			orderDoDetailModel.setStatusId(curStatusId);
			orderDoDetailModel.setStatusNm(curStatusNm);
			orderDoDetailModel.setDoUserid(orderSubModel.getModifyOper());
			orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_2);
			orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);

			orderSubModel.setCurStatusId(curStatusId);
			orderSubModel.setCurStatusNm(curStatusNm);
			orderSubManager.updateSignVendor(orderSubModel, orderDoDetailModel);
			// 插入我的消息
			insertUserMessage(orderSubModel, Boolean.TRUE);
			responseMap.put("result", Boolean.TRUE);
			response.setResult(responseMap);
		} else {
			responseMap.put("result", Boolean.FALSE);
			response.setResult(responseMap);
		}
		return response;
	}

	/**
	 * 商城用户提醒发货
	 *
	 * @Param orderId 子订单Id
	 * @Param userId 用户Id return
	 */

	@Override
	public Response<Map<String, Boolean>> updateOrderRemind(String orderId, String userId) {
		Response<Map<String, Boolean>> response = new Response<>();
		Map<String, Boolean> responseMap = new HashMap<>();
		try {
			// 校验订单ID
			checkArgument(StringUtils.isNotBlank(orderId), "orderId.can.not.be.empty");
			checkArgument(StringUtils.isNotBlank(userId), "userId.can.not.be.empty");
			OrderSubModel orderSubModel = new OrderSubModel();
			orderSubModel = orderSubDao.findById(orderId);
			// 校验返回结果是否为空
			if (orderSubModel == null) {
				log.error("OrderService.updateOrderRemind.error.orderSubModel.be.null");
				response.setError("OrderService.updateOrderRemind.error.orderSubModel.be.null");
				return response;
			}
			if (!(Contants.SUB_ORDER_STATUS_0308.equals(orderSubModel.getCurStatusId())
					|| Contants.SUB_ORDER_STATUS_0306.equals(orderSubModel.getCurStatusId()))) {
				responseMap.put("result", Boolean.FALSE);
				response.setResult(responseMap);
				return response;
			}
			// 获取提醒次数 为空增添第一次提醒时间
			Integer remindeTimes = orderSubModel.getRemindeTimes();
			if (remindeTimes == null) {
				orderSubModel.setFirstRemindeTime(new Date());
				orderSubModel.setRemindeTimes(1);
				// 提醒发货标识
				orderSubModel.setRemindeFlag(1);
			} else {
				remindeTimes += 1;
				orderSubModel.setRemindeTimes(remindeTimes);
			}
			// 更新更新人ID
			orderSubModel.setModifyOper(userId);
			Boolean result = orderSubManager.update(orderSubModel);
			responseMap.put("result", result);
			response.setResult(responseMap);
			return response;

		} catch (IllegalArgumentException e) {
			log.error("OrderService updateOrderRemind error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderService updateOrderRemind error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderService.updateOrderRemind.error");
			return response;
		}

	}

	/**
	 * 发货
	 *
	 * @Param orderId 子订单Id
	 * @Param transcorpNm 物流公司名称
	 * @Param mailingNum 快递单号
	 * @Param transRemark 备注 return
	 */
	public Response<Map<String, Object>> deliverGoods(OrderTransModel orderTransModel, User user) {
		Response<Map<String, Object>> response = new Response<>();
		Map<String, Object> responseMap = new HashMap<>();
		try {
			if (orderTransModel == null) {
				log.error("OrderService.deliverGoods.error.orderTransModel.be.empty");
				response.setError("OrderService.deliverGoods.error.orderTransModel.be.empty");
				return response;
			}
			// 校验订单ID
			String orderId = orderTransModel.getOrderId();
			checkArgument(StringUtils.isNotBlank(orderId), "orderId.can.not.be.empty");
			OrderSubModel orderSubModel = orderSubDao.findById(orderId);
			if (orderSubModel == null) {
				log.error("OrderService.deliverGoods.error.orderSubModel.be.null");
				response.setError("orderSubModel.be.null");
				return response;
			}
			if (!Contants.SUB_ORDER_STATUS_0308.equals(orderSubModel.getCurStatusId())) {
				responseMap.put("result", Boolean.FALSE);
				responseMap.put("error", "statusChanged");
				response.setResult(responseMap);
				return response;
			}
			OrderTransModel orderTransModel1 = null;
			orderTransModel1 = orderTransDao.findByOrderId(orderId);
			if (orderTransModel1 != null) {
				responseMap.put("result", Boolean.FALSE);
				responseMap.put("error", "exited");
				response.setResult(responseMap);
				return response;
			}
			// 当该子订单不存在物流信息时，新增物流信息
			// 子订单号
			orderTransModel.setOrderId(orderId);
			// 创建时间
			orderTransModel.setCreateTime(new Date());
			// 发货时间
			Date dotime=orderTransModel.getDoTime();
			String yymmdd=DateHelper.date2string(dotime,DateHelper.YYYYMMDD);
			String hhmmss=DateHelper.getHHmmss();
			String yymmddhhmmss=yymmdd.concat(hhmmss);
			orderTransModel.setDoTime(DateHelper.string2Date(yymmddhhmmss,DateHelper.YYYYMMDDHHMMSS));
			orderTransModel.setCreateOper(user.getId());
			// 逻辑删除标记 0：未删除 1：已删除
			orderTransModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);

			// 更新子订单表当前状态为已发货
			orderSubModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0309);
			orderSubModel.setCurStatusNm(Contants.SUB_ORDER_DELIVERED);
			// 提醒标示 已经发货 订单提醒状态标示为未提醒状态
			orderSubModel.setRemindeFlag(0);
			// 发货标记
			orderSubModel.setGoodssendFlag("1");
			// 追加订单操作履历
			OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
			// 子订单号
			orderDoDetailModel.setOrderId(orderId);
			// 状态代码
			orderDoDetailModel.setStatusId(Contants.SUB_ORDER_STATUS_0309);
			// 状态名称
			orderDoDetailModel.setStatusNm(Contants.SUB_ORDER_DELIVERED);
			// 创建时间
			orderDoDetailModel.setCreateTime(new Date());
			// 处理时间
			orderDoDetailModel.setDoTime(new Date());
			// 创建者
			orderDoDetailModel.setCreateOper(user.getId());
			// 处理用户
			orderDoDetailModel.setDoUserid(user.getId());
			// 用户类型（2：供应商）
			orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_2);
			orderSubModel.setModifyOper(user.getId());
			// 逻辑删除标记 0：未删除 1：已删除
			orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);
			orderSubManager.update(orderSubModel, orderDoDetailModel, orderTransModel);
			insertUserMessage(orderSubModel, Boolean.TRUE);
			responseMap.put("result", Boolean.TRUE);
			response.setResult(responseMap);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("OrderService deliverGoods error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderService deliverGoods error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderService.deliverGoods.error");
			return response;
		}
	}

	/**
	 * 退货
	 *
	 * @param paramMap orderId 子订单Id typeFlag 区分标识 vendorId 供应商Id season 原因 supplement 补充说明
	 * @return
	 */

	@Override
	public Response<Map<String, Object>> revokeOrder(Map<String, String> paramMap) {

		Response<Map<String, Object>> response = new Response<>();
		Map<String, Boolean> responseMap = new HashMap<>();
		if (paramMap.isEmpty()) {
			log.error("OrderService.revokeOrder.error.paramMap.be.empty");
			response.setError("OrderService.revokeOrder.error.paramMap.be.empty");
			return response;
		}
		String orderId = paramMap.get("orderId");
		if (StringUtils.isBlank(orderId)){
			log.error("OrderService.revokeOrder.error.orderId.be.empty");
			response.setError("orderId.can.not.be.empty");
			return response;
		}
		// 获取分布式锁
		String lockId = DistributedLocks.acquireLockWithTimeout(jedisTemplate, "VOMR" + orderId, 50, 10000);
		if (lockId == null) {
			log.info("orderService revokeOrder repeat actions，orderId："+orderId);
			response.setError("updateOrderSignVendor.repeat.actions");
			return response;
		}
		try {
			String typeFlag = paramMap.get("typeFlag");
			String vendorId = paramMap.get("vendorId");
			String userId = paramMap.get("userId");
			String season = paramMap.get("season");
			String supplement = paramMap.get("supplement");
			// 校验订单ID,供应商ID，区分标示
//			checkArgument(StringUtils.isNotBlank(orderId), "orderId.can.not.be.empty");
			checkArgument(StringUtils.isNotBlank(typeFlag), "typeFlag.be.empty");
			checkArgument(StringUtils.isNotBlank(vendorId) || StringUtils.isNotBlank(userId),
					"vendorId.and.userId.be.empty");
			checkArgument(StringUtils.isNotBlank(season), "season.be.empty");
			OrderSubModel orderSubModel = new OrderSubModel();
			orderSubModel = orderSubDao.findById(orderId);
			// 校验返回结果是否为空
			if (orderSubModel == null) {
				DistributedLocks.releaseLock(jedisTemplate, "VOMR" + orderId,lockId);
				log.error("OrderService.revokeOrder.error.orderSubModel.be.null");
				response.setError("OrderService.revokeOrder.error.orderSubModel.be.null");
				return response;
			}
			Map<String, Object> map = new HashMap<>();
			map.put("orderSubModel", orderSubModel);
			map.put("vendorId", vendorId);
			map.put("season", season);
			map.put("supplement", supplement);
			map.put("userType", Contants.VENDOR_USER_TYPE_2);
			map.put("id", vendorId);
			map.put("returnType", Contants.ORDER_RETURN_OR_REVOKE_TYPE_VENDOR);
			map.put("type", Contants.ORDER_PARTBACK_OPERATIONTYPE_RETURN);

			switch (typeFlag) {
			// 退货 已签收
			case Contants.SUB_ORDER_STATUS_0310:
				map.put("targetCurStatusId", Contants.SUB_ORDER_STATUS_0310);
				// 当为供应商系统时状态置为 退货成功
				map.put("curStatusId", Contants.SUB_ORDER_STATUS_0327);
				map.put("curStatusNm", Contants.SUB_ORDER_RETURN_SUCCEED);
				response = updateReturn(map);
				break;

			// 退货 拒绝退货申请
			case Contants.SUB_ORDER_STATUS_0335:
				map.put("targetCurStatusId", Contants.SUB_ORDER_STATUS_0335);
				// 当为供应商系统时状态置为 退货成功
				map.put("curStatusId", Contants.SUB_ORDER_STATUS_0327);
				map.put("curStatusNm", Contants.SUB_ORDER_RETURN_SUCCEED);
				response = updateReturn(map);
				break;

			default:
				DistributedLocks.releaseLock(jedisTemplate, "VOMR" + orderId,lockId);
				log.error("OrderService.updateOrder.error.typeFlag.be.wrong");
				response.setError("OrderService.updateOrder.error.typeFlag.be.wrong");
				return response;
			}
			DistributedLocks.releaseLock(jedisTemplate, "VOMR" + orderId,lockId);
			return response;

		} catch (IllegalArgumentException e) {
			DistributedLocks.releaseLock(jedisTemplate, "VOMR" + orderId,lockId);
			log.error("OrderService revokeOrder error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (TradeException e) {
			DistributedLocks.releaseLock(jedisTemplate, "VOMR" + orderId,lockId);
			log.error("OrderService revokeOrder error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			DistributedLocks.releaseLock(jedisTemplate, "VOMR" + orderId,lockId);
			log.error("OrderService revokeOrder error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderService.revokeOrder.error");
			return response;
		}
	}

	@Override
	public Response<Map<String, Object>> returnOrderMall(Map<String, Object> paramMap) {
		Response<Map<String, Object>> response = new Response<>();
		Map<String, Object> responseMap = new HashMap<>();
		try {
			if (paramMap.isEmpty()) {
				log.error("OrderService.returnOrderMall.error.paramMap.be.empty");
				response.setError("OrderService.returnOrderMall.error.paramMap.be.empty");
				return response;
			}
			String orderId = (String) paramMap.get("orderId");
			String typeFlag = (String) paramMap.get("typeFlag");
			String userId = (String) paramMap.get("userId");
			String season = (String) paramMap.get("season");
			String supplement = (String) paramMap.get("supplement");
			// 校验订单ID,供应商ID，区分标示
			checkArgument(StringUtils.isNotBlank(orderId), "orderId.can.not.be.empty");
			checkArgument(StringUtils.isNotBlank(typeFlag), "typeFlag.be.empty");
			checkArgument(StringUtils.isNotBlank(userId), "userId.be.empty");
			checkArgument(StringUtils.isNotBlank(season), "season.be.empty");
			OrderSubModel orderSubModel = new OrderSubModel();
			orderSubModel = orderSubDao.findById(orderId);
			// 校验返回结果是否为空
			if (orderSubModel == null) {
				TblOrderHistoryModel tblOrderHistoryModel = new TblOrderHistoryModel();
				tblOrderHistoryModel = tblOrderHistoryDao.findById(orderId);
				if (tblOrderHistoryModel == null) {
					log.error("OrderService.returnOrderMall.error.orderSubModel.be.null");
					response.setError("orderSubModel.be.null");
					return response;
				}
				orderSubModel = new OrderSubModel();
				BeanMapper.copy(tblOrderHistoryModel, orderSubModel);
			}
			Map<String, Object> map = new HashMap<>();

			if (!typeFlag.equals(orderSubModel.getCurStatusId())) {
				responseMap.put("result", Boolean.FALSE);
				responseMap.put("error", "statusChanged");
				response.setResult(responseMap);
				return response;
			}
			orderSubModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0334);
			orderSubModel.setCurStatusNm(Contants.SUB_ORDER_RETURN_APPLICATION);
			OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
			orderDoDetailModel.setOrderId(orderSubModel.getOrderId());
			orderDoDetailModel.setModifyOper(userId);
			orderDoDetailModel.setCreateOper(userId);
			orderDoDetailModel.setStatusId(Contants.SUB_ORDER_STATUS_0334);
			orderDoDetailModel.setStatusNm(Contants.SUB_ORDER_RETURN_APPLICATION);
			orderDoDetailModel.setDoUserid(userId);
			orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_3);
			orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);

			OrderReturnTrackDetailModel orderRrturnTrackDetailModel = new OrderReturnTrackDetailModel();
			orderRrturnTrackDetailModel.setOrderId(orderId);
			orderRrturnTrackDetailModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0334);
			orderRrturnTrackDetailModel.setCurStatusNm(Contants.SUB_ORDER_RETURN_APPLICATION);
			orderRrturnTrackDetailModel.setOrdertypeId(orderSubModel.getOrdertypeId());
			orderRrturnTrackDetailModel.setOrdertypeNm(orderSubModel.getOrdertypeNm());
			orderRrturnTrackDetailModel.setOperationType(Contants.ORDER_INTEGER_PARTBACK_OPERATIONTYPE_RETURN);
			orderRrturnTrackDetailModel.setMemo(season.trim());
			orderRrturnTrackDetailModel.setMemoExt(StringUtils.isNotBlank(supplement) ? supplement.trim() : null);
			orderRrturnTrackDetailModel.setDoDesc("买家已提交退货申请，等待卖家处理");
			orderRrturnTrackDetailModel.setCreateOper(userId);
			orderRrturnTrackDetailModel.setModifyOper(userId);
			orderSubManager.updateReturnForMall(orderSubModel, orderDoDetailModel, orderRrturnTrackDetailModel);
			// 我的消息
			insertUserMessage(orderSubModel, Boolean.FALSE);
			responseMap.put("result", Boolean.TRUE);
			response.setResult(responseMap);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("OrderService.returnOrderMall.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (TradeException e) {
			log.error("OrderService.returnOrderMall.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderService returnOrderMall error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderService.returnOrderMall.error");
			return response;
		}
	}

	@Override
	public Response<Map<String, Object>> revokeOrderMall(Map<String, Object> paramMap) {
		Response<Map<String, Object>> response = new Response<>();
		Map<String, Object> responseMap = new HashMap<>();
		try {
			if (paramMap.isEmpty()) {
				log.error("OrderService.revokeOrderMall.error.paramMap.be.empty");
				response.setError("OrderService.revokeOrderMall.error.paramMap.be.empty");
				return response;
			}
			String orderId = (String) paramMap.get("orderId");
			String typeFlag = (String) paramMap.get("typeFlag");
			User user = (User) paramMap.get("user");
			String userId = (String) paramMap.get("userId");
			String season = (String) paramMap.get("season");
			String supplement = (String) paramMap.get("supplement");
			// 校验订单ID,供应商ID，区分标示
			checkArgument(StringUtils.isNotBlank(orderId), "orderId.can.not.be.empty");
			checkArgument(StringUtils.isNotBlank(typeFlag), "typeFlag.be.empty");
			checkArgument(StringUtils.isNotBlank(userId), "userId.be.empty");
			checkArgument(StringUtils.isNotBlank(season), "season.be.empty");
			OrderSubModel orderSubModel = new OrderSubModel();
			orderSubModel = orderSubDao.findById(orderId);
			// 校验返回结果是否为空
			if (orderSubModel == null) {
				TblOrderHistoryModel tblOrderHistoryModel = new TblOrderHistoryModel();
				tblOrderHistoryModel = tblOrderHistoryDao.findById(orderId);
				if (tblOrderHistoryModel == null) {
					log.error("OrderService.revokeOrderMall.error.orderSubModel.be.null");
					response.setError("OrderService.revokeOrderMall.error.orderSubModel.be.null");
					return response;
				}
				orderSubModel = new OrderSubModel();
				BeanMapper.copy(tblOrderHistoryModel, orderSubModel);
			}
			Map<String, Object> map = new HashMap<>();

			if (!typeFlag.equals(orderSubModel.getCurStatusId())) {
				responseMap.put("result", Boolean.FALSE);
				responseMap.put("error", "statusChanged");
				response.setResult(responseMap);
				return response;
			}
			orderSubModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0312);
			orderSubModel.setCurStatusNm(Contants.SUB_ORDER_REVOKED);
			orderSubModel.setSaleAfterStatus(Contants.SUB_ORDER_STATUS_0312);
			OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
			orderDoDetailModel.setOrderId(orderSubModel.getOrderId());
			orderDoDetailModel.setModifyOper(userId);
			orderDoDetailModel.setCreateOper(userId);
			orderDoDetailModel.setStatusId(Contants.SUB_ORDER_STATUS_0312);
			orderDoDetailModel.setStatusNm(Contants.SUB_ORDER_REVOKED);
			orderDoDetailModel.setDoUserid(userId);
			orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_3);
			orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);

			OrderReturnTrackDetailModel orderRrturnTrackDetailModel = new OrderReturnTrackDetailModel();
			orderRrturnTrackDetailModel.setOrderId(orderId);
			orderRrturnTrackDetailModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0312);
			orderRrturnTrackDetailModel.setCurStatusNm(Contants.SUB_ORDER_REVOKED);
			orderRrturnTrackDetailModel.setOrdertypeId(orderSubModel.getOrdertypeId());
			orderRrturnTrackDetailModel.setOrdertypeNm(orderSubModel.getOrdertypeNm());
			orderRrturnTrackDetailModel.setOperationType(Contants.ORDER_INTEGER_PARTBACK_OPERATIONTYPE_REVOKE);
			orderRrturnTrackDetailModel.setMemo(season.trim());
			orderRrturnTrackDetailModel.setMemoExt(StringUtils.isNotBlank(supplement) ? supplement.trim() : null);
			orderRrturnTrackDetailModel.setCreateOper(userId);
			orderRrturnTrackDetailModel.setModifyOper(userId);
			orderSubManager.updateRevokeForMall(orderSubModel, orderDoDetailModel, orderRrturnTrackDetailModel, user);
			// 我的消息
			insertUserMessage(orderSubModel, Boolean.FALSE);
			responseMap.put("result", Boolean.TRUE);
			response.setResult(responseMap);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("OrderService.revokeOrderMall.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (TradeException e) {
			log.error("OrderService.revokeOrderMall.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderService revokeOrderMall error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderService.revokeOrderMall.error");
			return response;
		}
	}

	private Response<Map<String, Object>> updateReturn(Map<String, Object> paramMap) throws Exception {
		String targetCurStatusId = (String) paramMap.get("targetCurStatusId");
		OrderSubModel orderSubModel = (OrderSubModel) paramMap.get("orderSubModel");
		String id = (String) paramMap.get("id");
		String season = (String) paramMap.get("season");
		String supplement = (String) paramMap.get("supplement");
		String curStatusId = (String) paramMap.get("curStatusId");
		String curStatusNm = (String) paramMap.get("curStatusNm");
		String type = (String) paramMap.get("type");
		String userType = (String) paramMap.get("userType");
		String returnType = (String) paramMap.get("returnType");
		OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
		Map<String, Object> responseMap = new HashMap<>();
		Response<Map<String, Object>> response = new Response<>();
		if (targetCurStatusId.equals(orderSubModel.getCurStatusId())) {
			// 供应商退货
//			Date nowTime = new Date();
//			Date receiveTime = orderSubModel.getReceivedTime();
			Calendar calendar = Calendar.getInstance();
			int hour = calendar.get(Calendar.HOUR_OF_DAY);
			// 业务1800至2400不能点击退货
			if (Integer.parseInt(timeStart) <= hour && hour <= Integer.parseInt(timeEnd)) {
				responseMap.put("result", Boolean.FALSE);
				responseMap.put("error", "notTime");
				response.setResult(responseMap);
				return response;
			}
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
			orderRrturnTrackDetailModel.setMemo(season.trim());
			orderRrturnTrackDetailModel.setMemoExt(StringUtils.isNotBlank(supplement) ? supplement.trim() : null);
			orderRrturnTrackDetailModel.setDoDesc("卖家同意退货，等待收货");
			orderRrturnTrackDetailModel.setCreateOper(id);
			orderRrturnTrackDetailModel.setModifyOper(id);
			Boolean orderSubResult3 = orderSubManager.updateReturnVendor(orderSubModel, orderDoDetailModel,
					orderRrturnTrackDetailModel);
			insertUserMessage(orderSubModel, Boolean.TRUE);
			responseMap.put("result", Boolean.TRUE);
			response.setResult(responseMap);
		} else {
			responseMap.put("result", Boolean.FALSE);
			responseMap.put("error", "statusChaged");
			response.setResult(responseMap);
		}
		return response;

	}

	/**
	 * 通过订单id查询订单状态
	 *
	 * @param orderId
	 * @return
	 * @Add by Liuhan
	 */
	@Override
	public OrderSubModel findOrderId(String orderId) {
		OrderSubModel orderSubModel = new OrderSubModel();
		try {
			orderSubModel = orderSubDao.findById(orderId);
		} catch (Exception e) {
			log.error("order.query.error", Throwables.getStackTraceAsString(e));
		}
		return orderSubModel;
	}

	/**
	 * 通过订单id查询物流状态
	 *
	 * @param orderId
	 * @return
	 */
	@Override
	public Response<OrderTransModel> findOrderTrans(String orderId) {
		Response<OrderTransModel> response = new Response<>();
		OrderTransModel orderTransModel = new OrderTransModel();
		try {
			checkArgument(StringUtils.isNotBlank(orderId), "orderId.can.not.be.empty");
			orderTransModel = orderTransDao.findByOrderId(orderId);
			if (orderTransModel == null) {
				log.error("OrderService.findOrderTrans.error.orderTransModel.be.null");
				response.setError("OrderService.findOrderTrans.error.orderTransModel.be.null");
				return response;
			}
			response.setResult(orderTransModel);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("OrderService.findOrderTrans.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderService findOrderTrans error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderService.findOrderTrans.error");
			return response;

		}
	}

	@Override
	public Response<OrderReturnDetailDto> findOrderReturnDetail(String orderId) {
		Response<OrderReturnDetailDto> response = new Response<>();
		try {
			checkArgument(StringUtils.isNotBlank(orderId), "orderId.can.not.be.empty");
			List<OrderReturnTrackDetailModel> orderRrturnTrackDetailModels = Lists.newArrayList();
			Map<String, Object> paramMap = Maps.newHashMap();
			paramMap.put("orderId", orderId);
			orderRrturnTrackDetailModels = orderReturnTrackDetailDao.findAllByOrderId(paramMap);
			if (orderRrturnTrackDetailModels == null || orderRrturnTrackDetailModels.isEmpty()) {
				log.error("OrderSErvice findOrderReturnDetail,orderRrturnTrackDetailModels be null");
				response.setError("orderRrturnTrackDetailModels.be.null");
				return response;
			}
			String status = orderRrturnTrackDetailModels.get(orderRrturnTrackDetailModels.size() - 1).getCurStatusNm();
			OrderReturnDetailDto orderReturnDetailDto = new OrderReturnDetailDto();
			orderReturnDetailDto.setStatus(status);
			orderReturnDetailDto.setOrderRrturnTrackDetailModels(orderRrturnTrackDetailModels);
			response.setResult(orderReturnDetailDto);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("OrderService.findOrderReturnDetail.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderService findOrderReturnDetail error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderService.findOrderReturnDetail.error");
			return response;

		}
	}

	/**
	 * 代发货订单批量置为发货处理中
	 *
	 * @param map vendorId
	 * @return
	 */

	@Override
	@Deprecated
	public Response<Map<String, Boolean>> export(Map<String, String> map) {
		Response<Map<String, Boolean>> response = new Response<>();
		Map<String, Boolean> responseMap = Maps.newHashMap();
		try {
			checkArgument(!map.isEmpty(), "map.can.not.be.empty");
			String vendorId = map.get("vendorId");
			checkArgument(StringUtils.isNotBlank(vendorId), "vendorId can not be empty");
			Map<String, Object> paramMap = Maps.newHashMap();
			PageInfo pageInfo = new PageInfo(null, null);
			paramMap.put("delFlag", Contants.DEL_INTEGER_FLAG_0);
			paramMap.put("vendorId", vendorId);
			paramMap.put("curStatusId", Contants.SUB_ORDER_STATUS_0308);
			Pager<OrderSubModel> pager = orderSubDao.findLikeByPage(paramMap, pageInfo.getOffset(),
					pageInfo.getLimit());
			List<OrderSubModel> orderSubModelList = new ArrayList<OrderSubModel>();
			orderSubModelList = pager.getData();
			for (OrderSubModel orderSubModel : orderSubModelList) {
				orderSubModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0306);
				orderSubModel.setCurStatusNm(Contants.SUB_ORDER_DELIVER_HANDLING);
				OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
				orderDoDetailModel.setOrderId(orderSubModel.getOrderId());
				orderDoDetailModel.setModifyOper(orderSubModel.getModifyOper());
				orderDoDetailModel.setCreateOper(orderSubModel.getModifyOper());
				orderDoDetailModel.setStatusId(Contants.SUB_ORDER_STATUS_0306);
				orderDoDetailModel.setStatusNm(Contants.SUB_ORDER_DELIVER_HANDLING);
				orderDoDetailModel.setDoUserid(orderSubModel.getModifyOper());
				orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_2);
				orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);
				// orderSubManager.update(orderSubModel, orderDoDetailModel);
			}
			responseMap.put("result", Boolean.TRUE);
			response.setResult(responseMap);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("OrderService.export.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderService export error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderService.export.error");
			return response;
		}

	}

	/**
	 * 提交订单
	 *
	 * @param orderCommitSubmitDto 提交订单信息
	 * @return 新建订单结果
	 */
	public Response createOrder_new(OrderCommitSubmitDto orderCommitSubmitDto, User user,
																	OrderMainModel orderMainModel, List<OrderSubModel> orderSubModelList,
																	List<OrderDoDetailModel> orderDoDetailModelList,
																	List<OrderVirtualModel> orderVirtualList,
																	OrderMainDto orderMainDto) {
		Response response = Response.newResponse();
		try {
			// 登入数据库
			// 广发商城
			if (orderCommitSubmitDto.getBusiType().equals("0")) {
				orderMainManager.createOrder_new(orderMainModel, orderSubModelList, orderDoDetailModelList,
						orderMainDto.getStockMap(), orderMainDto.getPointPoolModel(), orderMainDto.getPromItemMap(),
						user);
				// 积分商城
			} else if (orderCommitSubmitDto.getBusiType().equals("1")) {
				orderMainManager.createJfOrder_new(orderMainModel, orderSubModelList, orderDoDetailModelList,
						orderVirtualList, orderMainDto.getStockMap(), user, orderMainDto.getEspCustNewModel());
			}
			// 未设默认地址的场合，把此次收货地址设为默认地址
			if (orderCommitSubmitDto.getAddressId() != null) {
				memberAddressService.setDefaultNotExists(orderCommitSubmitDto.getAddressId(), user.getCustId());
			}
			// 从购物车跳转过来的订单，订单生成成功后删除购物车中对应记录
			cartService.deleteCartInfoFromOrder(orderCommitSubmitDto.getOrderCommitInfoList());
			// Redis中优惠券删除
			redisService.deleteCoupons(user.getId());
			redisService.deleteScores(user.getId());
			response.setSuccess(true);
			return response;
		} catch (TradeException e) {
			log.error(Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderService createOrder error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderService.createOrder.error");
			return response;
		}
	}

	/**
	 * 支付结果更新临时用待删除
	 *
	 * @param orderMainId
	 * @param payFlag
	 * @return
	 */
	public Response<Map<String, Boolean>> demoPay(String orderMainId, String payFlag, User user) {
		Response<Map<String, Boolean>> response = new Response<>();
		Map<String, Boolean> responseMap = Maps.newHashMap();
		try {
			OrderMainModel orderMainModel = orderMainDao.findById(orderMainId);
			orderMainModel.setModifyOper(user.getId());
			// 假定０成功１失败２处理中 空状态未明
			switch (payFlag) {
			case "0":
				orderMainModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0308);
				orderMainModel.setCurStatusNm(Contants.SUB_ORDER_PAYMENT_SUCCEED);
				break;
			case "1":
				orderMainModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0307);
				orderMainModel.setCurStatusNm(Contants.SUB_ORDER_PAYMENT_FAILED);
				break;
			case "2":
				orderMainModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0305);
				orderMainModel.setCurStatusNm(Contants.SUB_ORDER_HANDLING);
				break;
			default:
				orderMainModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0316);
				orderMainModel.setCurStatusNm(Contants.SUB_ORDER_UNCLEAR);
			}
			orderMainManager.update(orderMainModel);
			List<OrderSubModel> orderSubModels = orderSubDao.findByOrderMainId(orderMainId);

			List<OrderSubModel> orderSubModelList = Lists.newArrayList();
			List<OrderDoDetailModel> orderDoDetailModelList = Lists.newArrayList();
			for (OrderSubModel orderSubModel : orderSubModels) {

				orderSubModel.setModifyOper(user.getId());
				// 假定０成功１失败２处理中 空状态未明
				switch (payFlag) {
				case "0":
					orderSubModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0308);
					orderSubModel.setCurStatusNm(Contants.SUB_ORDER_PAYMENT_SUCCEED);
					break;
				case "1":
					orderSubModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0307);
					orderSubModel.setCurStatusNm(Contants.SUB_ORDER_PAYMENT_FAILED);
					break;
				case "2":
					orderSubModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0305);
					orderSubModel.setCurStatusNm(Contants.SUB_ORDER_HANDLING);
					break;
				default:
					orderSubModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0316);
					orderSubModel.setCurStatusNm(Contants.SUB_ORDER_UNCLEAR);
				}

				OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
				// 订单履历
				orderDoDetailModel.setOrderId(orderSubModel.getOrderId());
				orderDoDetailModel.setModifyOper(orderSubModel.getModifyOper());
				orderDoDetailModel.setCreateOper(orderSubModel.getModifyOper());
				orderDoDetailModel.setStatusId(orderSubModel.getCurStatusId());
				orderDoDetailModel.setStatusNm(orderSubModel.getCurStatusNm());
				orderDoDetailModel.setDoUserid(orderSubModel.getModifyOper());
				orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_3);
				orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);
				orderSubModelList.add(orderSubModel);
				orderDoDetailModelList.add(orderDoDetailModel);
			}
			Boolean result = orderSubManager.updateBatch(orderSubModelList, orderDoDetailModelList);
			responseMap.put("result", result);
			response.setResult(responseMap);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("OrderService.demoPay.error,error code: {}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, e.getMessage());
		} catch (Exception e) {
			log.error("OrderService demoPay error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderService.demoPay.error");
			return response;
		}

	}

	/**
	 * 广发商城提交订单画面初期显示
	 *
	 * @param skus 购物车id，优惠券
	 * @return
	 */
	@Override
	public Response<Map<String, Object>> findOrderInfoForCommitOrder(String skus, User user) {
		return super.findOrderInfoForCommitOrder(skus, user);
	}
	/**
	 * 积分商城提交订单画面初期显示
	 *
	 * @param skus 购物车id，优惠券
	 * @return
	 */
	@Override
	public Response<Map<String, Object>> jfFindOrderInfoForCommitOrder(String skus, User user) {
		log.info("积分商城提交订单画面初期显示");
		Response<Map<String, Object>> response = new Response<>();
		Map<String, Object> result = Maps.newHashMap();
		BigDecimal total = new BigDecimal(0);// 订单总额
		Long totalCount = 0l;// 订单总积分
		String payType = "1";
		List<OrderCommitInfoDto> resultList = Lists.newArrayList();
		try {
			if (Strings.isNullOrEmpty(skus)) {
				throw new IllegalArgumentException("没有选择单品");
			}
			List<CarInfoDto> carInfoDtos = super.jsonMapper.fromJson(skus, carInfoType);
			List<String> ids = Lists.newArrayList();
			for (CarInfoDto carInfoDto : carInfoDtos) {
				ids.add(carInfoDto.getI());
			}
			List<TblEspCustCartModel> cartModelList = tblEspCustCartDao.findCartItemsByIds(ids);
			if (cartModelList.size() != carInfoDtos.size()) {
				throw new ServiceException("购物车数据异常");
			}
			List<String> goodsCodes = Lists.newArrayList();
			for (TblEspCustCartModel cartModel : cartModelList) {
				ItemModel itemMdl = itemService.findById(cartModel.getItemId());
				if (itemMdl == null) {
					throw new IllegalArgumentException("没找到对应商品");
				}
				cartModel.setItemList(Lists.newArrayList(itemMdl));
				goodsCodes.add(itemMdl.getGoodsCode());
			}
			// 判断商品类型
			boolean isMaterial = false;
			String goodsType = Contants.SUB_ORDER_TYPE_00;
			Response<List<GoodsModel>> goodsModels = goodsService.findByCodes(goodsCodes);
			if (!goodsModels.isSuccess()) {
				log.error("Response.error,error code: {}", goodsModels.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
			}
			Map<String, String> goodsNameMap = Maps.newHashMap();
			Map<String, String> goodsPointTypeMap = Maps.newHashMap();
			for (GoodsModel goodsModel : goodsModels.getResult()) {
				goodsNameMap.put(goodsModel.getCode(), goodsModel.getName());
				goodsPointTypeMap.put(goodsModel.getCode(),
						goodsModel.getPointsType() == null ? "" : goodsModel.getPointsType());
				goodsType = goodsModel.getGoodsType();
				if (Contants.SUB_ORDER_TYPE_00.equals(goodsModel.getGoodsType())) {
					isMaterial = true;
				}
			}
			if (isMaterial) {
				result.put("goodsType", Contants.SUB_ORDER_TYPE_00); // 实物
			} else if (Contants.SUB_ORDER_TYPE_02.equals(goodsType)) { // O2O
				result.put("goodsType", goodsType);
				result.put("userName", user.getName());
				result.put("phoneNo", user.getMobile());
			} else { // 虚拟
				result.put("goodsType", goodsType);
				result.put("virtualMemberNm", cartModelList.get(0).getVirtualMemberNm());
				result.put("virtualAviationType", cartModelList.get(0).getVirtualAviationType());
				result.put("virtualMemberId", cartModelList.get(0).getVirtualMemberId());
				result.put("attachName", cartModelList.get(0).getAttachName());
				result.put("attachIdentityCard", cartModelList.get(0).getAttachIdentityCard());
				result.put("entryCard", cartModelList.get(0).getEntryCard());
				result.put("serialno", cartModelList.get(0).getSerialno());
				result.put("prepaidMob", cartModelList.get(0).getPrepaidMob());
				if (StringUtils.isNotEmpty(cartModelList.get(0).getVirtualMemberNm())
						|| StringUtils.isNotEmpty(cartModelList.get(0).getVirtualAviationType())
						|| StringUtils.isNotEmpty(cartModelList.get(0).getVirtualMemberId())
						|| StringUtils.isNotEmpty(cartModelList.get(0).getAttachName())
						|| StringUtils.isNotEmpty(cartModelList.get(0).getAttachIdentityCard())
						|| StringUtils.isNotEmpty(cartModelList.get(0).getEntryCard())) {
					result.put("showFlag", "1");
				}
			}
			// 取得购物车中内容
			ItemModel itemModel = new ItemModel();// 购物车单品
			BigDecimal goodsPrice = new BigDecimal(0);// 售价
			TblGoodsPaywayModel goodsPaywayModel = new TblGoodsPaywayModel();// 原支付方式信息
			// 客户等级
//			CustLevelInfo custLevelInfo = priceSystemService.getCustLevelInfo(user.getCertNo());
//			String memberLevel = custLevelInfo == null ? "" : custLevelInfo.getMemberLevel();
			for (TblEspCustCartModel cartModel : cartModelList) {
				OrderCommitInfoDto orderCommitInfoDto = new OrderCommitInfoDto();
				itemModel = cartModel.getItemList().get(0);
				BeanMapper.copy(itemModel, orderCommitInfoDto);
				orderCommitInfoDto.setMid(itemModel.getXid());
				orderCommitInfoDto.setItemCount(Integer.parseInt(cartModel.getGoodsNum()));
				Response<TblGoodsPaywayModel> goodsPaywayModelResponse = goodsPayWayService.findGoodsPayWayInfo(cartModel.getGoodsPaywayId());
				if (!goodsPaywayModelResponse.isSuccess()) {
					log.error("Response.error,error code: {}", goodsPaywayModelResponse.getError());
					throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
				}
				goodsPaywayModel = goodsPaywayModelResponse.getResult();
				orderCommitInfoDto.setPromotion(new MallPromotionResultDto());
				goodsPrice = goodsPaywayModel.getGoodsPrice() == null ? new BigDecimal(0)
						: goodsPaywayModel.getGoodsPrice();
				// 分期数
				orderCommitInfoDto.setInstalments("1");
				// 分期价格
				orderCommitInfoDto.setInstalmentsPrice(goodsPrice);
				// 支付方式Id
				orderCommitInfoDto.setPayWayId(goodsPaywayModel.getGoodsPaywayId());
				// 原始价格
				orderCommitInfoDto.setOriPrice(goodsPrice);
				// 实际价格
				orderCommitInfoDto.setPrice(goodsPrice);
				// 固定积分
				orderCommitInfoDto.setFixFlag(true);
				// 积分数
				orderCommitInfoDto.setJfCount(goodsPaywayModel.getGoodsPoint() == null ? 0l
						: goodsPaywayModel.getGoodsPoint() * Long.parseLong(cartModel.getGoodsNum()));
				// 优惠券
				orderCommitInfoDto.setVoucherId("");
				orderCommitInfoDto.setVoucherNo("");
				orderCommitInfoDto.setVoucherNm("");
				orderCommitInfoDto.setVoucherPrice(new BigDecimal(0));
				// 小计
				orderCommitInfoDto.setSubTotal(
						(orderCommitInfoDto.getPromotion() != null && orderCommitInfoDto.getPromotion().getId() != null
								&& orderCommitInfoDto.getPromotion().getPromType() == 20) ? new BigDecimal(0)
								: orderCommitInfoDto.getPrice()
								.multiply(new BigDecimal(orderCommitInfoDto.getItemCount())));
				// 订单总额
				total = total.add(orderCommitInfoDto.getSubTotal());
				// 订单总积分
				totalCount = totalCount + orderCommitInfoDto.getJfCount();
				// 商品名称
				orderCommitInfoDto.setGoodsName(goodsNameMap.get(itemModel.getGoodsCode()));
				// modify by zhanglin at 20160909 for 304686 start
				// 积分类型
				String JfType = goodsPointTypeMap.get(itemModel.getGoodsCode());
				orderCommitInfoDto.setJfType(JfType);
				Response<TblCfgIntegraltypeModel> jftype = cfgIntegraltypeService.findById(JfType);
				if (jftype.isSuccess()) {
					TblCfgIntegraltypeModel cfgIntegraltypeModel = jftype.getResult();
					// 积分类型名
					if (cfgIntegraltypeModel == null) {
						orderCommitInfoDto.setJfTypeName("未知类型");
					} else {
						orderCommitInfoDto.setJfTypeName(cfgIntegraltypeModel.getIntegraltypeNm());
					}
				} else {
					log.error("orderService.findJftype.error{}", jftype.getError());
					throw new TradeException("orderService.findJftype.error");
				}
				// modify by zhanglin at 20160909 for 304686 end
				// 购物车Id
				orderCommitInfoDto.setCartId(cartModel.getId().toString());
				// 兑换等级
				String exchangeLevelName = cartModel.getCustmerNm();
				orderCommitInfoDto.setChangeLevel(exchangeLevelName);
				// 客户所输入的保单号
				orderCommitInfoDto.setSerialno(cartModel.getSerialno());
				if (!isMaterial && !Contants.SUB_ORDER_TYPE_02.equals(goodsType)) { // 虚拟
					orderCommitInfoDto.setVirtualMemberId(cartModel.getVirtualMemberId());//会员号
					orderCommitInfoDto.setVirtualMemberNm(cartModel.getVirtualMemberNm());//会员姓名
					orderCommitInfoDto.setVirtualAviationType(cartModel.getVirtualAviationType());//航空类型
					orderCommitInfoDto.setEntryCard(cartModel.getEntryCard());//附属卡号
					orderCommitInfoDto.setAttachIdentityCard(cartModel.getAttachIdentityCard());//留学生意外险附属卡证件号码
					orderCommitInfoDto.setAttachName(cartModel.getAttachName());//留学生意外险附属卡姓名
				}
				// 返回的商品信息
				resultList.add(orderCommitInfoDto);
			}
			result.put("itemInfoList", resultList);
			result.put("payType", payType);
			result.put("total", total);
			result.put("totalCount", totalCount);
			result.put("realPayment", total);
			// 取得可支付卡号一览
			List<Map<String, String>> cardNos = getCardNoInfo(payType, user);
			result.put("cardNos", cardNos);
			response.setResult(result);
			return response;
		} catch (ServiceException es) {
			result.put("orderIsNull", "1");
			response.setResult(result);
			return response;
		} catch (Exception e) {
			e.printStackTrace();
			response.setError("OrderServiceImpl.findOrderInfo.query.error" + e.getMessage()
					+ Throwables.getStackTraceAsString(e));
			return response;
		}
	}


//	/**
//	 * 取得兑换等级
//	 *
//	 * @param memberLevel 会员ID
//	 */
//	private static String getExchangeLevelName(String memberLevel) {
//		memberLevel = memberLevel == null ? "" : memberLevel;
//		String exchangeLevelName = ""; // 兑换等级
//		//兑换等级
//		// 尊越/臻享白金+钛金卡
//		if (Contants.MEMBER_LEVEL_TJ_CODE.equals(memberLevel)){
//			exchangeLevelName = Contants.MEMBER_LEVEL_TJ_NM;
//		}
//		//	顶级/增值白金卡
//		else if (Contants.MEMBER_LEVEL_DJ_CODE.equals(memberLevel)){
//			exchangeLevelName = Contants.MEMBER_LEVEL_DJ_NM;
//		}
//		//	VIP
//		else if (Contants.MEMBER_LEVEL_VIP_CODE.equals(memberLevel)){
//			exchangeLevelName = (Contants.MEMBER_LEVEL_VIP_NM).toUpperCase();
//		}
//		//	生日
//		else if (Contants.MEMBER_LEVEL_BIRTH_CODE.equals(memberLevel)){
//			exchangeLevelName = Contants.MEMBER_LEVEL_BIRTH_NM;
//		}
//		//	积分+现金
//		else if (Contants.MEMBER_LEVEL_INTEGRAL_CASH_CODE.equals(memberLevel)){
//			exchangeLevelName = Contants.MEMBER_LEVEL_INTEGRAL_CASH_NM;
//		}
//		//	普卡/金卡
//		else {
//			exchangeLevelName = Contants.MEMBER_LEVEL_JP_NM;
//		}
//		return exchangeLevelName;
//	}

	/**
	 * 搭销订单
	 *
	 * @param paramMap String itemCode 单品id String orderId 搭销子订单 String curStatusId 搭销子订单状态 List <String>
	 *            promotionItemCodes 供应商活动单品List User user 用户
	 */
	@Override
	public Response<Map<String, Object>> createTieinSaleOrder(Map<String, Object> paramMap) {
		String itemCode = (String) paramMap.get("itemCode");
		String orderId = (String) paramMap.get("orderId");
		String curStatusId = (String) paramMap.get("curStatusId");
		User user = (User) paramMap.get("user");
		List<String> promotionItemCodes = (List<String>) paramMap.get("promotionItemCodes");
		Map<String, Object> responseMap = Maps.newHashMap();
		Response<Map<String, Object>> response = new Response<>();
		try {
			checkArgument(StringUtils.isNotBlank(itemCode), "itemCode.can.not.be.empty");
			checkArgument(StringUtils.isNotBlank(orderId), "orderId.can.not.be.empty");
			checkArgument(StringUtils.isNotBlank(curStatusId), "curStatusId.can.not.be.empty");
			OrderSubModel orderModel = new OrderSubModel();
			orderModel = orderSubDao.findById(orderId);
			if (orderModel == null) {
				TblOrderHistoryModel tblOrderHistoryModel = tblOrderHistoryDao.findById(orderId);
				if (tblOrderHistoryModel == null) {
					log.error("OrderService createTieinSaleOrder,orderSubModel.be.null");
					response.setError("orderSubModel.be.null");
					return response;
				}
				orderModel = new OrderSubModel();
				BeanMapper.copy(tblOrderHistoryModel, orderModel);
			}
			if (!curStatusId.equals(orderModel.getCurStatusId())) {
				responseMap.put("result", Boolean.FALSE);
				responseMap.put("error", "statusChanged");
				response.setResult(responseMap);
				return response;
			}
			String orderMainId = orderModel.getOrdermainId();
			checkArgument(StringUtils.isNotBlank(orderMainId), "orderMainId.can.not.be.empty");
			OrderMainModel orderMainModel = orderMainDao.findById(orderMainId);
			// 获取订单信息
			Boolean orderMianFlag=Boolean.TRUE;
			if (orderMainModel == null) {
				TblOrdermainHistoryModel tblOrdermainHistoryModel = new TblOrdermainHistoryModel();
				tblOrdermainHistoryModel = tblOrdermainHistoryDao.findById(orderMainId);
				if (tblOrdermainHistoryModel == null) {
					log.error("OrderService createTieinSaleOrder,orderMainModel.be.null");
					response.setError("orderMainModel.be.null");
					return response;
				}
				orderMianFlag=Boolean.FALSE;
				orderMainModel = new OrderMainModel();
				BeanMapper.copy(tblOrdermainHistoryModel, orderMainModel);
			}
			String vendorId = user.getVendorId();
			checkArgument(StringUtils.isNotBlank(vendorId), "vendorId.can.not.be.empty");
			if (!vendorId.equals(orderModel.getVendorId())) {
				log.error("OrderService createTieinSaleOrder,vendorId.be.wrong");
				response.setError("vendorId.be.wrong");
				return response;
			}
			// 选择的支付卡卡号
			String cardNo = orderMainModel.getCardno();
			checkArgument(StringUtils.isNotBlank(cardNo), "cardNo.can.not.be.empty");
			// 购买数量
			Integer num = 1;
			Response<ItemModel> itemModelResponse = new Response<>();
			itemModelResponse = itemService.findByItemcode(itemCode);
			if (!itemModelResponse.isSuccess()) {
				log.error("OrderService createTieinSaleOrder error,itemService findByItemcode error");
				throw new TradeException("itemModel.be.null");
			}
			ItemModel itemModel = new ItemModel();
			itemModel = itemModelResponse.getResult();
			if (itemModel == null) {
				log.error("OrderService createTieinSaleOrder error,itemService findByItemcode error itemModel.be.null");
				throw new TradeException("itemModel.be.null");
			}
			String goodsCode = itemModel.getGoodsCode();
			checkArgument(itemModel.getStock() >= num, "stock.be.not.enough");
			itemModel.setStock(itemModel.getStock() - num);
			itemModel.setModifyOper(user.getVendorId());
			Response<GoodsModel> goodsModelResponse = new Response<>();
			goodsModelResponse = goodsService.findById(goodsCode);
			if (!goodsModelResponse.isSuccess()) {
				log.error("OrderService createTieinSaleOrder error,goodsService findById error");
				throw new TradeException("goodsModel.be.null");
			}
			GoodsModel goodsModel = new GoodsModel();
			goodsModel = goodsModelResponse.getResult();
			if (goodsModel == null) {
				throw new TradeException("goodsModel.be.null");
			}
			if (!checkCardGoods(cardNo,goodsModel)){
				throw new TradeException("card.can.not.buy.goods");
			}
			String goodsType = goodsModel.getGoodsType();
			// 判断是否是实物，O2O商品
			if (Contants.SUB_ORDER_TYPE_00.equals(goodsType) || Contants.SUB_ORDER_TYPE_02.equals(goodsType)) {
				// 实物，O2O商品结算数量最大为99件 重新计算订单数
				if (orderMainModel.getTotalNum() + num > 99) {
					responseMap.put("result", Boolean.FALSE);
					responseMap.put("error", "numberOver");
					response.setResult(responseMap);
					return response;
				}
			} else {
				responseMap.put("result", Boolean.FALSE);
				responseMap.put("error", "goodsTypeChanged");
				response.setResult(responseMap);
				return response;
			}
			// 判断商品是否在售
			if (!Contants.CHANNEL_MALL_02.equals(goodsModel.getChannelMall())) {
				responseMap.put("result", Boolean.FALSE);
				responseMap.put("error", "channelMallChanged");
				response.setResult(responseMap);
				return response;
			}
			if (!vendorId.equals(goodsModel.getVendorId())) {
				log.error("OrderService createTieinSaleOrder error,goodsModel vendorId.be.wrong");
				response.setError("vendorId.be.wrong");
				return response;
			}
			// 检验单品活动状态
			for (String promotionItemCode : promotionItemCodes) {
				if (promotionItemCode.equals(itemCode)) {
					responseMap.put("result", Boolean.FALSE);
					responseMap.put("error", "ItemInPromotion");
					response.setResult(responseMap);
					return response;
				}
			}
			Response<VendorInfoModel> vendorInfoModelResponse = vendorService.findVendorById(user.getVendorId());
			if (!vendorInfoModelResponse.isSuccess()) {
				log.error("vendorService findVendorById error");
				throw new TradeException("VendorInfoModel.be.null");
			}
			VendorInfoModel vendorInfoModel = new VendorInfoModel();
			vendorInfoModel = vendorInfoModelResponse.getResult();
			if (vendorInfoModel == null) {
				throw new TradeException("VendorInfoModel.be.null");
			}

			Response<List<TblGoodsPaywayModel>> tblGoodsPaywayModelResponse = orderTieinSaleService
					.findByItemCode(itemCode);
			if(!tblGoodsPaywayModelResponse.isSuccess()){
				log.error("Response.error,error code: {}", tblGoodsPaywayModelResponse.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
			}
			List<TblGoodsPaywayModel> tblGoodsPaywayModelList = tblGoodsPaywayModelResponse.getResult();
			if (tblGoodsPaywayModelList == null || tblGoodsPaywayModelList.isEmpty()) {
				log.error("OrderService createTieinSaleOrder error,tblGoodsPaywayModel.be.null");
				response.setError("tblGoodsPaywayModel.be.empty");
				return response;
			}
			TblGoodsPaywayModel tblGoodsPaywayModel = new TblGoodsPaywayModel();
			tblGoodsPaywayModel = tblGoodsPaywayModelList.get(tblGoodsPaywayModelList.size() - 1);
			if (tblGoodsPaywayModel == null) {
				log.error("OrderService createTieinSaleOrder error,tblGoodsPaywayModel.be.null");
				response.setError("tblGoodsPaywayModel.be.empty");
				return response;
			}
			orderMainModel.setTotalNum(orderMainModel.getTotalNum() + num);
			BigDecimal goodsPrice = tblGoodsPaywayModel.getGoodsPrice();
			if (goodsPrice == null) {
				log.error("OrderService createTieinSaleOrder error,tblGoodsPaywayModel.GoodsPrice.be.null");
				response.setError("tblGoodsPaywayModel.GoodsPrice.be.null");
				return response;
			}
			orderMainModel.setTotalPrice(orderMainModel.getTotalPrice().add(tblGoodsPaywayModel.getGoodsPrice()));
			orderMainModel.setModifyOper(user.getVendorId());
			final OrderSubModel orderSubModel = new OrderSubModel();
			orderSubModel.setBalanceStatus("0002");// 已完成
			orderSubModel.setActCategory("1");
			orderSubModel.setActName("搭销");
			orderSubModel.setIsTieinSale("1");
			orderSubModel.setRemindeFlag(0);
			orderSubModel.setOperSeq(new Integer(0));
			// 秒杀标示 0 非零元秒杀
			orderSubModel.setMiaoshaActionFlag(new Integer(0));
			orderSubModel.setO2oExpireFlag(Contants.ORDER_O2O_EXPIRE_FLAG_NO);
			orderSubModel.setOrdertypeId(orderMainModel.getOrdertypeId());// 业务类型代码YG:广发商城(一期)JF:积分商城FQ:广发商城(分期)
			orderSubModel.setOrdertypeNm(orderMainModel.getOrdertypeNm());// 业务类型名称
			orderSubModel.setPaywayCode(Contants.PAY_WAY_CODE_XJ);// 支付方式代码0001:
			// 现金0002:
			// 积分0003:
			// 积分+现金0004:
			// 手续费0005:
			// 现金+手续费0006:
			// 积分+手续费0007:
			// 积分+现金+手续费
			orderSubModel.setPaywayNm(Contants.PAY_WAY_NM_XJ);// 支付方式代码0001:
			// 现金0002:
			// 积分0003:
			// 积分+现金0004:
			// 手续费0005:
			// 现金+手续费0006:
			// 积分+手续费0007:
			// 积分+现金+手续费
			orderSubModel.setCardno(cardNo);// 卡号
			orderSubModel.setVendorId(user.getVendorId());// 供应商代码
			orderSubModel.setVendorSnm(vendorInfoModel.getSimpleName());// 供应商简称
			orderSubModel.setSourceId(orderMainModel.getSourceId());// 渠道代码00:
			// 商城01:
			// CallCenter02:
			// IVR渠道03:
			// 手机商城04:
			// 短信渠道05:
			// 微信广发银行06：微信广发信用卡
			orderSubModel.setSourceNm(orderMainModel.getSourceNm());
			orderSubModel.setGoodsCode(itemModel.getGoodsCode()); // 商品ID
			orderSubModel.setGoodsId(itemModel.getCode());// 单品代码
			orderSubModel.setGoodsNm(goodsModel.getName());// 商品名
			orderSubModel.setCalMoney(tblGoodsPaywayModel.getCalMoney());
			orderSubModel.setGoodsNum(num);// 商品数量
			orderSubModel.setGoodsaskforFlag("0");// 请款标记0－未请款[默认]1－已请款
			orderSubModel.setCurrType("156");// 商品币种
			orderSubModel.setExchangeRate(new BigDecimal(100));// 对人民币的汇率值
			orderSubModel.setSpecShopnoType("");// 特店类型
			orderSubModel.setPayTypeNm("");// 佣金代码名称
			orderSubModel.setIncCode("");// 手续费率代码
			orderSubModel.setIncCodeNm("");// 手续费名称
			orderSubModel.setCommissionType("");// 佣金计算类别
			orderSubModel.setCommissionRate(new BigDecimal(0));// 佣金区间佣金率(不包含%)
			orderSubModel.setCommission(new BigDecimal(0));// 佣金金额【与币种一致】
			orderSubModel.setOrigMoney(new BigDecimal(0));// 原始现金总金额
			orderSubModel.setIncWay("00");// 手续费获取方式
			orderSubModel.setIncRate(new BigDecimal(0));// 手续费率(不包含%)
			orderSubModel.setIncMoney(new BigDecimal(0));// 手续费总金额
			orderSubModel.setUitfeeflg(new Integer("0"));// 手续费减免期数
			orderSubModel.setUitfeedam(new BigDecimal(0));// 手续费减免金额
			orderSubModel.setUitdrtuit(new Integer("0"));// 本金减免期数
			orderSubModel.setUitdrtamt(new BigDecimal(0));// 本金减免金额
			orderSubModel.setIncBackPrice(new BigDecimal(0));// 手续费退回指定金额
			// orderSubModel.setIncTakePrice(new BigDecimal(0));// 退单时收取指定金额手续费
			orderSubModel.setVoucherPrice(new BigDecimal(0));// 优惠金额
			orderSubModel.setCreditFlag("");// 授权额度不足处理方式
			orderSubModel.setCalWay("");// 退货方式
			orderSubModel.setLockedFlag("0");// 订单锁标记
			orderSubModel.setVendorOperFlag("1");// 供应商操作标记

			orderSubModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0301);// 当前状态代码-订单状态0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
			orderSubModel.setCurStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);

			orderSubModel.setCreateOper(orderMainModel.getCreateOper());// 创建操作员id
			orderSubModel.setDelFlag(Contants.DEL_FLAG_0);// 逻辑删除标志0未删1已删

			// todo:数据库非必输字段
			orderSubModel.setTypeId("");// 商品类别ID
			orderSubModel.setLevelNm("");// 商品类别名称
			orderSubModel.setGoodsBrand(goodsModel.getGoodsBrandName());// 品牌
			orderSubModel.setGoodsModel("");// 型号
			orderSubModel.setGoodsColor("");// 商品颜色
			// orderSubModel.setActType("");// 活动类型
			orderSubModel.setMerId(vendorInfoModel.getMerId());// 商户号
			orderSubModel.setReserved1(vendorInfoModel.getUnionPayNo());// 保存银联商户号
			orderSubModel.setGoodsAttr1(itemModel.getAttributeKey1());// 销售属性（json串）
			orderSubModel.setGoodsAttr2(itemModel.getAttributeKey2());
			orderSubModel.setGoodsPresent("");// 赠品 未完成
			orderSubModel.setBonusTrnDate(DateHelper.getyyyyMMdd());// 支付日期
			orderSubModel.setBonusTrnTime(DateHelper.getHHmmss());// 支付时间
			orderSubModel.setTmpStatusId("0000");// 临时状态代码
			orderSubModel.setCommDate(DateHelper.getyyyyMMdd());// 业务日期
			orderSubModel.setCommTime(DateHelper.getHHmmss());// 业务时间
			orderSubModel.setGoodssendFlag("0");// 发货标记 0－未发货[默认] 1－已发货 2－已签收
			orderSubModel.setEUpdateStatus("0");// 插入订单状态更新接口标志位 0:初始化
			orderSubModel.setCardtype(Contants.CARD_TYPE_C);// 卡标志C：信用卡Y：借记卡

			String goodsTypeItem = goodsModel.getGoodsType();
			orderSubModel.setGoodsType(goodsTypeItem);// 商品类型（00实物01虚拟02O2O）
			if (Contants.SUB_ORDER_TYPE_00.equals(goodsTypeItem)) {
				orderSubModel.setGoodsTypeName(Contants.GOODS_TYPE_NM_00);
			}
			if (Contants.SUB_ORDER_TYPE_01.equals(goodsTypeItem)) {
				orderSubModel.setGoodsTypeName(Contants.GOODS_TYPE_NM_01);
			}
			if (Contants.SUB_ORDER_TYPE_02.equals(goodsTypeItem)) {
				orderSubModel.setGoodsTypeName(Contants.GOODS_TYPE_NM_02);
			}
			orderSubModel.setMemberName(orderMainModel.getContNm());// 会员名称
			orderSubModel.setItemSmallPic(itemModel.getImage1());// 单品小图标
			orderSubModel.setDelFlag(Contants.DEL_FLAG_0);// 逻辑删除标志0未删1已删
			// 数据库不为空项
			orderSubModel.setVerifyFlag("");

			orderSubModel.setStagesNum(tblGoodsPaywayModel.getStagesCode());
			orderSubModel.setGoodsPaywayId(tblGoodsPaywayModel.getGoodsPaywayId());
			orderSubModel.setSpecShopno(tblGoodsPaywayModel.getCategoryNo());
			orderSubModel.setInstallmentPrice(tblGoodsPaywayModel.getPerStage());
			orderSubModel.setIncTakePrice(tblGoodsPaywayModel.getPerStage());// 退单时收取指定金额手续费(未用)

			orderSubModel.setVoucherNo("");
			// orderSubModel.setVoucherNm(voucherNm);
			orderSubModel.setTotalMoney(tblGoodsPaywayModel.getGoodsPrice());// 现金总金额
			orderSubModel.setSinglePrice(tblGoodsPaywayModel.getGoodsPrice());// 单价
			orderSubModel.setFenefit(new BigDecimal(0));
			orderSubModel.setCreateTime(new Date());
			orderSubModel.setModifyTime(new Date());

			OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
			orderDoDetailModel.setDoUserid(user.getVendorId());// 处理用户
			orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_2);// 用户类型0：系统用户[批量]1：内部用户[cc]2：供应商3：持卡人
			orderDoDetailModel.setStatusId(Contants.SUB_ORDER_STATUS_0301);// 状态代码0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
			orderDoDetailModel.setStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);// 状态名称
			orderDoDetailModel.setCreateOper(orderSubModel.getCreateOper());// 创建人
			orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);// 逻辑删除标记为(0未删除，1已删除)
			orderDoDetailModel.setDoDesc("搭销订单");
			// 更新数据库
			Boolean result = orderMainManager.createOrder(orderMainModel, orderSubModel, orderDoDetailModel, itemModel, orderMianFlag);
			// 我的消息
			ExecutorService executorService = Executors.newFixedThreadPool(1);
			executorService.submit(new Runnable() {
				public void run() {
					try {
						insertUserMessage(orderSubModel, Boolean.FALSE);
					} catch (Exception e) {
						log.error("我的消息插入失败,error:{}",Throwables.getStackTraceAsString(e));
					}
				}
			});
			responseMap.put("result",Boolean.TRUE);
			responseMap.put("orderSubModel",orderSubModel);
			responseMap.put("orderMainModel",orderMainModel);
			response.setResult(responseMap);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("OrderServiceImpl createTieinSaleOrder.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (TradeException e) {
			log.error("OrderServiceImpl createTieinSaleOrder.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl createTieinSaleOrder.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.createTieinSaleOrder.error");
			return response;
		}
	}

	/**
	 * APP广发获取返回的报文
	 *
	 * @param pagePaymentReqDto
	 * @param orderMain
	 * @param orderSubModelList
	 *
	 * @author huangchaoyong on 20160918
	 */
	private void getReturnObjForPay(PagePaymentReqDto pagePaymentReqDto, OrderMainModel orderMain,
			List orderSubModelList) throws Exception {
		log.info("into 广发 getReturnObjForPay");
		String orderid = orderMain.getOrdermainId();// 大订单号
		String amount = orderMain.getTotalPrice().toString();// 总金额
		String payType = "";// 支付类型
		String pointType = "";// 积分类型
		String pointSum = "0";// 总积分值
		String isMerge = orderMain.getIsmerge();// 是否合并支付
		String payAccountNo = orderMain.getCardno();// 支付账号
		String serialNo = orderMain.getSerialNo();// 交易流水号
		String tradeDate = DateHelper.getyyyyMMdd(orderMain.getCreateTime());// 订单日期
		String tradeTime = DateHelper.getHHmmss(orderMain.getCreateTime());// 订单时间
		String certType = orderMain.getContIdType();// 证件类型
		String certNo = orderMain.getContIdcard();// 证件号
		String otherOrdersInf = "";// 优惠券、积分信息串
		pagePaymentReqDto.setSerialNo(serialNo);// 商城生成的流水号 为空
		pagePaymentReqDto.setTradeDate(tradeDate);// 交易日期 为空
		pagePaymentReqDto.setTradeTime(tradeTime);// 交易时间 为空
		pagePaymentReqDto.setOrderid(orderid);// 大订单号
		pagePaymentReqDto.setAmount(amount);// 总金额
		pagePaymentReqDto.setMerchId(merchId);// 大商户号
		pagePaymentReqDto.setReturl(returl);// 回调地址
		pagePaymentReqDto.setPointType(pointType);// 积分类型 为空
		pagePaymentReqDto.setPointSum(pointSum);// 总积分值 为空
		pagePaymentReqDto.setIsMerge(isMerge);// 是否合并支付 为空
		pagePaymentReqDto.setPayAccountNo(payAccountNo);// 支付账号 为空
		// 0-商城分期(广发商城)（17-商城分期）
		// 1-商城信用卡支付(广发商城)（01-B2C支付，若payType空也归此类）
		if (Contants.BUSINESS_TYPE_YG.equals(orderMain.getOrdertypeId())) {// 如果是一次性
			log.info("一次性");
			payType = "1";
		} else {
			log.info("非一次性");
			payType = "0";
		}
		pagePaymentReqDto.setPayType(payType);// 支付类型
		String orders = "";
		boolean flag = false;
		for (int i = 0; i < orderSubModelList.size(); i++) {
			OrderSubModel orderSubModel = (OrderSubModel) orderSubModelList.get(i);
			// 商户号|订单号|流水号|金额|分期数|每期金额|优惠券编号|积分类型|积分数|积分抵扣金额
			if (i == 0) {// 如果是第一个子订单
				orders = Joiner.on("|").join(nullToEmpty(orderSubModel.getMerId()),
						nullToEmpty(orderSubModel.getOrderId()), nullToEmpty(orderSubModel.getOrderIdHost()),
						orderSubModel.getTotalMoney(), orderSubModel.getStagesNum(),
						orderSubModel.getInstallmentPrice(), nullToEmpty(orderSubModel.getVoucherNo()),
						nullToEmpty(orderSubModel.getIntegraltypeId()),
						orderSubModel.getBonusTotalvalue() == null ? "0"
								: orderSubModel.getBonusTotalvalue().toString(),
						orderSubModel.getUitdrtamt() == null ? "0" : orderSubModel.getUitdrtamt().toString());
				// if ((orderSubModel != null && !"".equals(orderSubModel.getVoucherNo())) ||
				// orderSubModel.getBonusTotalvalue().longValue() != 0) {
				// // 存在使用积分、优惠券
				// flag = true;
				// }
				// otherOrdersInf = Joiner.on("|").join(nullToEmpty(orderSubModel.getOrderIdHost()),
				// nullToEmpty(orderSubModel.getMerId()),
				// orderSubModel.getOrderId(), nullToEmpty(orderSubModel.getVoucherNo()),
				// nullToEmpty(orderSubModel.getIntegraltypeId()),
				// orderSubModel.getBonusTotalvalue() == null ? "0" : orderSubModel.getBonusTotalvalue().toString(),
				// orderSubModel.getUitdrtamt() == null ? "0" : orderSubModel.getUitdrtamt().toString());
			} else {
				orders = Joiner.on("|").join(nullToEmpty(orders), orderSubModel.getMerId(), orderSubModel.getOrderId(),
						nullToEmpty(orderSubModel.getOrderIdHost()), orderSubModel.getTotalMoney(),
						orderSubModel.getStagesNum(), orderSubModel.getInstallmentPrice(),
						nullToEmpty(orderSubModel.getVoucherNo()), nullToEmpty(orderSubModel.getIntegraltypeId()),
						orderSubModel.getBonusTotalvalue() == null ? "0"
								: orderSubModel.getBonusTotalvalue().toString(),
						orderSubModel.getUitdrtamt() == null ? "0" : orderSubModel.getUitdrtamt().toString());
				// if (!Strings.isNullOrEmpty(orderSubModel.getVoucherNo()) ||
				// orderSubModel.getBonusTotalvalue().longValue() != 0) {
				// // 存在使用积分、优惠券
				// flag = true;
				// }
				// otherOrdersInf = Joiner.on("|").join(nullToEmpty(otherOrdersInf),
				// nullToEmpty(orderSubModel.getOrderIdHost()), nullToEmpty(orderSubModel.getMerId()),
				// nullToEmpty(orderSubModel.getOrderId()), nullToEmpty(orderSubModel.getVoucherNo()),
				// nullToEmpty(orderSubModel.getIntegraltypeId()),
				// orderSubModel.getBonusTotalvalue() == null ? "0" : orderSubModel.getBonusTotalvalue().toString(),
				// orderSubModel.getUitdrtamt() == null ? "0" : orderSubModel.getUitdrtamt().toString());
			}
		}
		log.info("密钥：" + mainPrivateKey);
		if (!flag) {// 如果没使用优惠券、积分
			certType = "";
			certNo = "";
			otherOrdersInf = "";
		} else {// 打印出优惠券积分串
			log.info("积分、优惠券串otherOrdersInf:" + otherOrdersInf);
		}
		pagePaymentReqDto.setOrders(orders);// 订单信息串
		pagePaymentReqDto.setOtherOrdersInf(otherOrdersInf);// 优惠券信息串
		pagePaymentReqDto.setCertType(certType);
		pagePaymentReqDto.setCertNo(certNo);
		String singGene = Joiner.on("|").join(merchId, nullToEmpty(orderid), amount, payType, tradeDate,
				nullToEmpty(tradeTime), nullToEmpty(orders)).trim();
		log.info("订单信息串singGene:" + singGene);
		// 改用旧系统加密方式
		String sign = SignAndVerify.sign_md(singGene, mainPrivateKey);// 签名
		pagePaymentReqDto.setSign(sign);// 签名
		pagePaymentReqDto.setPayAddress(payAddress);// 支付网关地址
		pagePaymentReqDto.setIsPractiseRun("0");
		pagePaymentReqDto.setTradeChannel(Contants.TRADECHANNEL);
		pagePaymentReqDto.setTradeSource(Contants.TRADESOURCE);
		pagePaymentReqDto.setBizSight(Contants.BIZSIGHT);
		pagePaymentReqDto.setSorceSenderNo(orderid); //// 源发起方流水:大订单号
		pagePaymentReqDto.setOperatorId("");
		if (log.isDebugEnabled())
			log.debug("\n************ e-payment request info start ************" + "\nreturnCode: "
					+ pagePaymentReqDto.getReturnCode() + "\nerrorMsg: " + pagePaymentReqDto.getErrorMsg()
					+ "\npayAddress: " + pagePaymentReqDto.getPayAddress() + "\norderid: "
					+ pagePaymentReqDto.getOrderid() + "\namount: " + pagePaymentReqDto.getAmount() + "\nmerchId: "
					+ pagePaymentReqDto.getMerchId() + "\nsign: " + pagePaymentReqDto.getSign() + "\nreturl: "
					+ pagePaymentReqDto.getReturl() + "\npointType: " + pagePaymentReqDto.getPointType()
					+ "\npointSum: " + pagePaymentReqDto.getPointSum() + "\nisMerge: " + pagePaymentReqDto.getIsMerge()
					+ "\npayType: " + pagePaymentReqDto.getPayType() + "\norders: " + pagePaymentReqDto.getOrders()
					+ "\notherOrdersInf: " + pagePaymentReqDto.getOtherOrdersInf() + "\npayAccountNo: "
					+ pagePaymentReqDto.getPayAccountNo() + "\nserialNo: " + pagePaymentReqDto.getSerialNo()
					+ "\ntradeDate: " + pagePaymentReqDto.getTradeDate() + "\ntradeTime: "
					+ pagePaymentReqDto.getTradeTime() + "\nentry_card: " + pagePaymentReqDto.getEntry_card()
					+ "\ntradeCode: " + pagePaymentReqDto.getTradeCode() + "\nvirtualPrice: "
					+ pagePaymentReqDto.getVirtualPrice() + "\ntradeDesc: " + pagePaymentReqDto.getTradeDesc()
					+ "\ncertType: " + pagePaymentReqDto.getCertType() + "\ncertNo: " + pagePaymentReqDto.getCertNo()
					+ "\nisPractiseRun: " + pagePaymentReqDto.getIsPractiseRun() + "\ntradeChannel: "
					+ pagePaymentReqDto.getTradeChannel() + "\ntradeSource: " + pagePaymentReqDto.getTradeSource()
					+ "\nbizSight: " + pagePaymentReqDto.getBizSight() + "\nsorceSenderNo: "
					+ pagePaymentReqDto.getSorceSenderNo() + "\noperatorId: " + pagePaymentReqDto.getOperatorId()
					+ "\n************ e-payment request info end ************");
	}

	/**
	 * App积分获取返回的报文
	 *
	 * @param pagePaymentReqDto
	 * @param orderMain
	 * @param orderSubModelList
	 *
	 * @author huangchaoyong on 2016-9-2
	 *
	 */
	private void getReturnObjForAppPay(PagePaymentReqDto pagePaymentReqDto, OrderMainModel orderMain,
			List<OrderSubModel> orderSubModelList) throws Exception {
		log.info("into 积分 getReturnObjForPay");
		String orderid = orderMain.getOrdermainId();// 大订单号
		String amount = orderMain.getTotalPrice() == null ? "0.0" : orderMain.getTotalPrice().setScale(1).toString();// 总金额
		String payType = "2";// 支付类型
		String pointType = Strings.padEnd(orderSubModelList.get(0).getBonusType(), 4, ' ');// 积分类型
		String pointSum = orderMain.getTotalBonus().toString();// 总积分值
		String isMerge = orderMain.getIsmerge();// 是否合并支付
		String payAccountNo = orderMain.getCardno();// 支付账号
		String serialNo = orderMain.getSerialNo();// 交易流水号
		String tradeDate = DateHelper.date2string(orderMain.getCreateTime(), "yyyyMMdd");// 订单日期
		String tradeTime = DateHelper.date2string(orderMain.getCreateTime(), "HHmmss");// 订单时间
		/******* 优惠券需求添加end ******/
		pagePaymentReqDto.setSerialNo(serialNo);// 商城生成的流水号 为空
		pagePaymentReqDto.setTradeDate(tradeDate);// 交易日期 为空
		pagePaymentReqDto.setTradeTime(tradeTime);// 交易时间 为空
		pagePaymentReqDto.setOrderid(orderid);// 大订单号
		pagePaymentReqDto.setAmount(amount);// 总金额
		pagePaymentReqDto.setMerchId(merchId);// 大商户号
		pagePaymentReqDto.setPointType(pointType);// 积分类型 为空
		pagePaymentReqDto.setPointSum(pointSum);// 总积分值 为空
		pagePaymentReqDto.setIsMerge(isMerge);// 是否合并支付 为空
		pagePaymentReqDto.setPayType(payType);// 支付类型
		String orders = orderid + "|" + merchId + "|" + amount + "|" + pointSum;
		pagePaymentReqDto.setOrders(orders);// 订单信息串
		String singGene = Joiner.on("|").join(merchId, nullToEmpty(orderid), amount, pointType.trim(), pointSum,
				isMerge, payType, nullToEmpty(orders), nullToEmpty(serialNo), tradeDate, nullToEmpty(tradeTime)).trim();
		log.info("订单信息串singGene:" + singGene);
		// 改用旧系统加密方式
		String sign = SignAndVerify.sign_md(singGene, mainPrivateKey);// 签名
		pagePaymentReqDto.setSign(sign);// 签名
		log.debug("************电子支付报文信息************" + "returnCode: " + pagePaymentReqDto.getReturnCode() + "errorMsg: "
				+ pagePaymentReqDto.getErrorMsg() + "payAddress: " + pagePaymentReqDto.getPayAddress() + "orderid: "
				+ pagePaymentReqDto.getOrderid() + "amount: " + pagePaymentReqDto.getAmount() + "merchId: "
				+ pagePaymentReqDto.getMerchId() + "sign: " + pagePaymentReqDto.getSign() + "pointType: "
				+ pagePaymentReqDto.getPointType() + "pointSum: " + pagePaymentReqDto.getPointSum() + "isMerge: "
				+ pagePaymentReqDto.getIsMerge() + "payType: " + pagePaymentReqDto.getPayType() + "orders: "
				+ pagePaymentReqDto.getOrders() + "serialNo: " + pagePaymentReqDto.getSerialNo() + "tradeDate: "
				+ pagePaymentReqDto.getTradeDate() + "tradeTime: " + pagePaymentReqDto.getTradeTime());
	}

	/**
	 * 获取单品已购买的件数
	 *
	 * @param paramMap
	 * @return geshuo 20160707
	 */
	public Response<Map<String, Long>> findItemBuyCount(Map<String, Object> paramMap) {
		Response<Map<String, Long>> response = new Response<>();
		try {
			Map<String, Long> result = Maps.newHashMap();
			List<BuyCountModel> countList = orderSubDao.findItemBuyCount(paramMap);
			for (BuyCountModel countModel : countList) {
				result.put(countModel.getItemCode(), countModel.getBuyCount());
			}
			response.setResult(result);
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl findGoodsBuyCount query error", Throwables.getStackTraceAsString(e));
			response.setSuccess(false);
			response.setError("OrderServiceImpl.findGoodsBuyCount.query.error");
			return response;
		}
	}

	@Override
	public Response<OrderSubModel> validateOrderInf(String subOrderNo) {
		Response<OrderSubModel> response = new Response<OrderSubModel>();
		try {
			OrderSubModel orderSubModel = orderSubDao.validateOrderInf(subOrderNo);
			response.setResult(orderSubModel);
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl validateOrderInf query error", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.validateOrderInf.query.error");
			return response;
		}
	}

	@Override
	public Response<Integer> updateStatues(OrderSubModel orderSubModel) {
		Response<Integer> response = new Response<Integer>();
		try {
			Integer orderSub = orderSubManager.updateStatues(orderSubModel);
			response.setResult(orderSub);
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl updateStatues query error", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.updateStatues.query.error");
			return response;
		}
	}

	@Override
	public Response<OrderSubModel> validateBackMsg(String orderNo) {
		Response<OrderSubModel> response = new Response<OrderSubModel>();
		try {
			OrderSubModel orderSub = orderSubDao.validateBackMsg(orderNo);
			response.setResult(orderSub);
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl updateStatues query error", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.updateStatues.query.error");
			return response;
		}
	}

	/**
	 * 查询主订单下的所有子订单（用于手动推送O2O订单接口调用）
	 *
	 * @param ordermainId
	 * @return
	 */
	@Override
	public Response<List<O2OOrderInfo>> findpushOrder(String ordermainId) {
		Response<List<O2OOrderInfo>> response = Response.newResponse();
		try {
			List<OrderSubModel> orderSubModels = orderSubDao.findByOrderMainId(ordermainId);
			List<O2OOrderInfo> o2OOrderInfos = Lists.newArrayList();
			// 循环orderSubModels,构造返回值
			for (OrderSubModel orderSubModel : orderSubModels) {
				if (!Contants.SUB_ORDER_STATUS_0308.equals(orderSubModel.getCurStatusId())) {
					response.setError("orderStatus.has.changed");
					return response;
				}
				O2OOrderInfo o2OOrderInfo = new O2OOrderInfo();
				o2OOrderInfo.setSubOrderId(orderSubModel.getOrderId());
				o2OOrderInfo.setType(0);
				BigDecimal goodsNum = new BigDecimal(orderSubModel.getGoodsNum());
				if (Contants.BUSINESS_TYPE_JF.equals(orderSubModel.getOrdertypeId())) {
					o2OOrderInfo.setPrice(orderSubModel.getCalMoney());
					o2OOrderInfo.setAmount(orderSubModel.getCalMoney().multiply(goodsNum));
				} else {
					BigDecimal pament = new BigDecimal(0);
					orderSubModel.setTotalMoney(
							orderSubModel.getTotalMoney() == null ? BigDecimal.ZERO : orderSubModel.getTotalMoney());
					orderSubModel.setVoucherPrice(orderSubModel.getVoucherPrice() == null ? BigDecimal.ZERO
							: orderSubModel.getVoucherPrice());
					orderSubModel.setUitdrtamt(
							orderSubModel.getUitdrtamt() == null ? BigDecimal.ZERO : orderSubModel.getUitdrtamt());
					pament.add(orderSubModel.getTotalMoney());
					pament.add(orderSubModel.getVoucherPrice());
					pament.add(orderSubModel.getUitdrtamt());
					o2OOrderInfo.setPrice(pament);
					o2OOrderInfo.setAmount(pament.multiply(goodsNum));
				}
				String goodsId = orderSubModel.getGoodsId();
				ItemModel itemModel = itemService.findById(goodsId);
				if (itemModel != null) {
					o2OOrderInfo.setSOrderId(itemModel.getO2oCode());
					o2OOrderInfo.setGoodsId(itemModel.getO2oVoucherCode());
				}
				o2OOrderInfo.setNumber(orderSubModel.getGoodsNum());
				OrderMainModel orderMainModel = orderMainDao.findById(orderSubModel.getOrdermainId());
				if (orderMainModel != null) {
					o2OOrderInfo.setMobile(orderMainModel.getCsgPhone1());
				}
				o2OOrderInfos.add(o2OOrderInfo);
			}
			response.setResult(o2OOrderInfos);
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl findpushOrder query error{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.findpushOrder.query.error");
			return response;
		}
	}

	/**
	 * @param orderMainId
	 * @param user
	 * @return
	 */
	@Override
	public Response<PagePaymentReqDto> payoffOrder(String orderMainId, User user) {
		Response<PagePaymentReqDto> response = new Response<>();
		try {
			checkArgument(StringUtils.isNotBlank(orderMainId), "orderMainId.can.not.be.empty");
			String userId = user.getId();
			checkArgument(StringUtils.isNotBlank(userId), "userId.can.not.be.empty");
			OrderMainModel orderMainModel = orderMainDao.findById(orderMainId);
			if (orderMainModel == null) {
				response.setError("orderMainModel.be.null");
				return response;
			}
			if (!userId.equals(orderMainModel.getCreateOper())) {
				response.setError("orderMainModel.be.wrong");
				return response;
			}
			if (!Contants.SUB_ORDER_STATUS_0301.equals(orderMainModel.getCurStatusId())) {
				response.setError("orderMainModel.status.be.wrong");
				return response;
			}
			List<OrderSubModel> orderSubModelList = Lists.newArrayList();
			orderSubModelList = orderSubDao.findByOrderMainId(orderMainId);
			if (orderSubModelList == null || orderSubModelList.isEmpty()) {
				response.setError("orderSubModelList.be.Empty");
				return response;
			}
			List<String> orderIdList = Lists.newArrayList();
			for (OrderSubModel orderSubModel : orderSubModelList) {
				if (!Contants.SUB_ORDER_STATUS_0301.equals(orderSubModel.getCurStatusId())) {
					response.setError("orderSubModel.status.be.wrong");
					return response;
				}
				// 获取虚拟商品订单号
				if (Contants.SUB_ORDER_TYPE_01.equals(orderSubModel.getGoodsType())) {
					orderIdList.add(orderSubModel.getOrderId());
				}
			}
			Response<PagePaymentReqDto> pagePaymentReqDtoResponse = Response.newResponse();
			if (Contants.BUSINESS_TYPE_JF.equals(orderMainModel.getOrdertypeId())){
				//积分商城
				List<OrderVirtualModel>virtualModelList=Lists.newArrayList();
				if (orderIdList!=null&&!orderIdList.isEmpty()){
					virtualModelList=orderVirtualDao.findListByIds(orderIdList);
					if (virtualModelList == null || virtualModelList.isEmpty()) {
						response.setError("virtualModelList.be.empty");
						return response;
					}
					if (orderIdList.size() != virtualModelList.size()) {
						response.setError("virtualModelList.be.wrong");
						return response;
					}
				}
				pagePaymentReqDtoResponse = orderJFMainService.getReturnObjForPay_new(orderMainModel, orderSubModelList, virtualModelList);
			}else {
				//广发商城
				pagePaymentReqDtoResponse = orderMainService.getReturnObjForPay_new(orderMainModel, orderSubModelList);
			}
			if (!pagePaymentReqDtoResponse.isSuccess()) {
				response.setError(pagePaymentReqDtoResponse.getError());
				return response;
			}
			response.setResult(pagePaymentReqDtoResponse.getResult());
			return response;
		} catch (IllegalArgumentException e) {
			log.error("OrderServiceImpl payoffOrder.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl payoffOrder.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.payoffOrder.error");
			return response;
		}
	}

	@Override
	public Response<Map<String, Object>> expiredCode(String orderId, String vendorId) {
		Response<Map<String, Object>> response = new Response<>();
		Map<String, Object> resultMap = Maps.newHashMap();
		if (StringUtils.isBlank(orderId)){
			log.error("Orderservice  ExpiresCodes error,orderId be empty");
			response.setError("orderId.be.null");
			return response;
		}
		// 获取分布式锁
		String lockId = DistributedLocks.acquireLockWithTimeout(jedisTemplate, "O20EC" + orderId, 50, 10000);
		if (lockId == null) {
			log.info("orderService ExpiresCodes repeat actions，orderId："+orderId);
			response.setError("updateOrderSignVendor.repeat.actions");
			return response;
		}
		try {
			checkArgument(StringUtils.isNotBlank(vendorId), "vendorId.be.null");
			OrderSubModel orderSubModel = new OrderSubModel();
			orderSubModel = orderSubDao.findById(orderId);
			// 校验返回结果是否为空
			if (orderSubModel == null) {
				TblOrderHistoryModel tblOrderHistoryModel = tblOrderHistoryDao.findById(orderId);
				if (tblOrderHistoryModel == null) {
					DistributedLocks.releaseLock(jedisTemplate, "O20EC" + orderId,lockId);
					log.error("OrderService expiredCode error,orderId:" + orderId + "orderSubModel.be.null");
					response.setError("orderSubModel.be.null");
					return response;
				}
				orderSubModel = new OrderSubModel();
				BeanMapper.copy(tblOrderHistoryModel, orderSubModel);
			}
			if (!vendorId.equals(orderSubModel.getVendorId())) {
				DistributedLocks.releaseLock(jedisTemplate, "O20EC" + orderId,lockId);
				log.error("OrderService expiredCode error,vendorId:" + vendorId + "vendorId.be.wrong");
				response.setError("vendorId.be.wrong");
				return response;
			}
			if (!Contants.SUB_ORDER_STATUS_0310.equals(orderSubModel.getCurStatusId())) {
				DistributedLocks.releaseLock(jedisTemplate, "O20EC" + orderId,lockId);
				resultMap.put("result", Boolean.FALSE);
				resultMap.put("error", "statusChanged");
				response.setResult(resultMap);
				return response;
			}
			if (!Contants.SUB_SIN_STATUS_0311.equals(orderSubModel.getSinStatusId())) {
				DistributedLocks.releaseLock(jedisTemplate, "O20EC" + orderId,lockId);
				resultMap.put("result", Boolean.FALSE);
				resultMap.put("error", "sinStatusChanged");
				response.setResult(resultMap);
				return response;
			}
			if (!(Contants.ORDER_O2O_EXPIRE_FLAG_NO).equals(orderSubModel.getO2oExpireFlag())) {
				DistributedLocks.releaseLock(jedisTemplate, "O20EC" + orderId,lockId);
				resultMap.put("result", Boolean.FALSE);
				resultMap.put("error", "flagChanged");
				response.setResult(resultMap);
				return response;
			}
			orderSubModel.setO2oExpireFlag(Contants.ORDER_O2O_EXPIRE_FLAG_YES);
			orderSubModel.setModifyOper(vendorId);
			orderSubManager.updateO2OExpiredVendor(orderSubModel);
			resultMap.put("result", Boolean.TRUE);
			response.setResult(resultMap);
			DistributedLocks.releaseLock(jedisTemplate, "O20EC" + orderId,lockId);
			return response;
		} catch (IllegalArgumentException e) {
			DistributedLocks.releaseLock(jedisTemplate, "O20EC" + orderId,lockId);
			log.error("OrderServiceImpl expiredCode.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (TradeException e) {
			DistributedLocks.releaseLock(jedisTemplate, "O20EC" + orderId,lockId);
			log.error("OrderServiceImpl expiredCode.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			DistributedLocks.releaseLock(jedisTemplate, "O20EC" + orderId,lockId);
			log.error("OrderServiceImpl expiredCode.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.expiredCode.error");
			return response;
		}
	}

	// 发送短信
	public Response<Boolean> sendMsg(String orderId) {
		Response<Boolean> response = new Response<>();
		try {
			OrderSubModel orderSubModel = new OrderSubModel();
			orderSubModel = orderSubDao.findById(orderId);
			if (orderSubModel == null) {
				TblOrderHistoryModel tblOrderHistoryModel = tblOrderHistoryDao.findById(orderId);
				if (tblOrderHistoryModel == null) {
					log.error("OrderService sendMsg error,orderId:" + orderId + " orderSubModel be empty");
					response.setError("orderSubModel.be.null");
					return response;
				}
				orderSubModel = new OrderSubModel();
				BeanMapper.copy(tblOrderHistoryModel, orderSubModel);
			}
			Map<String, Object> map = Maps.newHashMap();
			String orderMainId = orderSubModel.getOrdermainId();
			OrderMainModel orderMainModel = new OrderMainModel();
			orderMainModel = orderMainDao.findById(orderMainId);
			// 获取订单信息
			if (orderMainModel == null) {
				TblOrdermainHistoryModel tblOrdermainHistoryModel = new TblOrdermainHistoryModel();
				tblOrdermainHistoryModel = tblOrdermainHistoryDao.findById(orderMainId);
				if (tblOrdermainHistoryModel == null) {
					log.error("OrderService sendMsg error,orderMainId:" + orderMainId + " orderMainModel be empty");
					response.setError("orderMainModel.be.null");
					return response;
				}
				orderMainModel = new OrderMainModel();
				BeanMapper.copy(tblOrdermainHistoryModel, orderMainModel);
			}
			// 手机号是否存在
			checkArgument(StringUtils.isNotBlank(orderMainModel.getContMobPhone()), "PhoneNumber.be.empty");
			String goodsPaywayId = orderSubModel.getGoodsPaywayId();
			checkArgument(StringUtils.isNotBlank(goodsPaywayId), "goodsPaywayId.be.null");

			// 获取支付关系信息
			Response<TblGoodsPaywayModel> response1 = new Response<>();
			response1 = orderTieinSaleService.findGoodsPrice(goodsPaywayId);
			if (!response1.isSuccess()) {
				log.error("OrderService sendMsg error,orderTieinSaleService findGoodsPrice failed");
				response.setError("orderTieinSaleService.findGoodsPrice.wrong");
				return response;
			}
			TblGoodsPaywayModel tblGoodsPaywayModel = response1.getResult();
			if (tblGoodsPaywayModel == null) {
				log.error("OrderService sendMsg error,orderTieinSaleService findGoodsPrice tblGoodsPaywayModel empty");
				response.setError("orderTieinSaleService.findGoodsPrice.wrong");
				return response;
			}
			BigDecimal goodsPrice = BigDecimal.ZERO.setScale(2);
			goodsPrice = tblGoodsPaywayModel.getGoodsPrice();
			if (goodsPrice == null) {
				log.error(
						"OrderService sendMsg error,orderTieinSaleService findGoodsPrice tblGoodsPaywayModel goodsPrice empty");
				response.setError("goodsPrice.be.null");
				return response;
			}
			// 手机号
			map.put("mobilephone", orderMainModel.getContMobPhone());
			// 商品名
			map.put("product", orderSubModel.getGoodsNm());
			// 价格
			map.put("account", goodsPrice.toString());
			// 总价
			map.put("reaccount", orderSubModel.getTotalMoney().toString());
			// 接口名
			map.put("tempLaId", "072FH00013");
			Response<Map> responseMsg = new Response<>();
			responseMsg = smsMessageService.sendMsg(map);
			if (responseMsg.isSuccess()) {
				log.info("OrderServiceImpl sendMsg successed," + responseMsg.getResult().get("msg"));
				response.setResult(Boolean.TRUE);
				return response;
			} else {
				response.setError("OrderServiceImpl.sendMsg.failed");
				return response;
			}
		} catch (IllegalArgumentException e) {
			log.error("OrderServiceImpl sendMsg.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl sendMsg.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.sendMsg.failed");
			return response;
		}
	}

	/**
	 * 获取主订单信息
	 *
	 * @param orderMainId
	 * @return
	 */
	public Response<OrderMainModel> findOrderMainById(String orderMainId) {
		Response<OrderMainModel> response = new Response<>();
		try {
			checkArgument(StringUtils.isNotBlank(orderMainId), "orderainId.can.not.be.empty");
			OrderMainModel orderMainModel = new OrderMainModel();
			orderMainModel = orderMainDao.findByOrderMainId(orderMainId);
			response.setResult(orderMainModel);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("OrderServiceImpl findOrderMainById.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl findOrderMainById.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.findOrderMainById.failed");
			return response;
		}
	}

	@Override
	public Response saveOrder(OrderMainModel orderMainModel,
								List<OrderSubModel> orderSubModelList,
							    List<OrderDoDetailModel> orderDoDetailModelList,
							    Map<String, Long> stockMap) {
		Response response = Response.newResponse();
		// 登入数据库
		try {
			orderMainManager.createJfOrder_new(orderMainModel, orderSubModelList, orderDoDetailModelList,
					null, stockMap, null, null);
			PagePaymentReqDto pagePaymentReqDto = getReturnObjForAppPay(orderMainModel, orderSubModelList).getResult();
			response.setResult(pagePaymentReqDto);
			response.setSuccess(true);
			return response;
		} catch (Exception e) {
			log.error("OrderService saveOrder error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setResult(e.getMessage());
			response.setSuccess(false);
			return response;
		}
	}
	/**
	 * App积分获取返回的报文
	 *
	 * @param orderMain
	 * @param orderSubModelList
	 *
	 * @author huangchaoyong on 2016-9-2
	 *
	 */
	public Response<PagePaymentReqDto> getReturnObjForAppPay(OrderMainModel orderMain,
									   List<OrderSubModel> orderSubModelList) {
		Response<PagePaymentReqDto> rs = new Response<>();
		log.info("into 积分 getReturnObjForPay");
		PagePaymentReqDto pagePaymentReqDto = new PagePaymentReqDto();
		String orderid = orderMain.getOrdermainId();// 大订单号
		String amount = orderMain.getTotalPrice() == null ? "0.0" : orderMain.getTotalPrice().setScale(1).toString();// 总金额
		String payType = "2";// 支付类型
		String pointType = orderSubModelList.get(0).getBonusType()==null?"":orderSubModelList.get(0).getBonusType().trim();// 积分类型
		String pointSum = orderMain.getTotalBonus().toString();// 总积分值
		String isMerge = orderMain.getIsmerge();// 是否合并支付
		String payAccountNo = orderMain.getCardno();// 支付账号
		String serialNo = orderMain.getSerialNo();// 交易流水号
		String tradeDate = DateHelper.date2string(orderMain.getCreateTime(), "yyyyMMdd");// 订单日期
		String tradeTime = DateHelper.date2string(orderMain.getCreateTime(), "HHmmss");// 订单时间
		/******* 优惠券需求添加end ******/
		pagePaymentReqDto.setSerialNo(serialNo);// 商城生成的流水号 为空
		pagePaymentReqDto.setTradeDate(tradeDate);// 交易日期 为空
		pagePaymentReqDto.setTradeTime(tradeTime);// 交易时间 为空
		pagePaymentReqDto.setOrderid(orderid);// 大订单号
		pagePaymentReqDto.setAmount(amount);// 总金额
		pagePaymentReqDto.setMerchId(merchId);// 大商户号
		pagePaymentReqDto.setPointType(pointType);// 积分类型 为空
		pagePaymentReqDto.setPointSum(pointSum);// 总积分值 为空
		pagePaymentReqDto.setIsMerge(isMerge);// 是否合并支付 为空
		pagePaymentReqDto.setPayType(payType);// 支付类型
		String orders = orderid + "|" + merchId + "|" + amount + "|" + pointSum;
		pagePaymentReqDto.setOrders(orders);// 订单信息串
		String singGene = Joiner.on("|").join(merchId, nullToEmpty(orderid), amount, pointType.trim(), pointSum,
				isMerge, payType, nullToEmpty(orders), nullToEmpty(serialNo), tradeDate, nullToEmpty(tradeTime)).trim();
		log.info("订单信息串singGene:" + singGene);
		// 改用旧系统加密方式
		String sign = "";
		try {
			sign = SignAndVerify.sign_md(singGene, mainPrivateKey);
		} catch (Exception e) {
			rs.setError("加密处理异常");
			rs.setSuccess(false);
		}// 签名
		pagePaymentReqDto.setSign(sign);// 签名
		log.debug("************电子支付报文信息************" + "returnCode: " + pagePaymentReqDto.getReturnCode() + "errorMsg: "
				+ pagePaymentReqDto.getErrorMsg() + "payAddress: " + pagePaymentReqDto.getPayAddress() + "orderid: "
				+ pagePaymentReqDto.getOrderid() + "amount: " + pagePaymentReqDto.getAmount() + "merchId: "
				+ pagePaymentReqDto.getMerchId() + "sign: " + pagePaymentReqDto.getSign() + "pointType: "
				+ pagePaymentReqDto.getPointType() + "pointSum: " + pagePaymentReqDto.getPointSum() + "isMerge: "
				+ pagePaymentReqDto.getIsMerge() + "payType: " + pagePaymentReqDto.getPayType() + "orders: "
				+ pagePaymentReqDto.getOrders() + "serialNo: " + pagePaymentReqDto.getSerialNo() + "tradeDate: "
				+ pagePaymentReqDto.getTradeDate() + "tradeTime: " + pagePaymentReqDto.getTradeTime());
		rs.setResult(pagePaymentReqDto);
		return rs;
	}
	/**
	 * 提交订单(314接口使用下单订单)
	 *
	 * @param orderCommitSubmitDto 提交订单信息
	 * @return 新建订单结果
	 */
	public Response<Map<String, PagePaymentReqDto>> createOrder314(OrderCommitSubmit314Dto orderCommitSubmitDto,
			User user) {
		Response<Map<String, PagePaymentReqDto>> response = new Response<>();
		Map<String, PagePaymentReqDto> responseMap = Maps.newHashMap();
		try {
			Map<String, Object> infosMap = Maps.newHashMap();
			// 校验下单信息
			PagePaymentReqDto pagePaymentReqDto = checkCreateOrderArgumentAndGetInfos314(orderCommitSubmitDto, user,
					infosMap);
			if (pagePaymentReqDto != null && !StringUtils.isEmpty(pagePaymentReqDto.getReturnCode())) {
				responseMap.put("result", pagePaymentReqDto);
				response.setResult(responseMap);
				return response;
			}
			// 生成大订单和小订单
			OrderMainModel orderMainModel = new OrderMainModel();
			// 生成大订单
			pagePaymentReqDto = createOrderMain314(infosMap, orderCommitSubmitDto, user, orderMainModel);
			if (pagePaymentReqDto != null && !StringUtils.isEmpty(pagePaymentReqDto.getReturnCode())) {
				responseMap.put("result", pagePaymentReqDto);
				response.setResult(responseMap);
				return response;
			}

			// 生成小订单和订单处理历史明细表
			List<OrderSubModel> orderSubModelList = Lists.newArrayList();
			List<OrderDoDetailModel> orderDoDetailModelList = Lists.newArrayList();
			pagePaymentReqDto = createOrderSubDoDetail314(infosMap, user, orderCommitSubmitDto.getPayType(),
					orderMainModel, orderSubModelList, orderDoDetailModelList);
			if (pagePaymentReqDto != null && !StringUtils.isEmpty(pagePaymentReqDto.getReturnCode())) {
				responseMap.put("result", pagePaymentReqDto);
				response.setResult(responseMap);
				return response;
			}
			List<ItemModel> itemModels = (List<ItemModel>) infosMap.get("itemModels");
			List<Map<String, String>> promItemMap = (List<Map<String, String>>) infosMap.get("promItemMap");
			PointPoolModel pointPoolModel = (PointPoolModel) infosMap.get("pointPoolModel");
			// 登入数据库
			orderMainManager.createOrder(orderMainModel, orderSubModelList, orderDoDetailModelList, itemModels,
					pointPoolModel, promItemMap, user);
			// 未设默认地址的场合，把此次收货地址设为默认地址
			if (orderCommitSubmitDto.getAddressId() != null) {
				memberAddressService.setDefaultNotExists(orderCommitSubmitDto.getAddressId(), user.getCustId());
			}
			// 从购物车跳转过来的订单，订单生成成功后删除购物车中对应记录
			List<String> cartIdList = new ArrayList<String>();
			for (OrderCommitInfo314Dto orderCommitInfoDto : orderCommitSubmitDto.getOrderCommitInfo314List()) {
				cartIdList.add(orderCommitInfoDto.getCartId());
			}
			espCustCartManager.deleteByIds(cartIdList);
			pagePaymentReqDto = new PagePaymentReqDto();
			// 准备支付用数据
			// orderMainService.getReturnObjForPay( pagePaymentReqDto, orderMainModel, orderSubModelList);
			getReturnObjForPay(pagePaymentReqDto, orderMainModel, orderSubModelList);
			responseMap.put("result", pagePaymentReqDto);
			response.setResult(responseMap);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("OrderService createOrder error,error code: {}", Throwables.getStackTraceAsString(e));
			e.printStackTrace();
			PagePaymentReqDto pagePaymentReqDto = new PagePaymentReqDto();
			pagePaymentReqDto.setReturnCode("000009");
			pagePaymentReqDto.setErrorMsg("系统异常");
			// 准备支付用数据
			responseMap.put("result", pagePaymentReqDto);
			response.setResult(responseMap);
			return response;
		} catch (Exception e) {
			log.error("OrderService createOrder error,cause:{}", Throwables.getStackTraceAsString(e));
			e.printStackTrace();
			PagePaymentReqDto pagePaymentReqDto = new PagePaymentReqDto();
			pagePaymentReqDto.setReturnCode("000009");
			pagePaymentReqDto.setErrorMsg("系统异常");
			// 准备支付用数据
			responseMap.put("result", pagePaymentReqDto);
			response.setResult(responseMap);
			return response;
		}
	}

	/**
	 * 判断参数库存支付方式等是否正确并取得商品供应商等信息（314接口使用）
	 *
	 * @param orderCommitSubmitDto
	 * @param user
	 * @param infosMap
	 * @return
	 */
	private PagePaymentReqDto checkCreateOrderArgumentAndGetInfos314(OrderCommitSubmit314Dto orderCommitSubmitDto,
			User user, Map<String, Object> infosMap) {
		PagePaymentReqDto pagePaymentReqDto = new PagePaymentReqDto();
		// 选择的支付卡卡号
		String cardNo = orderCommitSubmitDto.getCardNo();
		// checkArgument(!cardNo.isEmpty(), "卡号不能为空");
		// 1:借记卡２：信用卡
		String payType = orderCommitSubmitDto.getPayType();
		// add checkreturn
		if (payType.isEmpty()) {
			pagePaymentReqDto.setReturnCode("000016");
			pagePaymentReqDto.setErrorMsg("支付方式不能为空");
			return pagePaymentReqDto;
		}
		// add end
		checkArgument(!payType.isEmpty(), "支付方式不能为空");

		List<OrderCommitInfo314Dto> orderCommitInfoDtoList = orderCommitSubmitDto.getOrderCommitInfo314List();
		List<String> itemCodes = Lists.newArrayList();
		Integer totalNum = 0;
		Long jfTotalNum = 0L;
		Long jfTotalNumNoFix = 0L;
		BigDecimal totalPrice = new BigDecimal("0");
		BigDecimal voucherPriceTotal = new BigDecimal(0);
		BigDecimal deduction = new BigDecimal(0);
		List<Map<String, OrderCommitInfo314Dto>> itemInfoMapList = new ArrayList<Map<String, OrderCommitInfo314Dto>>();
		MallPromotionResultDto mallPromotionResultDto = new MallPromotionResultDto();
		BigDecimal goodsPrice = new BigDecimal(0);
		TblGoodsPaywayModel goodsPaywayModel = new TblGoodsPaywayModel();
		Response<ItemModel> itemModelResponse = new Response<ItemModel>();
		for (OrderCommitInfo314Dto orderCommitInfoDto : orderCommitInfoDtoList) {
			if (orderCommitInfoDto.getJfCount() == null) {
				orderCommitInfoDto.setJfCount(0l);
			}
			if (orderCommitInfoDto.getAfterDiscountJf() == null) {
				orderCommitInfoDto.setAfterDiscountJf(0l);
			}
			if (orderCommitInfoDto.getSinglePrice() == null) {
				orderCommitInfoDto.setSinglePrice(0l);
			}
			// 单品编码
			// add checkreturn
			if (orderCommitInfoDto.getCode().isEmpty()) {
				pagePaymentReqDto.setReturnCode("000031");
				pagePaymentReqDto.setErrorMsg("没找到商品");
				return pagePaymentReqDto;
			}
			// add end
			checkArgument(!orderCommitInfoDto.getCode().isEmpty(), "没找到商品");
			itemCodes.add(orderCommitInfoDto.getCode());
			// 商品价格校验
			if (orderCommitInfoDto.getPromotion() != null) {
				mallPromotionResultDto = orderCommitInfoDto.getPromotion();
				goodsPrice = mallPromotionResultDto.getPromItemResultList().get(0).getPrice();
			} else {
				Response<TblGoodsPaywayModel> goodsPaywayModelResponse = goodsPayWayService.findGoodsPayWayInfo(orderCommitInfoDto.getPayWayId());
				if(!goodsPaywayModelResponse.isSuccess()){
					log.error("Response.error,error code: {}", goodsPaywayModelResponse.getError());
					throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
				}
				goodsPaywayModel = goodsPaywayModelResponse.getResult();
				goodsPrice = goodsPaywayModel.getGoodsPrice();
			}
			totalPrice = totalPrice.add(goodsPrice.multiply(new BigDecimal(orderCommitInfoDto.getItemCount())));
			//checkArgument(goodsPrice.compareTo(orderCommitInfoDto.getPrice()) == 0, "购买商品的价格发生变化"); //undo 接口没有传orderCommitInfoDto.getPrice()值
			if (!orderCommitInfoDto.isFixFlag() == true) {
				itemModelResponse = itemService.findByItemcode(orderCommitInfoDto.getCode());
				if(!itemModelResponse.isSuccess()){
					log.error("Response.error,error code: {}", itemModelResponse.getError());
					throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
				}
//				if (itemModelResponse != null && itemModelResponse.getResult() != null) {
//					// 最大积分校验
//					if (itemModelResponse.getResult().getMaxPoint() != null) {
//						// add checkreturn
//						if (!(itemModelResponse.getResult().getMaxPoint()
//								- orderCommitInfoDto.getJfCount() / orderCommitInfoDto.getItemCount() >= 0)) {
//							pagePaymentReqDto.setReturnCode("000070");
//							pagePaymentReqDto.setErrorMsg("所用积分不能大于商品最大抵扣积分");
//							return pagePaymentReqDto;
//						}
//						// add end
//						checkArgument(
//								itemModelResponse.getResult().getMaxPoint()
//										- orderCommitInfoDto.getJfCount() / orderCommitInfoDto.getItemCount() >= 0,
//								"所用积分不能大于商品最大抵扣积分");
//					}
//				}
				// undo 接口只传了orderCommitInfoDto.getJfCount()的值
				// if (orderCommitInfoDto.getJfCount() != 0l) {
				// // 验积分折扣校
				// checkArgument(new BigDecimal(orderCommitInfoDto.getAfterDiscountJf())
				// .divide(new BigDecimal(orderCommitInfoDto.getJfCount())).compareTo(
				// goodsDetailService.findCardScaleByUserId(user).getResult().get(0).getScal()) == 0,
				// "积分折扣发生变化");
				// }
			}
			// 购买数量
			Integer num = orderCommitInfoDto.getItemCount();
			totalNum = totalNum + num;
			// 不明白
			Long afterDiscountJf = orderCommitInfoDto.getAfterDiscountJf() == null ? 0L
					: Long.parseLong(orderCommitInfoDto.getAfterDiscountJf().toString());
			jfTotalNum = jfTotalNum + afterDiscountJf;
			if (!orderCommitInfoDto.isFixFlag()) {
				jfTotalNumNoFix = jfTotalNumNoFix + afterDiscountJf;
			}
			checkArgument(num > 0, "购买数量不能小于1");
			Map<String, OrderCommitInfo314Dto> itemInfoMap = new HashMap<String, OrderCommitInfo314Dto>();
			itemInfoMap.put(orderCommitInfoDto.getCode(), orderCommitInfoDto);
			itemInfoMapList.add(itemInfoMap);

			if (orderCommitInfoDto.isFixFlag() != true && orderCommitInfoDto.getJfCount() != 0l) {
				// do 接口已经传过来积分抵扣钱数 所有改为如下
				deduction = deduction.add(new BigDecimal(orderCommitInfoDto.getDiscountPrivMon()));
				// deduction = deduction.add(new BigDecimal(orderCommitInfoDto.getJfCount())
				// .divide(new BigDecimal(orderCommitInfoDto.getSinglePrice()), 2, BigDecimal.ROUND_HALF_UP));
			}
			// 优惠券总额
			voucherPriceTotal = voucherPriceTotal.add(orderCommitInfoDto.getVoucherPrice());
			if (orderCommitInfoDto.getPromotion() != null && orderCommitInfoDto.getPromotion().getId() != null) {

				// 活动时间有效性校验
				// add checkreturn
				Response<Boolean> findPromValidByPromIdResponse = mallPromotionService.findPromValidByPromId(orderCommitInfoDto.getPromotion().getId().toString(),
						orderCommitInfoDto.getPromotion().getPeriodId());
				if(!findPromValidByPromIdResponse.isSuccess()){
					log.error("Response.error,error code: {}", findPromValidByPromIdResponse.getError());
					throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
				}
				if (!(findPromValidByPromIdResponse.getResult())) {
					pagePaymentReqDto.setReturnCode("000037");
					pagePaymentReqDto.setErrorMsg("未在活动时间范围内或活动已结束");
					return pagePaymentReqDto;
				}
				// add end
				checkArgument(findPromValidByPromIdResponse.getResult(), "未在活动时间范围内或活动已结束");

				// 活动购买数量校验
				// add checkreturn
				Response<Boolean> checkPromBuyCountResponse = mallPromotionService.checkPromBuyCount(orderCommitInfoDto.getPromotion().getId().toString(),
						orderCommitInfoDto.getPromotion().getPeriodId(),
						orderCommitInfoDto.getItemCount().toString(), user, orderCommitInfoDto.getCode());
				if(!checkPromBuyCountResponse.isSuccess()){
					log.error("Response.error,error code: {}", checkPromBuyCountResponse.getError());
					throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
				}
				if (!(checkPromBuyCountResponse.getResult())) {
					pagePaymentReqDto.setReturnCode("000038");
					pagePaymentReqDto.setErrorMsg("您所购买的活动商品数量已达到上限，无法继续参加活动");
					return pagePaymentReqDto;
				}
				// add end
				checkArgument(checkPromBuyCountResponse.getResult(), "您所购买的活动商品数量已达到上限，无法继续参加活动");

				// 活动商品数量校验
				// add checkreturn
				Response<Boolean> checkPromItemStockResponse = mallPromotionService.checkPromItemStock(orderCommitInfoDto.getPromotion().getId().toString(),
						orderCommitInfoDto.getPromotion().getPeriodId(), orderCommitInfoDto.getCode(),
						orderCommitInfoDto.getItemCount().toString());
				if(!checkPromItemStockResponse.isSuccess()){
					log.error("Response.error,error code: {}", checkPromItemStockResponse.getError());
					throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
				}
				if (!(checkPromItemStockResponse.getResult())) {
					pagePaymentReqDto.setReturnCode("000038");
					pagePaymentReqDto.setErrorMsg("您所选中的活动商品库存数量不足，无法继续参加活动");
					return pagePaymentReqDto;
				}
				// add end
				checkArgument(checkPromItemStockResponse.getResult(), "您所选中的活动商品库存数量不足，无法继续参加活动");
			}
		}
		Response<List<ItemModel>> itemModelResult = itemService.findByCodes(itemCodes);
		if(!itemModelResult.isSuccess()){
			log.error("Response.error,error code: {}", itemModelResult.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
		}
		List<ItemModel> itemModels = itemModelResult.getResult();
		// 判断活动单品库存数
		Long promItemCount = 0L;
		List<String> goodsCodes = Lists.newArrayList();
		List<String> itemCodeList = new ArrayList<String>();
		// 活动商品集合
		List<Map<String, String>> promItemMapList = new ArrayList<Map<String, String>>();
		for (ItemModel itemModel : itemModels) {
			itemCodeList.add(itemModel.getCode());
			goodsCodes.add(itemModel.getGoodsCode());
			// 判断单品库存数
			Long itemCount = 0L;
			OrderCommitInfoDto dto = new OrderCommitInfoDto();
			for (Map<String, OrderCommitInfo314Dto> map : itemInfoMapList) {
				if (map.get(itemModel.getCode()) != null) {
					if (map.get(itemModel.getCode()).getPromotion() != null
							&& map.get(itemModel.getCode()).getPromotion().getId() == null) {
						itemCount = itemCount + map.get(itemModel.getCode()).getItemCount();
					} else {
						promItemCount = promItemCount + map.get(itemModel.getCode()).getItemCount();
						dto = map.get(itemModel.getCode());
					}
				}
			}
			if (dto.getPromotion() != null && dto.getPromotion().getId() != null) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("promId", dto.getPromotion().getId().toString());
				map.put("periodId", dto.getPromotion().getPeriodId().toString());
				map.put("itemCode", itemModel.getCode());
				map.put("itemCount", promItemCount.toString());
				promItemMapList.add(map);
			}
			// add checkreturn
			if (!(itemModel.getStock() >= itemCount)) {
				pagePaymentReqDto.setReturnCode("000038");
				pagePaymentReqDto.setErrorMsg("库存不够");
				return pagePaymentReqDto;
			}
			// add end
			checkArgument(itemModel.getStock() >= itemCount, "库存不够");
			itemModel.setStock(itemModel.getStock() - itemCount);
			itemModel.setModifyOper(user.getId());
		}
		boolean changed = true;
		for (OrderCommitInfoDto dto : orderCommitInfoDtoList) {
			if (!itemCodeList.contains(dto.getCode())) {
				changed = false;
			}
		}
		// add checkreturn
		if (!(changed)) {
			pagePaymentReqDto.setReturnCode("000038");
			pagePaymentReqDto.setErrorMsg("购买的商品发生了变化，请重新购买");
			return pagePaymentReqDto;
		}
		// add end
		checkArgument(changed, "购买的商品发生了变化，请重新购买");
		Response<List<GoodsModel>> goodsModels = goodsService.findByCodes(goodsCodes);
		if(!goodsModels.isSuccess()){
			log.error("Response.error,error code: {}", goodsModels.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
		}
		// add checkreturn
		if (!(goodsModels.getResult().size() > 0)) {
			pagePaymentReqDto.setReturnCode("000038");
			pagePaymentReqDto.setErrorMsg("购买的商品发生了变化，请重新购买");
			return pagePaymentReqDto;
		}
		// add end
		checkArgument(goodsModels.getResult().size() > 0, "购买的商品发生了变化，请重新购买");
		Map<String, GoodsModel> goodsInfoMap = Maps.newHashMap();
		List<String> vendorCodes = Lists.newArrayList();
		String goodsType = ""; // 商品类型
		// 判断商品是否在售
		for (GoodsModel goodsModel : goodsModels.getResult()) {
			// 商城的场合
			// checkArgument(Contants.CHANNEL_MALL_02.equals(goodsModel.getChannelMall()), "购买的商品已经下架");
			// 不同渠道状态不同 前面完成了
			goodsInfoMap.put(goodsModel.getCode(), goodsModel);
			vendorCodes.add(goodsModel.getVendorId());
			if (Contants.SUB_ORDER_TYPE_00.equals(goodsModel.getGoodsType())) {
				goodsType = goodsModel.getGoodsType();
			}
			// 实物，O2O商品结算数量最大为99件
			if (Contants.SUB_ORDER_TYPE_00.equals(goodsModel.getGoodsType())
					|| Contants.SUB_ORDER_TYPE_02.equals(goodsModel.getGoodsType())) {
				// add checkreturn
				if (!(totalNum <= 99)) {
					pagePaymentReqDto.setReturnCode("000047");
					pagePaymentReqDto.setErrorMsg("购买总数量不能于大99");
					return pagePaymentReqDto;
				}
				// add end
				checkArgument(totalNum <= 99, "购买总数量不能于大99");
			}
		}
		log.info("jfTotalNum：商品的积分总数为：" + jfTotalNum);
		PointPoolModel pointPoolModel = null;
		if (jfTotalNum != 0) {
			Response<Map<String,BigDecimal>> userAccountResponse = cartService.getUserScore(user);
			if(!userAccountResponse.isSuccess()){
				log.error("Response.error,error code: {}", userAccountResponse.getError());
				throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
			}
//			// add checkreturn
//			if (!userAccountResponse.isSuccess()) {
//				pagePaymentReqDto.setReturnCode("000047");
//				pagePaymentReqDto.setErrorMsg("查询不到客户积分");
//				return pagePaymentReqDto;
//			}
//			// add end
			checkArgument(userAccountResponse.isSuccess(), "查询不到客户积分");
			BigDecimal bunusum = userAccountResponse.getResult().get(Contants.JGID_COMMON);
			// add checkreturn
			if (!(bunusum != null)) {
				pagePaymentReqDto.setReturnCode("000047");
				pagePaymentReqDto.setErrorMsg("您当前的剩余积分不足");
				return pagePaymentReqDto;
			}
			// add end
			checkArgument(bunusum != null, "您当前的剩余积分不足");
			// add checkreturn
			if (!(bunusum.compareTo(new BigDecimal(jfTotalNum)) >= 0)) {
				pagePaymentReqDto.setReturnCode("000047");
				pagePaymentReqDto.setErrorMsg("您当前的剩余积分不足");
				return pagePaymentReqDto;
			}
			// add end
			checkArgument(bunusum.compareTo(new BigDecimal(jfTotalNum)) >= 0, "您当前的剩余积分不足");
			// 固定积分不占用积分池
			Response<PointPoolModel> pointResult = pointsPoolService.getCurMonthInfo();
			// add checkreturn
			if (!(pointResult.isSuccess() && pointResult.getResult() != null)) {
				pagePaymentReqDto.setReturnCode("000047");
				pagePaymentReqDto.setErrorMsg("取得积分池失败");
				return pagePaymentReqDto;
			}
			// add end
			checkArgument(pointResult.isSuccess() && pointResult.getResult() != null, "取得积分池失败");
			pointPoolModel = pointResult.getResult();
			Long maxPoint = pointPoolModel.getMaxPoint();
			Long usedPoint = pointPoolModel.getUsedPoint();
			// add checkreturn
			if (!(jfTotalNumNoFix <= maxPoint - usedPoint)) {
				pagePaymentReqDto.setReturnCode("000047");
				pagePaymentReqDto.setErrorMsg("本月广发商城积分抵现活动已结束，下月1日起可继续参与。");
				return pagePaymentReqDto;
			}
			// add end
			checkArgument(jfTotalNumNoFix <= maxPoint - usedPoint, "本月广发商城积分抵现活动已结束，下月1日起可继续参与。");
			pointPoolModel.setUsedPoint(usedPoint + jfTotalNumNoFix);
			pointPoolModel.setModifyOper(user.getId());
		}
		// 取得供应商简称
		Response<List<VendorInfoModel>> vendorInfoModelList = vendorService.findByVendorIds(vendorCodes);
		if(!vendorInfoModelList.isSuccess()){
			log.error("Response.error,error code: {}", vendorInfoModelList.getError());
			throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
		}
		Map<String, VendorInfoModel> vendorInfo = Maps.newHashMap();
		for (VendorInfoModel vendorInfoModel : vendorInfoModelList.getResult()) {
			vendorInfo.put(vendorInfoModel.getVendorId(), vendorInfoModel);
		}
		infosMap.put("totalNum", totalNum);
		infosMap.put("totalPrice", totalPrice);
		infosMap.put("voucherPriceTotal", voucherPriceTotal);
		infosMap.put("deduction", deduction);
		infosMap.put("jfTotalNum", jfTotalNum);
		infosMap.put("goodsType", goodsType);
		infosMap.put("itemModels", itemModels);
		infosMap.put("promItemMap", promItemMapList);
		infosMap.put("itemInfoMapList", itemInfoMapList);
		infosMap.put("goodsInfo", goodsInfoMap);
		infosMap.put("vendorInfo", vendorInfo);
		infosMap.put("pointPoolModel", pointPoolModel);
		return pagePaymentReqDto;
	}

	/**
	 * 生成主订单表（314接口使用）
	 *
	 * @param infosMap
	 * @param orderCommitSubmitDto
	 * @param user
	 * @param orderMainModel
	 * @return
	 */
	private PagePaymentReqDto createOrderMain314(Map<String, Object> infosMap,
			OrderCommitSubmit314Dto orderCommitSubmitDto, User user, OrderMainModel orderMainModel) {
		PagePaymentReqDto pagePaymentReqDto = new PagePaymentReqDto();
		// 单品总数量
		Integer totalNum = (Integer) infosMap.get("totalNum");
		Date nowDate = new Date();
		// 积分总数
		Long jfTotalNum = (Long) infosMap.get("jfTotalNum");
		// 总金额
		BigDecimal totalPrice = (BigDecimal) infosMap.get("totalPrice");
		// 总积分抵扣金额
		BigDecimal deduction = (BigDecimal) infosMap.get("deduction");
		// 总优惠券金额
		BigDecimal voucherPriceTotal = (BigDecimal) infosMap.get("voucherPriceTotal");
		// 商品类型实物o2o
		String goodsType = (String) infosMap.get("goodsType");
		// 根据支付方式判断
		if (Contants.CART_PAY_TYPE_1.equals(orderCommitSubmitDto.getPayType())) {
			orderMainModel.setOrdertypeId(Contants.BUSINESS_TYPE_YG);// 业务类型idyg:广发商城(一期)jf:积分商城fq:广发商城(分期)
			orderMainModel.setOrdertypeNm(Contants.BUSINESS_TYPE_NM_YG);// 业务类型idyg:广发商城(一期)jf:积分商城fq:广发商城(分期)
			orderMainModel.setIsmerge("1");// 是否合并支付0是1否
		}
		if (Contants.CART_PAY_TYPE_2.equals(orderCommitSubmitDto.getPayType())) {
			orderMainModel.setOrdertypeId(Contants.BUSINESS_TYPE_FQ);// 业务类型idyg:广发商城(一期)jf:积分商城fq:广发商城(分期)
			orderMainModel.setOrdertypeNm(Contants.BUSINESS_TYPE_NM_FQ);// 业务类型idyg:广发商城(一期)jf:积分商城fq:广发商城(分期)
			orderMainModel.setIsmerge("0");// 是否合并支付0是1否
		}
		orderMainModel.setCardno(orderCommitSubmitDto.getCardNo());// 卡号
		// change
		orderMainModel.setSourceId(orderCommitSubmitDto.getOrigin());// todo ok 订单来源渠道id00: 商城01: callcenter02: ivr渠道03:
																		// 手机商城
		orderMainModel.setSourceNm(orderCommitSubmitDto.getOriginNm());// todo ok 订单来源渠道id00: 商城01: callcenter02:
																		// ivr渠道03: 手机商城
		// change end
		orderMainModel.setTotalNum(totalNum);// 商品总数量
		orderMainModel.setTotalPrice(totalPrice.subtract(voucherPriceTotal).subtract(deduction));// 现金总金额
		orderMainModel.setBonusDiscount(deduction);// 积分抵扣金额
		orderMainModel.setVoucherDiscount(voucherPriceTotal);// 优惠券金额
		orderMainModel.setTotalBonus(jfTotalNum);// 商品总积分数量
		orderMainModel.setLockedFlag("0");// 订单锁标记（锁住订单，订单成功后解锁，解锁才能退货）
		if (orderMainModel.getTotalPrice().compareTo(new BigDecimal(0)) > 0) {
			orderMainModel.setIsInvoice(orderCommitSubmitDto.getIsInvoice());// 是否开发票0-否，1-是
			orderMainModel.setInvoice(orderCommitSubmitDto.getInvoice());// 发票抬头
		} else {// add 20160922 零元秒杀默认不开发票
			orderMainModel.setIsInvoice("0");// 是否开发票0-否，1-是
			orderMainModel.setInvoice("");// 发票抬头
		}
		orderMainModel.setOrdermainDesc(orderCommitSubmitDto.getOrdermainDesc());// 订单主表备注
		orderMainModel.setContIdType(orderCommitSubmitDto.getContIdType());// change 订货人证件类型
		orderMainModel.setContIdcard(orderCommitSubmitDto.getContIdcard());// change 订货人证件号码
		orderMainModel.setContNm(orderCommitSubmitDto.getContNm());// change 订货人姓名
		orderMainModel.setContPostcode(orderCommitSubmitDto.getContPostcode());// change 订货人邮政编码
		orderMainModel.setContAddress(orderCommitSubmitDto.getContAddress());// change 订货人详细地址
		orderMainModel.setContMobPhone(orderCommitSubmitDto.getContMobPhone());// change 订货人手机
		orderMainModel.setContHphone(orderCommitSubmitDto.getContHphone());// change 订货人家里电话
		orderMainModel.setMerId(merchId);// 大商户号
		orderMainModel.setCommDate(DateHelper.getyyyyMMdd());// 业务日期
		orderMainModel.setCommTime(DateHelper.getHHmmss());// 业务时间
		orderMainModel.setCustSex(orderCommitSubmitDto.getCustSex());// change性别
		orderMainModel.setCustEmail(orderCommitSubmitDto.getCustEmail()); // change
		orderMainModel.setEUpdateStatus("0");// 插入订单状态更新接口标志位 0:初始化 1：更新成功 2：更新失败
		// 有收货地址的场合（实物，实物＋Ｏ２Ｏ）
		if (Contants.SUB_ORDER_TYPE_00.equals(goodsType)) {

			orderMainModel.setBpCustGrp(orderCommitSubmitDto.getBpCustGrp());// 送货时间01:
			// 工作日、双休日与假日均可送货02:只有工作日送货（双休日、假日不用送）03:只有双休日、假日送货（工作日不用送货）
			// undo 接收人地址信息由接口提供
			// checkArgument(orderCommitSubmitDto.getAddressId() != null, "请选择送货地址");
			// Response<MemberAddressModel> memberAddressResult = memberAddressService
			// .findById(orderCommitSubmitDto.getAddressId());
			// checkArgument(memberAddressResult.isSuccess(), "收货地址发生变化请重新选择");
			// MemberAddressModel memberAddressModel = memberAddressResult.getResult();
			orderMainModel.setCsgName(orderCommitSubmitDto.getCsgName());// 收货人姓名
			orderMainModel.setCsgPostcode(orderCommitSubmitDto.getCsgPostcode());// 收货人邮政编码
			orderMainModel.setCsgAddress(orderCommitSubmitDto.getCsgAddress());// 收货人详细地址
			orderMainModel.setCsgPhone1(orderCommitSubmitDto.getCsgPhone1());// 收货人电话一
			orderMainModel.setCsgPhone2(orderCommitSubmitDto.getCsgPhone2());// 收货人电话二
			orderMainModel.setCsgProvince(orderCommitSubmitDto.getCsgProvince());// 省
			orderMainModel.setCsgCity(orderCommitSubmitDto.getCsgCity());// 市
			orderMainModel.setCsgBorough(orderCommitSubmitDto.getCsgBorough());// 区
			orderMainModel.setAcctAddFlag("1");// 收货地址是否是帐单地址0-否1-是
		} else {
			if (Contants.SUB_ORDER_TYPE_02.equals(goodsType)) {
				orderMainModel.setCsgName(orderCommitSubmitDto.getContNm());// 客户姓名
				orderMainModel.setCsgPhone1(orderCommitSubmitDto.getContMobPhone());// 收码电话
			}
		}
		orderMainModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0301);// 当前状态代码0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
		orderMainModel.setCurStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);// 当前状态代码0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
		orderMainModel.setCreateOper(orderCommitSubmitDto.getCreateOper());// 创建操作员id
		orderMainModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);// 逻辑删除标记为(0未删除，1已删除)
		orderMainModel.setCreateTime(nowDate);
		orderMainModel.setModifyTime(nowDate);
		// 数据库不为空项
		orderMainModel.setPermLimit(new BigDecimal(0));
		orderMainModel.setCashLimit(new BigDecimal(0));
		orderMainModel.setStagesLimit(new BigDecimal(0));
		return pagePaymentReqDto;
	}

	/**
	 * 生成订单表和订单处理历史明细表（314接口使用）
	 *
	 * @param infosMap
	 * @param user
	 * @param orderMainModel
	 * @param orderSubModelList
	 * @param orderDoDetailModelList @return
	 */
	private PagePaymentReqDto createOrderSubDoDetail314(Map<String, Object> infosMap, User user, String payType,
			OrderMainModel orderMainModel, List<OrderSubModel> orderSubModelList,
			List<OrderDoDetailModel> orderDoDetailModelList) {
		PagePaymentReqDto pagePaymentReqDto = new PagePaymentReqDto();
		// 单品信息
		List<ItemModel> itemModels = (List<ItemModel>) infosMap.get("itemModels");
		// 提交订单中信息
		List<Map<String, OrderCommitInfo314Dto>> itemInfoMapList = (List<Map<String, OrderCommitInfo314Dto>>) infosMap
				.get("itemInfoMapList");
		// 商品信息
		Map<String, GoodsModel> goodsInfoMap = (Map<String, GoodsModel>) infosMap.get("goodsInfo");
		// 供应商信息
		Map<String, VendorInfoModel> vendorInfoMap = (Map<String, VendorInfoModel>) infosMap.get("vendorInfo");
		if (!Contants.BUSINESS_TYPE_JF.equals(orderMainModel.getOrdertypeId())) {
			OrderCommitInfo314Dto orderCommitInfoDto = new OrderCommitInfo314Dto();
			for (ItemModel itemModel : itemModels) {
				for (Map<String, OrderCommitInfo314Dto> map : itemInfoMapList) {
					orderCommitInfoDto = map.get(itemModel.getCode());
					if (orderCommitInfoDto != null) {
						for (int index = 0; index < orderCommitInfoDto.getItemCount(); index++) {
							OrderSubModel orderSubModel = new OrderSubModel();
							orderSubModel.setOperSeq(new Integer(0));
							orderSubModel.setOrdertypeId(orderMainModel.getOrdertypeId());// 业务类型代码YG:广发商城(一期)JF:积分商城FQ:广发商城(分期)
							orderSubModel.setOrdertypeNm(orderMainModel.getOrdertypeNm());// 业务类型名称

							Response<TblGoodsPaywayModel> tblGoodsPaywayResult = goodsPayWayService
									.findGoodsPayWayInfo(orderCommitInfoDto.getPayWayId());
							// add checkreturn
							if (!(tblGoodsPaywayResult.isSuccess())) {
								pagePaymentReqDto.setReturnCode("000016");
								pagePaymentReqDto.setErrorMsg("商品支付方式发生变化请重新提交");
								return pagePaymentReqDto;
							}
							// add end
							checkArgument(tblGoodsPaywayResult.isSuccess(), "商品支付方式发生变化请重新提交");
							TblGoodsPaywayModel tblGoodsPaywayModel = tblGoodsPaywayResult.getResult();
							orderSubModel.setGoodsPaywayId(tblGoodsPaywayModel.getGoodsPaywayId());// 商品支付编码
							orderSubModel.setSpecShopno(tblGoodsPaywayModel.getCategoryNo());// 邮购分期类别码
							orderSubModel.setCalMoney(tblGoodsPaywayModel.getCalMoney());// 清算总金额
							orderSubModel.setPaywayCode(tblGoodsPaywayModel.getPaywayCode());// 支付方式代码0001: 现金0002:
							// 积分0003:
							// 积分+现金0004:手续费0005:
							// 现金+手续费0006:
							// 积分+手续费0007:积分+现金+手续费
							Integer stagesNum = tblGoodsPaywayModel.getStagesCode() == null ? 1
									: tblGoodsPaywayModel.getStagesCode(); // change 不在接口在数据库里取得分期数在
							String PaywayName = "";
							if (tblGoodsPaywayModel.getPaywayCode().equals("0001")) {
								PaywayName = "现金";
							} else if (tblGoodsPaywayModel.getPaywayCode().equals("0002")) {
								PaywayName = "积分";
							} else if (tblGoodsPaywayModel.getPaywayCode().equals("0003")) {
								PaywayName = "积分+现金";
							} else if (tblGoodsPaywayModel.getPaywayCode().equals("0004")) {
								PaywayName = " 手续费";
							} else if (tblGoodsPaywayModel.getPaywayCode().equals("0005")) {
								PaywayName = "现金+手续费";
							} else if (tblGoodsPaywayModel.getPaywayCode().equals("0006")) {
								PaywayName = "积分+手续费";
							} else if (tblGoodsPaywayModel.getPaywayCode().equals("0007")) {
								PaywayName = "积分+现金+手续费";
							}
							orderSubModel.setPaywayNm(PaywayName);
							// 商品代码
							orderSubModel.setCardno(orderMainModel.getCardno());// 卡号
							GoodsModel goodsModel = goodsInfoMap.get(itemModel.getGoodsCode());
							String vendorId = goodsModel.getVendorId();
							orderSubModel.setVendorId(vendorId);// 供应商代码
							orderSubModel.setVendorSnm(vendorInfoMap.get(vendorId).getSimpleName());// 供应商简称
							orderSubModel.setSourceId(orderMainModel.getSourceId());// 渠道代码00: 商城01: CallCenter02:
							// IVR渠道03:
							// 手机商城04: 短信渠道05: 微信广发银行06：微信广发信用卡
							orderSubModel.setSourceNm(orderMainModel.getSourceNm());
							orderSubModel.setGoodsCode(itemModel.getGoodsCode());// 商品code
							orderSubModel.setGoodsId(itemModel.getCode());// 商（单）品代码
							orderSubModel.setGoodsNum(1);// 商品数量
							orderSubModel.setGoodsNm(goodsModel.getName());
							orderSubModel.setCurrType("156");// 商品币种
							orderSubModel.setExchangeRate(new BigDecimal(100));// 对人民币的汇率值
							orderSubModel.setGoodssendFlag("0");// 发货标记0－未发货[默认]1－已发货2－已签收
							orderSubModel.setGoodsaskforFlag("0");// 请款标记0－未请款[默认]1－已请款
							orderSubModel.setSpecShopnoType("");// 特店类型
							orderSubModel.setPayTypeNm("");// 佣金代码名称
							orderSubModel.setIncCode("");// 手续费率代码
							orderSubModel.setIncCodeNm("");// 手续费名称
							orderSubModel.setStagesNum(stagesNum);// 现金[或积分]分期数
							orderSubModel.setCommissionType("");// 佣金计算类别
							orderSubModel.setCommissionRate(new BigDecimal(0));// 佣金区间佣金率(不包含%)
							orderSubModel.setCommission(new BigDecimal(0));// 佣金金额【与币种一致】
							orderSubModel.setOrigMoney(new BigDecimal(0));// 原始现金总金额
							orderSubModel.setIncWay("00");// 手续费获取方式
							orderSubModel.setIncRate(new BigDecimal(0));// 手续费率(不包含%)
							orderSubModel.setIncMoney(new BigDecimal(0));// 手续费总金额
							orderSubModel.setUitfeeflg(new Integer("0"));// 手续费减免期数
							orderSubModel.setUitfeedam(new BigDecimal(0));// 手续费减免金额
							orderSubModel.setUitdrtuit(new Integer("0"));// 本金减免期数
							if (orderCommitInfoDto.getSinglePrice() != 0l) {
								orderSubModel.setUitdrtamt(new BigDecimal(orderCommitInfoDto.getJfCount()).divide(
										new BigDecimal(orderCommitInfoDto.getSinglePrice()), 2, BigDecimal.ROUND_DOWN));// 本金减免金额
							}
							orderSubModel.setIncBackPrice(new BigDecimal(0));// 手续费退回指定金额
							orderSubModel.setIncTakePrice(new BigDecimal(0));// 退单时收取指定金额手续费
							orderSubModel.setVoucherPrice(new BigDecimal(0));// 优惠金额
							orderSubModel.setCreditFlag("");// 授权额度不足处理方式
							orderSubModel.setCalWay("");// 退货方式
							orderSubModel.setLockedFlag("0");// 订单锁标记
							orderSubModel.setVendorOperFlag("0");// 供应商操作标记
							orderSubModel.setCurStatusId(orderMainModel.getCurStatusId());// 当前状态代码
							orderSubModel.setCurStatusNm(orderMainModel.getCurStatusNm());// 当前状态名称
							orderSubModel.setCreateOper(orderMainModel.getCreateOper());// 创建操作员id
							orderSubModel.setTypeId("");// 商品类别ID
							orderSubModel.setLevelNm(goodsModel.getGoodsType());// 商品类别名称
							orderSubModel.setGoodsBrand("");// 品牌
							orderSubModel.setGoodsModel("");// 型号
							orderSubModel.setGoodsColor("");// 商品颜色
							orderSubModel.setActType(orderCommitInfoDto.getPromotion() == null ? ""
									: orderCommitInfoDto.getPromotion().getPromType().toString());// 活动类型
							orderSubModel.setMerId(vendorInfoMap.get(vendorId).getMerId());// 商户号
							orderSubModel.setReserved1(vendorInfoMap.get(vendorId).getUnionPayNo());// 保存银联商户号
							orderSubModel.setGoodsAttr1(itemModel.getAttributeKey1());// 销售属性（json串）
							orderSubModel.setGoodsAttr2(itemModel.getAttributeKey2());
							orderSubModel.setGoodsPresent("");// 赠品 未完成
							orderSubModel.setBonusTrnDate(orderMainModel.getCommDate());// 支付日期
							orderSubModel.setBonusTrnTime(orderMainModel.getCommTime());// 支付时间
							orderSubModel.setTmpStatusId("0000");// 临时状态代码
							orderSubModel.setCommDate(orderMainModel.getCommDate());// 业务日期
							orderSubModel.setCommTime(orderMainModel.getCommTime());// 业务时间
							orderSubModel.setGoodssendFlag("0");// 发货标记 0－未发货[默认] 1－已发货 2－已签收
							orderSubModel.setEUpdateStatus("0");// 插入订单状态更新接口标志位 0:初始化
							orderSubModel.setCardtype("W");// 借记卡信用卡标识 未明
							// 购物车ＩＤ为itemCode+":"+支付方式（１或者２）
							// FIXME 现场修改 购物车ID 老代码是错的
							// String custCartId = "";
							// if (Contants.CART_PAY_TYPE_1.equals(payType)) {
							// custCartId = itemModel.getCode() + ":" + Contants.CART_PAY_TYPE_1;
							// } else if (Contants.CART_PAY_TYPE_2.equals(payType)) {
							// custCartId = itemModel.getCode() + ":" + Contants.CART_PAY_TYPE_2;
							// }
							orderSubModel.setCustCartId(orderCommitInfoDto.getCartId());// 此订单对应的购物车id
							if (orderCommitInfoDto.getPromotion() != null
									&& orderCommitInfoDto.getPromotion().getPromType() == 30) {
								orderSubModel.setMiaoshaActionFlag(new Integer(1));
							} else {
								orderSubModel.setMiaoshaActionFlag(new Integer(0));
							}
							String goodsTypeItem = goodsModel.getGoodsType();
							orderSubModel.setGoodsType(goodsTypeItem);// 商品类型（00实物01虚拟02O2O）
							if (Contants.SUB_ORDER_TYPE_00.equals(goodsTypeItem)) {
								orderSubModel.setGoodsTypeName(Contants.GOODS_TYPE_NM_00);
							}
							if (Contants.SUB_ORDER_TYPE_01.equals(goodsTypeItem)) {
								orderSubModel.setGoodsTypeName(Contants.GOODS_TYPE_NM_01);
							}
							if (Contants.SUB_ORDER_TYPE_02.equals(goodsTypeItem)) {
								orderSubModel.setGoodsTypeName(Contants.GOODS_TYPE_NM_02);
							}
							orderSubModel.setMemberName(user.getName());// 会员名称
							orderSubModel.setItemSmallPic(itemModel.getImage1());// 单品小图标
							orderSubModel.setDelFlag(Contants.DEL_FLAG_0);// 逻辑删除标志0未删1已删
							// 数据库不为空项
							orderSubModel.setVerifyFlag("");
							String voucherId = "";
							String voucherNo = "";
							String voucherNm = "";
							BigDecimal voucherPrice = new BigDecimal(0);
							if (index == 0) {// 同一个商品中优惠券只放在第一个小订单
								voucherId = orderCommitInfoDto.getVoucherId();// 优惠券ID
								voucherNo = orderCommitInfoDto.getVoucherNo();// 优惠券ID
								voucherNm = orderCommitInfoDto.getVoucherNm();// 优惠券名称
								voucherPrice = orderCommitInfoDto.getVoucherPrice();// 优惠券名称
							}
							orderSubModel.setVoucherId(voucherId);
							orderSubModel.setVoucherNo(voucherNo);
							orderSubModel.setVoucherNm(voucherNm);
							orderSubModel.setVoucherPrice(voucherPrice);
							orderSubModel.setCreateTime(orderMainModel.getCreateTime());
							orderSubModel.setModifyTime(orderMainModel.getCreateTime());
							// 不用 接口没有orderCommitInfoDto.getPrice()
							// BigDecimal totalMoney = orderCommitInfoDto.getPrice();
							// add
							BigDecimal totalMoney = new BigDecimal(0);
							if (orderCommitInfoDto.getPromotion() != null) {
								MallPromotionResultDto mallPromotionResultDto = orderCommitInfoDto.getPromotion();
								totalMoney = mallPromotionResultDto.getPromItemResultList().get(0).getPrice();
								Response<TblGoodsPaywayModel> goodsPaywayModelResponse = goodsPayWayService.findGoodsPayWayInfo(orderCommitInfoDto.getPayWayId());
								if(!goodsPaywayModelResponse.isSuccess()){
									log.error("Response.error,error code: {}", goodsPaywayModelResponse.getError());
									throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
								}
								TblGoodsPaywayModel goodsPaywayModel = goodsPaywayModelResponse.getResult();
								java.math.BigDecimal goodsPrice = goodsPaywayModel.getGoodsPrice();
								orderSubModel.setFenefit(goodsPrice.subtract(totalMoney));
							} else {
								Response<TblGoodsPaywayModel> goodsPaywayModelResponse = goodsPayWayService.findGoodsPayWayInfo(orderCommitInfoDto.getPayWayId());
								if(!goodsPaywayModelResponse.isSuccess()){
									log.error("Response.error,error code: {}", goodsPaywayModelResponse.getError());
									throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
								}
								TblGoodsPaywayModel goodsPaywayModel = goodsPaywayModelResponse.getResult();
								totalMoney = goodsPaywayModel.getGoodsPrice();
								orderSubModel.setFenefit(new BigDecimal(0));
							}

							// add end
							// - 积分抵扣
							if (orderCommitInfoDto.isFixFlag() == false) {

								// change 因为接口没有提供orderCommitInfoDto.getSinglePrice() 所有给为以下方式
								// totalMoney = totalMoney.subtract(new BigDecimal(orderCommitInfoDto.getJfCount())
								// .divide(new BigDecimal(orderCommitInfoDto.getSinglePrice()), 2,
								// BigDecimal.ROUND_HALF_DOWN)
								// .divide(new BigDecimal(orderCommitInfoDto.getItemCount()), 2,
								// BigDecimal.ROUND_HALF_DOWN));
								// //
								totalMoney = totalMoney
										.subtract((new BigDecimal(orderCommitInfoDto.getDiscountPrivMon()).divide(
												new BigDecimal(orderCommitInfoDto.getItemCount()), 2,
												BigDecimal.ROUND_DOWN)));
							}
							if (!"".equals(voucherNo) && voucherPrice != null) {
								// - 优惠券
								totalMoney = totalMoney.subtract(voucherPrice);
							}
							orderSubModel.setIntegraltypeId(orderCommitInfoDto.getPointType());
							orderSubModel.setTotalMoney(totalMoney);// 现金总金额
							orderSubModel.setSinglePrice(totalMoney);// 单个商品对应的价格
							// change orderCommitInfoDto.getInstalments() 改用 stagesNum
							if (stagesNum != null && stagesNum != 0) {
								orderSubModel.setInstallmentPrice(
										totalMoney.divide(new BigDecimal(stagesNum), 2, BigDecimal.ROUND_DOWN));// 分期价格
							} else {
								orderSubModel.setInstallmentPrice(new BigDecimal(0));
							}
							orderSubModel.setIncTakePrice(orderSubModel.getInstallmentPrice());// 退单时收取指定金额手续费(未用)
							orderSubModel.setSingleBonus(
									orderCommitInfoDto.getJfCount() / orderCommitInfoDto.getItemCount());
							orderSubModel.setBonusTotalvalue(orderCommitInfoDto.getJfCount());
							// undo 没有 orderCommitInfoDto.getOriPrice() orderCommitInfoDto.getPrice() 已在上面处理
							// orderSubModel.setFenefit(orderCommitInfoDto.getOriPrice() == null ? new BigDecimal(0)
							// : orderCommitInfoDto.getOriPrice().subtract(orderCommitInfoDto.getPrice()));
							orderSubModel.setCostBy(0);
							orderSubModel.setO2oExpireFlag(0);
							OrderSubModel orderSubModelNew = new OrderSubModel();
							BeanUtils.copyProperties(orderSubModel, orderSubModelNew);
							orderSubModelList.add(orderSubModelNew);
							OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
							orderDoDetailModel.setDoTime(new Date());
							orderDoDetailModel.setDoUserid(orderSubModel.getCreateOper());// 处理用户
							orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_3);// 用户类型0：系统用户[批量]1：内部用户[cc]2：供应商3：持卡人
							orderDoDetailModel.setStatusId(Contants.SUB_ORDER_STATUS_0301);// 状态代码0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
							orderDoDetailModel.setStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);// 状态名称
							orderDoDetailModel.setMsgContent("");
							orderDoDetailModel.setDoDesc("乐购下单");
							orderDoDetailModel.setCreateOper(orderSubModel.getCreateOper());// 创建人
							orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);// 逻辑删除标记为(0未删除，1已删除)
							orderDoDetailModelList.add(orderDoDetailModel);
						}
					}
				}
			}
		}
		return pagePaymentReqDto;
	}

	/**
	 * 根据当前状态查询
	 *
	 * @param paramMap
	 * @return
	 */
	@Override
	public Response<OrderSubModel> findInfoByCurStatusId(Map<String, Object> paramMap) {
		Response<OrderSubModel> response = new Response<>();
		try {
			Map<String, Long> result = Maps.newHashMap();
			OrderSubModel orderSubModel = orderSubDao.findInfoByCurStatusId(paramMap);
			response.setResult(orderSubModel);
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl findInfoByCurStatusId query error", Throwables.getStackTraceAsString(e));
			response.setSuccess(false);
			// response.setError("OrderServiceImpl.findGoodsBuyCount.query.error");
			return response;
		}
	}

	@Override
	public Response<Integer> insertOrderDoDetail(OrderDoDetailModel orderDoDetailModel) {
		Response<Integer> response = new Response<Integer>();
		try {
			Boolean flag = orderDodetailManager.insert(orderDoDetailModel);
			if (flag) {
				response.setResult(1);
			}
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl insertOrderDoDetail error", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.insertOrderDoDetail.error");
			return response;
		}
	}

	// 插入我的消息
	private void insertUserMessage(OrderSubModel orderSubModel, Boolean flag) {
		MessageDto messageDto = new MessageDto();
		messageDto.setCreateOper(orderSubModel.getModifyOper());
		messageDto.setCustId(orderSubModel.getCreateOper());
		messageDto.setGoodName(orderSubModel.getGoodsNm());
		messageDto.setOrderId(orderSubModel.getOrderId());
		messageDto.setOrderStatus(orderSubModel.getCurStatusId());
		// True 供应商 False 商城
		if (flag) {
			messageDto.setUserType("01");
		} else {
			messageDto.setUserType("02");
		}
		messageDto.setVendorId(orderSubModel.getVendorId());
		Response response = newMessageService.insertUserMessage(messageDto);
		if (response.isSuccess()) {
			log.info("newMessageService insertUserMessage succeed");
		} else {
			log.info("newMessageService insertUserMessage failed");
		}

	}

	/**
	 * 根据主订单号查询tbl_order 所有子订单(未删除) niufw
	 *
	 * @param orderMainId
	 * @return
	 */
	@Override
	public Response<List<OrderSubModel>> findByorderMainId(String orderMainId) {
		Response<List<OrderSubModel>> response = Response.newResponse();
		// 校验
		if (StringUtils.isEmpty(orderMainId)) {
			response.setError("tbl_order.find.query.error");
			return response;
		}
		try {
			List<OrderSubModel> orderSubModelList = orderSubDao.findOrderByOrderMainId(orderMainId);
			response.setResult(orderSubModelList);
			return response;
		} catch (Exception e) {
			log.error("tbl_order.find.query.error", Throwables.getStackTraceAsString(e));
			response.setError("tbl_order.find.query.error");
		}
		return response;
	}

	/**
	 * 更新订单历史表
	 *
	 * @param tblOrderHistory
	 * @return
	 */
	@Override
	public Response<Integer> updateTblOrderHistory(TblOrderHistoryModel tblOrderHistory) {
		Response<Integer> response = new Response<Integer>();
		try {
			Integer count = tblOrderHistoryDao.update(tblOrderHistory);
			if (count > 0) {
				response.setResult(count);
			}
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl updateTblOrderHistory error", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.updateTblOrderHistory.error");
			return response;
		}
	}

	/**
	 * 更新订单信息扩展表(bps项目加)
	 *
	 * @param tblOrderExtend1
	 * @return
	 */
	@Override
	@Transactional
	public Response<Integer> updateTblOrderExtend1(TblOrderExtend1Model tblOrderExtend1) {
		Response<Integer> response = new Response<Integer>();
		try {
			Integer count = tblOrderExtend1Dao.update(tblOrderExtend1);
			if (count > 0) {
				response.setResult(count);
			}
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl updateTblOrderExtend1 error", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.updateTblOrderExtend1.error");
			return response;
		}
	}

	/**
	 * 根据订单Id查询订单信息扩展表1
	 *
	 * @param orderId
	 * @return
	 */
	@Override
	public Response<TblOrderExtend1Model> queryTblOrderExtend1(String orderId) {
		Response<TblOrderExtend1Model> response = new Response<TblOrderExtend1Model>();
		try {
			checkArgument(StringUtils.isNotBlank(orderId), "orderId.can.not.be.empty");
			TblOrderExtend1Model model = tblOrderExtend1Dao.findByOrderId(orderId);
			response.setResult(model);
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl queryTblOrderExtend1 query error", Throwables.getStackTraceAsString(e));
			response.setSuccess(false);
			return response;
		}
	}

	/**
	 * 根据orderId查询订单历史表
	 *
	 * @param orderId
	 * @return
	 */
	@Override
	public Response<TblOrderHistoryModel> findTblOrderHistoryById(String orderId) {
		Response<TblOrderHistoryModel> response = new Response<TblOrderHistoryModel>();
		try {
			checkArgument(StringUtils.isNotBlank(orderId), "orderId.can.not.be.empty");
			TblOrderHistoryModel model = tblOrderHistoryDao.findById(orderId);
			response.setResult(model);
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl findTblOrderHistoryById query error", Throwables.getStackTraceAsString(e));
			response.setSuccess(false);
			return response;
		}
	}

	/**
	 * 根据orderId查询订单历史表（两年前数据）
	 *
	 * @param orderId
	 * @return
	 */
	@Override
	public Response<OrderBackupModel> findOrderBackupById(String orderId) {
		Response<OrderBackupModel> response = new Response<OrderBackupModel>();
		try {
			checkArgument(StringUtils.isNotBlank(orderId), "orderId.can.not.be.empty");
			OrderBackupModel model = orderBackupDao.findById(orderId);
			response.setResult(model);
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl findTblOrderHistoryById query error", Throwables.getStackTraceAsString(e));
			response.setSuccess(false);
			return response;
		}
	}

	@Override
	public Response<List<OrderSubModel>> findByOrderMainId(String orderMainId) {
		Response<List<OrderSubModel>> response = Response.newResponse();
		try {
			checkArgument(StringUtils.isNotBlank(orderMainId), "orderMainId.can.not.be.empty");
			List<OrderSubModel> list = Lists.newArrayList();
			list = orderSubDao.findByOrderMainId(orderMainId);
			response.setResult(list);
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl findByOrderMainId query error", Throwables.getStackTraceAsString(e));
			response.setSuccess(false);
			return response;
		}
	}

	/**
	 * 把大订单和小订单里都加上支付卡号
	 * @param ordermain_id
	 * @param payAccountNo
	 * @return
	 */
	@Override
	public Response<Integer> updateOrderCardNoForAll(String ordermain_id, String payAccountNo) {
		Response<Integer> response = Response.newResponse();
		try {
			Integer orderMain = orderMainManager.updateOrderCardNoForAll(ordermain_id, payAccountNo);
			response.setResult(orderMain);
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl updateOrderCardNoForAll error", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.updateOrderCardNoForAll.error");
			return response;
		}
	}

	/**
	 * MAL502 微信退积分接口的支付成功的订单退款 niufw
	 *
	 * @param orderMainId
	 * @param orderSubModel
	 * @param new_status_id
	 * @param new_status_nm
	 * @param cur_status_id
	 * @param backPointNum
	 * @param backNum
	 * @param partlyRefund
	 * @param oper_nm
	 * @param subFlag
	 */
	@Override
	public void updateVirtualOrderRefundWithTX(String orderMainId, OrderSubModel orderSubModel, String new_status_id,
			String new_status_nm, String cur_status_id, long backPointNum, int backNum, String partlyRefund,
			String oper_nm, boolean subFlag) {
		String orderId = orderSubModel.getOrderId();
		String goodsId = orderSubModel.getGoodsId();

		int mainFlag = 0;
		int orderFlag = 0;
		int orderExtend2Flag = 0;
		try {
			// 更新大订单状态
			OrderMainModel orderMainModel = new OrderMainModel();
			orderMainModel.setOrdermainId(orderMainId);
			orderMainModel.setCurStatusId(new_status_id);
			orderMainModel.setCurStatusNm(new_status_nm);
			orderMainModel.setModifyOper(oper_nm);
			mainFlag = orderMainManager.updateForMAL502(orderMainModel);
			// 更新小订单状态
			OrderSubModel orderSub = new OrderSubModel();
			orderSub.setOrderId(orderId);
			orderSub.setCurStatusId(new_status_id);
			orderSub.setCurStatusNm(new_status_nm);
			orderSub.setModifyOper(oper_nm);
			orderFlag = orderSubManager.updateForMAL502(orderSub);
			// 订单扩展表2 插入扣款记录
			TblOrderExtend2Model tblOrderExtend2Model = new TblOrderExtend2Model();
			tblOrderExtend2Model.setOrderId(orderId);
			tblOrderExtend2Model.setIsPartlyRefundIntegral(partlyRefund);
			tblOrderExtend2Model.setRefundIntegral(backPointNum);
			orderExtend2Flag = orderSubManager.insertForMAL502(tblOrderExtend2Model);
			// 插入订单取消记录
			OrderCancelModel orderCancelModel = new OrderCancelModel();
			orderCancelModel.setOrderId(orderId);
			orderCancelModel.setCancelCheckStatus("0");
			orderCancelModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0312);
			orderSubManager.saveTblOrderCancel(orderCancelModel);
		} catch (Exception e) {
			log.error("操作数据库失败：" + e.getMessage(), e);
			throw new ResponseException(Contants.ERROR_CODE_500, "订单已经退款，请勿重复退款");
		}
		if (mainFlag > 0 && orderFlag > 0 && orderExtend2Flag > 0) {
			OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
			orderDoDetailModel.setOrderId(orderId);
			orderDoDetailModel.setDoUserid(oper_nm);
			orderDoDetailModel.setUserType("0");
			orderDoDetailModel.setStatusId(new_status_id);
			orderDoDetailModel.setStatusNm(new_status_nm);
			orderDoDetailModel.setDoDesc("");
			orderDoDetailModel.setCreateOper(oper_nm);
			orderDoDetailModel.setModifyOper(oper_nm);
			orderDoDetailModel.setDelFlag(0);
			orderSubManager.saveOrderDodetail(orderDoDetailModel);
			// 回滚库存
			if (subFlag) {
				itemService.rollbackBacklogByNum(goodsId, backNum);
			}
		} else {
			throw new ResponseException(Contants.ERROR_CODE_500, "更新退款订单出错");
		}
	}

	/**
	 * MAL MAL422分页查询接口 niufw
	 *
	 * @param beginDate
	 * @param endDate
	 * @param createOper
	 * @return
	 */
	@Override
	public Response<Pager<OrderAndOutSystemDto>> findFor422(Integer rowsPageInt, int currentPageInt, String beginDate,
			String endDate, String createOper, String goodsNm) {
		Response<Pager<OrderAndOutSystemDto>> response = Response.newResponse();
		Map<String, Object> paramMap = Maps.newHashMap();
		PageInfo pageInfo = new PageInfo(currentPageInt, rowsPageInt);
		// 校验传入参数
		if (StringUtils.isNotEmpty(beginDate.trim())) {
			paramMap.put("beginDate", beginDate);
		}
		if (StringUtils.isNotEmpty(endDate.trim())) {
			paramMap.put("endDate", endDate);
		}
		if (StringUtils.isNotEmpty(createOper.trim())) {
			paramMap.put("createOper", createOper);
		}
		if (StringUtils.isNotEmpty(goodsNm.trim())) {
			paramMap.put("goodsNm", goodsNm);
		}
		try {
			// 分页查询订单表中的复合条件的数据
			Pager<OrderSubModel> pager = orderSubDao.findByPageFor422(paramMap, pageInfo.getOffset(),
					pageInfo.getLimit());
			if (pager.getTotal() > 0) {
				List<OrderSubModel> orderSubModels = pager.getData();
				List<OrderAndOutSystemDto> orderAndOutSystemDtos = Lists.newArrayList();
				OrderAndOutSystemDto orderAndOutSystemDto = null;
				// tbl_order和tbl_info_outsystem表关联
				for (OrderSubModel orderSubModel : orderSubModels) {
					orderAndOutSystemDto = new OrderAndOutSystemDto();
					String orderId = orderSubModel.getOrderId();
					// 根据orderId在tbl_info_outsystem表中查询数据
					Response<List<InfoOutSystemModel>> infoOutSystemModelResponse = infoOutSystemService
							.findByOrderId(orderId);
					if (!infoOutSystemModelResponse.isSuccess()) {
						log.error("infoOutSystemModel.query.error，error:{}", response.getError());
						throw new ResponseException(Contants.ERROR_CODE_500, "infoOutSystemModel.query.error");
					}
					List<InfoOutSystemModel> infoOutSystemModels = infoOutSystemModelResponse.getResult();
					// 根据旧系统判断应该是1对1的关系
					if (infoOutSystemModels.size() != 0) {
						InfoOutSystemModel infoOutSystemModel = infoOutSystemModels.get(0);
						orderAndOutSystemDto.setVerifyCode(infoOutSystemModel.getVerifyCode());
						orderAndOutSystemDto.setValidateStatus(infoOutSystemModel.getValidateStatus());
					}
					// 将model的数据复制（或者set）到dto里
					BeanMapper.copy(orderSubModel, orderAndOutSystemDto);
					// 将单条的数据放入到list中
					orderAndOutSystemDtos.add(orderAndOutSystemDto);
				}
				response.setResult(new Pager<OrderAndOutSystemDto>(pager.getTotal(), orderAndOutSystemDtos));
				return response;
			} else {
				response.setResult(new Pager<OrderAndOutSystemDto>(0L, Collections.<OrderAndOutSystemDto> emptyList()));
				return response;
			}
		} catch (Exception e) {
			log.error("OrderServiceImpl.findFor422.error", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.findFor422.error");
			return response;
		}
	}

	/**
	 * inser订单 接口MAL501
	 */
	@Override
	public Response<Integer> insertTblOrderSub(OrderSubModel orderSubModel) {
		Response<Integer> response = Response.newResponse();
		try {
			Integer updateFlg = orderSubManager.insert(orderSubModel);
			response.setResult(updateFlg);
			return response;
		} catch (Exception e) {
			log.error("orderSub.time.query.error", Throwables.getStackTraceAsString(e));
			response.setError("orderSub.time.query.error");
			return response;
		}
	}

	/**
	 * update主订单 接口MAL501
	 */
	@Override
	public Response<Integer> updateTblOrderSub(OrderSubModel orderSubModel) {
		Response<Integer> response = Response.newResponse();
		try {
			Integer updateFlg = orderSubManager.updateTblOrderSub(orderSubModel);
			response.setResult(updateFlg);
			return response;
		} catch (Exception e) {
			log.error("orderMain.time.query.error", Throwables.getStackTraceAsString(e));
			response.setError("orderMain.time.query.error");
			return response;
		}
	}

	@Override
	public Response<String> findOrderTypeIdByOrderId(String orderId) {
		Response<String> response = Response.newResponse().newResponse();
		try {
			String orderTypeId = orderSubDao.findOrderTypeIdByOrderId(orderId);
			response.setResult(orderTypeId);
			return response;
		} catch (Exception e) {
			log.error("orderService.findOrderTypeIdByOrderId.query.error", Throwables.getStackTraceAsString(e));
			response.setError("orderService.findOrderTypeIdByOrderId.query.error");
			return response;
		}
	}

	/**
	 * 根据主订单号查询tblorder_history所有子订单(未删除) niufw
	 *
	 * @param orderMainId
	 * @return
	 */
	@Override
	public Response<List<TblOrderHistoryModel>> findHistoryByorderMainId(String orderMainId) {
		Response<List<TblOrderHistoryModel>> response = Response.newResponse();
		// 校验
		if (StringUtils.isEmpty(orderMainId)) {
			response.setError("tblorder_history.find.query.error");
			return response;
		}
		try {
			List<TblOrderHistoryModel> orderSubModelList = tblOrderHistoryDao.findHistoryByorderMainId(orderMainId);
			response.setResult(orderSubModelList);
			return response;
		} catch (Exception e) {
			log.error("tblorder_history.find.query.error", Throwables.getStackTraceAsString(e));
			response.setError("tblorder_history.find.query.error");
		}
		return response;
	}

	/**
	 * 根据主订单号查询tblorder_backup所有子订单(未删除) niufw
	 *
	 * @param orderMainId
	 * @return
	 */
	@Override
	public Response<List<OrderBackupModel>> findBackupByorderMainId(String orderMainId) {
		Response<List<OrderBackupModel>> response = Response.newResponse();
		// 校验
		if (StringUtils.isEmpty(orderMainId)) {
			response.setError("tblorder_backup.find.query.error");
			return response;
		}
		try {
			List<OrderBackupModel> orderSubModelList = orderBackupDao.findBackupByorderMainId(orderMainId);
			response.setResult(orderSubModelList);
			return response;
		} catch (Exception e) {
			log.error("tblorder_backup.find.query.error", Throwables.getStackTraceAsString(e));
			response.setError("tblorder_backup.find.query.error");
		}
		return response;
	}

	/**
	 * 虚拟商品获取其他信息 niufw
	 *
	 * @param orderId
	 * @return
	 */
	@Override
	public Response<List<OrderVirtualModel>> findVirtualByOrderId(String orderId) {
		Response<List<OrderVirtualModel>> response = Response.newResponse();
		if (StringUtils.isEmpty(orderId)) {
			response.setError("virtual.find.query.error");
			return response;
		}
		try {
			List<OrderVirtualModel> orderVirtualModelList = orderVirtualDao.findByOrderId(orderId);
			response.setResult(orderVirtualModelList);
			return response;
		} catch (Exception e) {
			log.error("virtual.find.query.error", Throwables.getStackTraceAsString(e));
			response.setError("virtual.find.query.error");
		}
		return response;
	}

	/**
	 * 更新广发商城小订单流水号
	 *
	 * @param orderSubModel
	 */
	public void updateOrderSerialNo(OrderSubModel orderSubModel) {
		orderSubManager.updateOrderSerialNo(orderSubModel);
	}

	/**
	 * 取得子订单
	 *
	 * @param orderId
	 */
	public Response<OrderSubModel> selectOrderSub(String orderId) {
		Response<OrderSubModel> response = Response.newResponse();
		try {
			OrderSubModel orderSubModel = orderSubDao.findById(orderId);
			response.setResult(orderSubModel);
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl selectOrderSub query error", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.selectOrderSub.query.error");
			return response;
		}
	}

	/**
	 * 取得订单扩展表
	 * @param orderId
	 */
	public Response<TblOrderExtend1Model> selectOrderExtend(String orderId){
		Response<TblOrderExtend1Model> response = Response.newResponse();
		try {
			TblOrderExtend1Model orderSubModel = tblOrderExtend1Dao.findByOrderId(orderId);
			response.setResult(orderSubModel);
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl selectOrderExtend query error", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.selectOrderExtend.query.error");
			return response;
		}
	}

	/**
	 * 保存订单扩展表
	 * @param tblOrderExtend
	 */
	public void insertOrderExtend(TblOrderExtend1Model tblOrderExtend){
		try {
			orderSubManager.insertOrderExtend(tblOrderExtend);
		} catch (Exception e) {
			log.error("OrderServiceImpl insertOrderExtend query error", Throwables.getStackTraceAsString(e));
		}
	}

	/**
	 * 通过订单id查询订单
	 *
	 * @param orderId
	 */
	@Override
	public Response<OrderSubModel> findOrderSubById(String orderId) {
		Response<OrderSubModel> response = Response.newResponse();
		try {
			OrderSubModel orderSubModel = orderSubDao.findById(orderId);
			response.setResult(orderSubModel);
			return response;
		} catch (Exception e) {
			log.error("order.query.error", Throwables.getStackTraceAsString(e));
			response.setError("order.query.error");
		}
		return response;
	}

	/**
	 * 通过订单id查询订单
	 *
	 * @param orderId
	 */
	@Override
	public Response<List<OrderDoDetailModel>> findOrderDoDetailByOrderStatusId(String orderId) {
		Response<List<OrderDoDetailModel>> response = Response.newResponse();
		try {
			List<OrderDoDetailModel> orderDoDetailModels = orderDoDetailDao.findByOrderStatusId(orderId);
			response.setResult(orderDoDetailModels);
			return response;
		} catch (Exception e) {
			log.error("order.query.error", Throwables.getStackTraceAsString(e));
			response.setError("order.query.error");
		}
		return response;
	}

	/**
	 * 存储大订单，小订单，订单历史 shangqinbin
	 *
	 * @param orderMainModel
	 * @param orderMap
	 * @param subFlag
	 * @param businessType
	 */
	@Override
	public void saveOrdersWithTX(OrderMainModel orderMainModel, Map orderMap, boolean subFlag, String businessType) {
		Map<String,String> returnMap = null;
		if(orderMap != null && orderMainModel != null){
			//保存小订单
			List order = (List)orderMap.get("orderSubModelList");
			//保存订单历史表
			List detail = (List)orderMap.get("orderDodetailList");
			orderTradeManager.saveOrdersWithTX(orderMainModel, order, subFlag, detail);
			log.info("订单主表、订单表、订单历史表保存成功！");
		}
//		return returnMap;
	}

	/**
	 * 积分商城下单(外部接口 MAL104 调用)
	 * @param orderCCAndIVRAddDto 下单参数
	 *
	 * geshuo 20160825
	 */
	@Override
	public Response<Boolean> createCCAndIVRVirtualOrder(OrderCCAndIVRAddDto orderCCAndIVRAddDto){
		Response<Boolean> response = Response.newResponse();
		try{
			orderMainManager.createCCAndIVRVirtualOrder(orderCCAndIVRAddDto);
			response.setResult(true);
		} catch (ResponseException re){
			response.setError(re.getMessage());
			log.error("OrderServiceImpl.createCCAndIVRVirtualOrder.error Exception:{}",Throwables.getStackTraceAsString(re));
		} catch (Exception e) {
			response.setError("000011");
			log.error("OrderServiceImpl.createCCAndIVRVirtualOrder.error Exception:{}",Throwables.getStackTraceAsString(e));
		}
		return response;
	}

	/**
	 * 积分商城-实物商品下单(外部接口 MAL104 调用)
	 * @param orderCCAndIVRAddDto 下单参数
	 *
	 * gehsuo 20160825
	 */
	@Override
	public 	Response<Map<String,Object>> createCCAndIVRRealOrder(OrderCCAndIVRAddDto orderCCAndIVRAddDto){
		Response<Map<String,Object>> response = Response.newResponse();
		try{
			Map<String,Object> resultMap = orderMainManager.createCCAndIVRRealOrder(orderCCAndIVRAddDto);
			response.setResult(resultMap);
		} catch (ResponseException re){
			response.setError(re.getMessage());
			log.error("OrderServiceImpl.createCCAndIVRRealOrder.error Exception:{}",Throwables.getStackTraceAsString(re));
		} catch (Exception e) {
			response.setError("000011");
			log.error("OrderServiceImpl.createCCAndIVRRealOrder.error Exception:{}",Throwables.getStackTraceAsString(e));
		}
		return response;
	}


	/**
	 * 通过订单id查询订单
	 *
	 * @param orderId
	 */
	@Override
	public Response<OrderSubModel> findJfOrderById(String orderId) {
		Response<OrderSubModel> response = Response.newResponse();
		try {
			OrderSubModel orderSubModel = orderSubDao.findJfOrderById(orderId);
			response.setResult(orderSubModel);
			return response;
		} catch (Exception e) {
			log.error("order.query.error", Throwables.getStackTraceAsString(e));
			response.setError("order.query.error");
		}
		return response;
	}

	/**
	 * 通过订单id查询订单
	 */
	@Override
	public Response<OrderSubModel> findByOrderMainIdAndOrderId(String orderId, String orderMainId) {
		Response<OrderSubModel> response = Response.newResponse();
		try {
			Map<String, Object> map = Maps.newHashMap();
			map.put("orderId", orderId);
			map.put("orderMainId", orderMainId);
			OrderSubModel orderSubModel = orderSubDao.findByOrderMainIdAndOrderId(map);
			response.setResult(orderSubModel);
			return response;
		} catch (Exception e) {
			log.error("order.query.error", Throwables.getStackTraceAsString(e));
			response.setError("order.query.error");
		}
		return response;
	}
	/**
	 * 401接口更新订单状态
	 * @param orderMainId
	 * @param payState
	 * @param retCode
	 * @param subFlag
	 */
	@Override
	public void updateOrdersWithTX(String orderMainId, String payState, String retCode, boolean subFlag) {
		List<OrderSubModel> orders = orderSubDao.findOrderByOrderMainId(orderMainId);
		//订单状态ID
		String cur_status_id = "";
		//订单状态说明
		String cur_status_nm = "";
		if("1".equals(payState)){//支付成功
			cur_status_id = "0308";
			cur_status_nm = "支付成功";
		}else if("3".equals(payState)){//状态未明
			cur_status_id = "0316";
			cur_status_nm = "订单状态未明";
		}else{//支付失败
			cur_status_id = "0307";
			cur_status_nm = "支付失败";
		}
		OrderMainModel orderMainModel = new OrderMainModel();
		orderMainModel.setOrdermainId(orderMainId);
		orderMainModel.setCurStatusId(cur_status_id);
		orderMainModel.setCurStatusNm(cur_status_nm);
		orderMainModel.setModifyOper("短信支付");
		orderMainModel.setErrorCode(retCode);
		OrderSubModel orderSubModel = new OrderSubModel();
		orderSubModel.setOrdermainId(orderMainId);
		orderSubModel.setCurStatusId(cur_status_id);
		orderSubModel.setCurStatusNm(cur_status_nm);
		orderSubModel.setModifyOper("短信支付");
		orderSubModel.setErrorCode(retCode);
		orderMainManager.updateForMAL401(orderMainModel);
		orderSubManager.updateByOrderMainId(orderSubModel);
		if(orders!=null&&orders.size()>0){
			for (int i = 0; i < orders.size(); i++) {
				OrderSubModel order = (OrderSubModel)orders.get(i);
				OrderDoDetailModel tblOrderDodetail = new OrderDoDetailModel();
				tblOrderDodetail.setStatusId(cur_status_id);
				tblOrderDodetail.setStatusNm(cur_status_nm);
				tblOrderDodetail.setDoDesc(retCode);
				tblOrderDodetail.setDoTime(new Date());
				tblOrderDodetail.setDoUserid("电子支付");
				tblOrderDodetail.setUserType("0");
				tblOrderDodetail.setOrderId(order.getOrderId());
				tblOrderDodetail.setDelFlag(0);
				tblOrderDodetail.setCreateOper("电子支付");
				tblOrderDodetail.setCreateTime(new Date());
				orderDodetailManager.insert(tblOrderDodetail);
				if("0307".equals(cur_status_id)) {
					//支付失败回滚库存
					if(subFlag){
						itemService.rollbackBacklogByNum(order.getOrderId(), 1);
					}
					//使用生日价支付回滚生日次数
					if("0004".equals(order.getMemberLevel())){
						Map<String, Object> paramMap = Maps.newHashMap();
						String custId = order.getCreateOper();
						paramMap.put("custId",custId);
						Response<EspCustNewModel> espCustNewResponse = espCustNewService.findById(custId);
						if(!espCustNewResponse.isSuccess()){
							log.error("Response.error,error code: {}", espCustNewResponse.getError());
							throw new ResponseException(Contants.ERROR_CODE_500, "Response.error");
						}
						EspCustNewModel espCustNewModel = espCustNewResponse.getResult();
						Integer birthUsedCount = espCustNewModel.getBirthUsedCount();
						espCustNewModel.setBirthUsedCount(birthUsedCount-order.getGoodsNum().intValue());
						espCustNewService.update(espCustNewModel);
					}
				}
			}
		}
	}

	/**
	 * 通过订单id查询状态为0307或0308订单处理历史明细
	 *
	 * @param orderId
	 * @return
	 */
	@Override
	public Response<OrderDoDetailModel> findByStatusAndOrderId(String orderId) {
		Response<OrderDoDetailModel> response = Response.newResponse();
		try {
			OrderDoDetailModel orderDoDetailModel = orderDoDetailDao.findByStatusAndOrderId(orderId);
			response.setResult(orderDoDetailModel);
			return response;
		} catch (Exception e) {
			log.error("orderService.findByStatusAndOrderId.error", Throwables.getStackTraceAsString(e));
			response.setError("orderService.findByStatusAndOrderId.error");
		}
		return response;
	}

	/**
	 * 积分商城下单-实物商品(外部接口 MAL104 调用) 更新订单状态
	 *
	 * @param uOrderMain 主订单信息
	 * @param orderList 子订单列表
	 * @return
	 */
	@Override
	public Response updateCCAndIVRTureOrder(OrderMainModel uOrderMain, List<OrderSubModel> orderList) {
		Response response = Response.newResponse();
		try {
			orderMainManager.updateCCAndIVRTureOrder(uOrderMain, orderList);
			response.setSuccess(true);
		} catch (ResponseException re) {
			response.setError(re.getMessage());
			log.error("OrderServiceImpl.updateCCAndIVROrder.error Exception:{}", Throwables.getStackTraceAsString(re));
		} catch (Exception e) {
			response.setError(e.getMessage());
			log.error("OrderServiceImpl.updateCCAndIVROrder.error Exception:{}", Throwables.getStackTraceAsString(e));
		}
		return response;
	}

	@Override
	public Response updateCCAndIVRFalseOrder(OrderMainModel uOrderMain, List<OrderSubModel> orderList, String payState,
			String senderSN, List<String> birthList, String retCode, String message) {
		Response response = Response.newResponse();
		try {
			orderMainManager.updateCCAndIVRFalseOrder(uOrderMain, orderList, payState, senderSN, birthList, retCode,
					message);
			response.setSuccess(true);
		} catch (ResponseException re) {
			response.setError(re.getMessage());
			log.error("OrderServiceImpl.updateCCAndIVROrder.error Exception:{}", Throwables.getStackTraceAsString(re));
		} catch (Exception e) {
			response.setError(e.getMessage());
			log.error("OrderServiceImpl.updateCCAndIVROrder.error Exception:{}", Throwables.getStackTraceAsString(e));
		}
		return response;
	}

	/**
	 * 查询信用卡积分
	 *
	 * @param mergeFlag 是否合并支付 0 是 1 否
	 * @param cardNo
	 * @return
	 */
	public List<QueryPointsInfoResult> getAmount(String cardNo, String mergeFlag, boolean flag) {
		List<QueryPointsInfoResult> list = new ArrayList<QueryPointsInfoResult>();
		Map<QueryPointsInfoResult, String> typeMap = new HashMap<QueryPointsInfoResult, String>();
		QueryPointsInfo queryPointsInfo = new QueryPointsInfo();
		queryPointsInfo.setChannelID("MALL");
		queryPointsInfo.setCardNo(cardNo);
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
		queryPointsInfo.setStartDate(df.format(new Date()));
		queryPointsInfo.setEndDate(df.format(new Date()));
		queryPointsInfo.setCurrentPage("0");
		QueryPointResult queryPointResult = pointService.queryPoint(queryPointsInfo);
		boolean addFlag;
		try {
			List<QueryPointsInfoResult> queryPointsInfoResults = Lists.newArrayList();
			// true: 画面表示用 false:积分校验用
			if (flag) {
				//			获取当前卡下的对象list
				if (queryPointResult.getQueryPointsInfoResults() != null && !queryPointResult.getQueryPointsInfoResults().isEmpty()) {
					for (QueryPointsInfoResult pointInfo : queryPointResult.getQueryPointsInfoResults()) {
						if (cardNo.equals(pointInfo.getCardNo())) {
							queryPointsInfoResults.add(pointInfo);
						}
					}
				}
			} else {
				queryPointsInfoResults = queryPointResult.getQueryPointsInfoResults();
			}

			for (QueryPointsInfoResult pointInfo : queryPointsInfoResults) {
				addFlag = true;
				// modify by zhanglin at 20160911 for 304686 积分类型显示？？？start
				// String jgtype = pointInfo.getJgtype();
				if (pointInfo != null) {
					if (pointInfo.getJgId() != null) {
						Response<TblCfgIntegraltypeModel> jftype = cfgIntegraltypeService.findById(pointInfo.getJgId());
						if (jftype.isSuccess()) {
							TblCfgIntegraltypeModel cfgIntegraltypeModel = jftype.getResult();
							// 积分类型名
							if (cfgIntegraltypeModel == null) {
								pointInfo.setJgtype("未知类型");
							} else {
								pointInfo.setJgtype(cfgIntegraltypeModel.getIntegraltypeNm());
							}
						} else {
							log.error("orderService.findJftype.error{}", jftype.getError());
							throw new TradeException("orderService.findJftype.error");
						}
					}
					// pointInfo.setJgtype(new String(jgtype.getBytes("iso-8859-1"), "utf-8"));
					// modify by zhanglin at 20160911 for 304686 end
					if (mergeFlag.equals("0") || (mergeFlag.equals("1") && cardNo.equals(pointInfo.getCardNo()))) {
						for (Map.Entry<QueryPointsInfoResult, String> entry : typeMap.entrySet()) {
							if (pointInfo.getJgId().equals(entry.getValue())
									&& pointInfo.getValidDate().equals(entry.getKey().getValidDate())) {
								entry.getKey().setAccount(entry.getKey().getAccount().add(pointInfo.getAccount()));
								addFlag = false;
							}
						}
						if (addFlag) {
							typeMap.put(pointInfo, pointInfo.getJgId());
						}
					}
				}
			}
		} catch (TradeException e) {
			log.error("Error getAmount", Throwables.getStackTraceAsString(e));
		} catch (Exception e) {
			log.error("Error getAmount", Throwables.getStackTraceAsString(e));
		}
		for (Map.Entry<QueryPointsInfoResult, String> entry : typeMap.entrySet()) {
			list.add(entry.getKey());
		}
		return list;
	}

	/**
	 * 供应商平台请款管理查询
	 *
	 * @param list
	 * @return
	 */
	@Override
	public Response<List<OrderSubModel>> findForRequest(List<String> list) {
		Response<List<OrderSubModel>> response = Response.newResponse();
		try {
			Map<String, Object> dataMap = Maps.newHashMap();
			dataMap.put("list", list);
			List<OrderSubModel> orderSubModelList = orderSubDao.findForRequest(dataMap);
			response.setResult(orderSubModelList);
			return response;
		} catch (Exception e) {
			log.error("order.query.error，{}", Throwables.getStackTraceAsString(e));
			response.setError("order.query.error");
			return response;
		}
	}


	@Override
	public Response<Boolean> updateShopCartByOrderSuccess(List<String> cartIds) {
		Response<Boolean> response = Response.newResponse();
		try {
			espCustCartManager.deleteByIds(cartIds);
			return response;
		} catch (Exception e) {
			log.error("order.deleteShopCart.error，{}",
					Throwables.getStackTraceAsString(e));
			response.setError("order.deleteShopCart.error");
			return response;
		}
	}

	@Override
	public Response<PagePaymentReqDto> getPaymentReqData(
			OrderMainModel ordermainModel, List<OrderSubModel> orderSubModelList) {
		Response<PagePaymentReqDto> response = new Response<>();
		try {
			PagePaymentReqDto resultData = new PagePaymentReqDto();
			getReturnObjForPay(resultData, ordermainModel, orderSubModelList);
			response.setResult(resultData);
		} catch (Exception e) {
			log.error("-----------------构建支付数据异常:" + e.getMessage());
			response.setError("构建支付数据异常");
		}
		return response;
	}

	//校验第三级卡产品编码与信用卡卡板是否一致
	private Boolean checkCardGoods(String cardNo,GoodsModel goodsModel){
		// 商品维护的第三级卡信息
		String[] cards = goodsModel.getCards() != null ? goodsModel.getCards().split(",") : null;
		// 用户是否有银行卡符合要求
		Boolean canBy = Boolean.FALSE;
		if (cards != null && cards.length > 0) {
			// 第三类卡编码为wwww不进行校验
			if ("wwww".equalsIgnoreCase(cards[0])) {
				canBy = true;
			}
			// 有一张卡符合第三级卡要求则允许用户购买
			if (!canBy) {
				Response<ACardCustToelectronbankModel> cardResponse = aCardCustToelectronbankService.findByCardNbr(cardNo);
				if (cardResponse.isSuccess()) {
					ACardCustToelectronbankModel aCardCustToelectronbankModel = cardResponse.getResult();
					if (aCardCustToelectronbankModel != null) {
						for (String card : cards) {
							if (card.equals(aCardCustToelectronbankModel.getCardFormatNbr())) {
								canBy = true;
								break;
							}
						}
					}
				}else {
					log.error("orderService.checkCardGoods.error"+cardResponse.getError());
					throw new TradeException("获取客户明细信息失败");
				}
			}
		}
		return canBy;
	}

	@Override
	public Response<Boolean> checkParametersForMall(String orderTypeId) {
		Response<Boolean> response = Response.newResponse();
		try{
			checkArgument(StringUtils.isNotBlank(orderTypeId), "业务类型参数异常");
			if ((!Contants.BUSINESS_TYPE_JF.equals(orderTypeId))&&(!Contants.BUSINESS_TYPE_YG.equals(orderTypeId))){
				response.setError("业务类型参数异常");
				return response;
			}
			//商城web端
			String sourceId=Contants.ORDER_SOURCE_ID_MALL;
			//登录信息0 ，支付信息 2
			Integer parametersType=2;
			Response<List<TblParametersModel>> bussinessResponse = businessService.findParameters(parametersType, orderTypeId, sourceId);
			if(!bussinessResponse.isSuccess()){
				log.error("businessService.findJudgeQT.error,error code: {}", bussinessResponse.getError());
				response.setError("OrderServiceImpl.checkParametersForMall.error");
				return response;
			}
			if (bussinessResponse.getResult()==null||bussinessResponse.getResult().isEmpty()){
				log.error("businessServic.findJudgeQT.error,result be null");
				response.setError("OrderServiceImpl.checkParametersForMall.error");
				return response;
			}
			//业务上 只存在一条
			TblParametersModel tblParametersModel= bussinessResponse.getResult().get(0);
//			0启动 1停止
			if (tblParametersModel.getOpenCloseFlag()==null||1==tblParametersModel.getOpenCloseFlag()){
				if(StringUtils.isBlank(tblParametersModel.getPrompt())){
					if (Contants.BUSINESS_TYPE_JF.equals(orderTypeId)){
						response.setError("当前积分商城不允许支付");
					}else {
						response.setError("当前广发商城不允许支付");
					}
				}else {
					response.setError(tblParametersModel.getPrompt());
				}
				return response;
			}
			response.setResult(Boolean.TRUE);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("OrderServiceImpl checkParametersForMall.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl checkParametersForMall.error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.checkParametersForMall.error");
			return response;
		}
	}
	
	@Override
	public Response saveGfOrder(OrderMainModel orderMainModel,
								List<OrderSubModel> orderSubModelList,
							    List<OrderDoDetailModel> orderDoDetailModelList,
							    OrderMainDto orderMainDto,User user) {
		Response response = Response.newResponse();
		// 登入数据库
		try {
		    orderMainManager.createOrder_new(orderMainModel, orderSubModelList, orderDoDetailModelList,
				orderMainDto.getStockMap(), orderMainDto.getPointPoolModel(), orderMainDto.getPromItemMap(),
				user);
			response.setSuccess(true);
			return response;
		} catch (Exception e) {
			log.error("OrderService saveOrder error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setResult(e.getMessage());
			response.setSuccess(false);
			return response;
		}
	}

	public Response<Map<String,List<OrderDoDetailModel>>> findOrderDoDetail(List<String> orderids){
		Response<Map<String,List<OrderDoDetailModel>>> response = Response.newResponse();
		try {
			Map<String,List<OrderDoDetailModel>> doMap = Maps.newHashMap();
			List<OrderDoDetailModel> orderDos= orderDoDetailDao.findByOrderIds(orderids);
			List<OrderDoDetailModel> temps = Lists.newArrayList();
			String tempId = null;
			for (OrderDoDetailModel doDetailModel : orderDos){
				if(tempId == null){
					tempId = doDetailModel.getOrderId();
				}
				if(!tempId.equals(doDetailModel.getOrderId())){
					doMap.put(tempId,temps);
					tempId = doDetailModel.getOrderId();
					temps = Lists.newArrayList();
					temps.add(doDetailModel);
				}else{
					temps.add(doDetailModel);
				}
			}
			response.setResult(doMap);
		}catch (Exception e) {
			response.setError("orderServiceImpl.findOrderDoDetail.error");
		}
		return response;
	}

	public Response<Map<String,TblOrderExtend1Model>> findOrderExtendDetail(List<String> orderids){
		Response<Map<String,TblOrderExtend1Model>> response = Response.newResponse();
		try {
			Map<String,TblOrderExtend1Model> doMap = Maps.newHashMap();
			List<TblOrderExtend1Model>  orderExtend1ModelList = tblOrderExtend1Dao.findByOrderIds(orderids);
			for (TblOrderExtend1Model extend1Model : orderExtend1ModelList){
				doMap.put(extend1Model.getOrderId(),extend1Model);
			}
			response.setResult(doMap);
		}catch (Exception e){
			response.setError("orderService.findOrderExtend.error");
		}
		return response;
	}
}
