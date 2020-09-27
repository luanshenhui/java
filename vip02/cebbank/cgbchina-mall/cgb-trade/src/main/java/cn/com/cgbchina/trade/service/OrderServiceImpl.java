package cn.com.cgbchina.trade.service;

import static com.google.common.base.Preconditions.checkArgument;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.annotation.Resource;

import com.google.common.io.Resources;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.joda.time.LocalDate;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JavaType;
import com.google.common.base.Charsets;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.hash.Hashing;
import com.spirit.Annotation.Param;
import com.spirit.common.model.PageInfo;
import com.spirit.common.model.Pager;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import com.spirit.user.UserAccount;
import com.spirit.util.BeanMapper;
import com.spirit.util.JsonMapper;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.*;
import cn.com.cgbchina.item.dto.ItemsAttributeDto;
import cn.com.cgbchina.item.dto.ItemsAttributeSkuDto;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.ProductModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.*;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.trade.dao.*;
import cn.com.cgbchina.trade.dto.*;
import cn.com.cgbchina.trade.manager.*;
import cn.com.cgbchina.trade.model.*;
import cn.com.cgbchina.user.model.MemberAddressModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.MemberAddressService;
import cn.com.cgbchina.user.service.VendorService;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by yanjie.cao on 16-4-25.
 */
@Service
@Slf4j
public class OrderServiceImpl implements OrderService {
	private final static JavaType javaType = JsonMapper.JSON_NON_EMPTY_MAPPER.createCollectionType(ArrayList.class,
			OrderItemAttributeDto.class);
	private final static JsonMapper JSON_MAPPER = JsonMapper.nonEmptyMapper();
	private final static DateTimeFormatter DFT = DateTimeFormat.forPattern("yyyyMMdd");// 字符串转时间
	private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	@Resource
	OrderSubDao orderSubDao;
	@Resource
	OrderMainDao orderMainDao;
	@Resource
	OrderTransDao orderTransDao;
	@Resource
	OrderDoDetailDao orderDoDetailDao;
	@Resource
	OrderPartBackDao orderPartBackDao;
	@Resource
	OrderReturnTrackDao orderReturnTrackDao;
	@Resource
	GoodsService goodsService;
	@Resource
	ItemService itemService;
	@Resource
	VendorService vendorService;
	@Resource
	ProductService productService;
	@Resource
	CartService cartService;
	@Resource
	MemberAddressService memberAddressService;
	@Resource
	PointRelatedService pointRelatedService;
	@Resource
	GoodsPayWayService goodsPayWayService;
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
	@Value("#{app.merchId}")
	private String merchId;
	@Value("#{app.returl}")
	private String returl;
	@Value("#{app.mainPrivateKey}")
	private String mainPrivateKey;
	@Value("#{app.payAddress}")
	private String payAddress;
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
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
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
			@Param("limitFlag") String limitFlag, @Param("type") String type, @Param("mallType") String mallType,
			@Param("") User user) {
		// 获取用户ID
		String id = user.getId();
		LocalDate endDate = LocalDate.now();
		LocalDate startDateMIn6 = endDate.minusMonths(6);
		// 构造返回值及参数
		Response<Pager<OrderInfoDto>> response = new Response<Pager<OrderInfoDto>>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Map<String, Object> paramMap = Maps.newHashMap();
		// 默认选择逻辑删除
		paramMap.put("delFlag", Contants.DEL_INTEGER_FLAG_0);
		// 商城默认不处理“虚拟商品”订单
		paramMap.put("goodsTypeFlag", Contants.SUB_ORDER_TYPE_01);
		// 非积分订单
		paramMap.put("ordertypeIdFlag", Contants.BUSINESS_TYPE_JF);
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
		// 判断商城是否查询6个月之前的数据
		if (StringUtils.isEmpty(limitFlag)) {
			paramMap.put("startTime", startDateMIn6.toString());
			paramMap.put("endTime", endDate.toString());
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
			paramMap.put("goodsId", goodsId.trim());
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
		// 区分mallType 为空内管系统 mallType -1，2，3，4，5商城系统不同tap
		if (StringUtils.isEmpty(mallType)) {
			// 判断订单类型为空
			if (StringUtils.isNotBlank(curStatusId)) {
				paramMap.put("curStatusId", curStatusId);
			}
		} else {
			switch (mallType) {
			// 所有订单
			case Contants.VENDOR_ORDER_TYPE_1:
				if (StringUtils.isNotBlank(curStatusId)) {
					paramMap.put("curStatusId", curStatusId);
				}
				break;
			// 待付款
			case Contants.VENDOR_ORDER_TYPE_2:
				paramMap.put("curStatusId", Contants.SUB_ORDER_STATUS_0301);
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
		}
		// 根据mallType添加用户ID
		if (StringUtils.isNotBlank(mallType)) {
			// 获取用户ID
			String userId = user.getId();
			checkArgument(StringUtils.isNotBlank(userId), "userId.can.not.be.empty");
			paramMap.put("createOper", userId);
		}

		// 判断分期类型为空
		if (StringUtils.isNotBlank(ordertypeId)) {
			paramMap.put("ordertypeId", ordertypeId);
		}
		// 判断主订单号为空
		if (StringUtils.isNotBlank(ordermainId)) {
			paramMap.put("ordermainId", ordermainId.trim());
		}
		try {
			// 获取子订单列表数据
			// 获取子订单列表数据 六个月之前订单取自history表
			Pager<OrderSubModel> pager = new Pager<>();
			List<OrderSubModel> orderSubModelList = new ArrayList<OrderSubModel>();
			if (StringUtils.isEmpty(limitFlag)) {
				pager = orderSubDao.findLikeByPage(paramMap, pageInfo.getOffset(), pageInfo.getLimit());
				orderSubModelList = pager.getData();
			} else {
				Pager<TblOrderHistoryModel> pagerTblOrderHistory = tblOrderHistoryDao.findLikeByPage(paramMap,
						pageInfo.getOffset(), pageInfo.getLimit());
				List<TblOrderHistoryModel> tblOrderHistoryModelList = pagerTblOrderHistory.getData();
				for (TblOrderHistoryModel tblOrderHistoryModel : tblOrderHistoryModelList) {
					OrderSubModel orderSubModel = new OrderSubModel();
					BeanMapper.copy(tblOrderHistoryModel, orderSubModel);
					orderSubModelList.add(orderSubModel);
				}
			}
			List<OrderInfoDto> orderInfoDtos = new ArrayList<OrderInfoDto>();
			OrderInfoDto orderInfoDto = null;
			// 遍历orderSubModel，构造返回值
			for (OrderSubModel orderSubModel : orderSubModelList) {
				orderInfoDto = new OrderInfoDto();
				orderInfoDto.setOrderSubModel(orderSubModel);
				// 判断订单是否为退货状态，当是时获取退货ID
				if (StringUtils.isNotBlank(orderSubModel.getSaleAfterStatus())
						&& !"0312".equals(orderSubModel.getSaleAfterStatus())) {
					OrderPartBackModel orderPartBackModel = orderPartBackDao.findByOrderId(orderSubModel.getOrderId());
					if (orderPartBackModel == null) {
						response.setError("OrderServiceImpl.find.eroor.orderPartBackModel.can.not.be.null");
						return response;
					}
					orderInfoDto.setPartBackId(orderPartBackModel.getId());
				}
				// 置订单是否使用优惠券及积分标识 true-使用
				orderInfoDto.makeBonusTotalFlag();
				orderInfoDto.makeVoucherFlag();
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
							|| Contants.SUB_ORDER_STATUS_0310.equals(orderSubModel.getCurStatusId())) {
						orderInfoDto.setOrderTransFlag(Boolean.TRUE);

					} else {
						orderInfoDto.setOrderTransFlag(Boolean.FALSE);
					}
				} else {
					orderInfoDto.setOrderTransFlag(Boolean.FALSE);
				}
				// 获取商品销售属性
				String json = orderSubModel.getGoodsAttr1();
				List<OrderItemAttributeDto> orderItemAttributeDtoList = Lists.newArrayList();
				// json转list
				if (StringUtils.isNotEmpty(json)) {
					ItemsAttributeDto itemsAttributeDto = JSON_MAPPER.fromJson(json, ItemsAttributeDto.class);
					if (itemsAttributeDto != null) {
						List<ItemsAttributeSkuDto> skus = Lists.newArrayList();
						skus = itemsAttributeDto.getSkus();
						if (!skus.isEmpty() && skus != null) {
							for (ItemsAttributeSkuDto itemsAttributeSkuDto : skus) {
								OrderItemAttributeDto orderItemAttributeDto = new OrderItemAttributeDto();
								orderItemAttributeDto.setAttributeName(itemsAttributeSkuDto.getAttributeValueName());
								if (itemsAttributeSkuDto.getValues() != null
										&& !itemsAttributeSkuDto.getValues().isEmpty()) {
									orderItemAttributeDto.setAttributeValueName(
											itemsAttributeSkuDto.getValues().get(0).getAttributeValueName());
								}
								orderItemAttributeDtoList.add(orderItemAttributeDto);
							}
						}
					}
					orderInfoDto.setOrderItemAttributeDtos(orderItemAttributeDtoList);
				}
				orderInfoDtos.add(orderInfoDto);
			}
			response.setResult(new Pager<OrderInfoDto>(pager.getTotal(), orderInfoDtos));
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl.find.qury.error", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.find.qury.error");
			return response;
		}
	}

	/**
	 *
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
			@Param("limitFlag") String limitFlag, @Param("") User user) {
		// todo flag区分tab
		// 获取用户ID
		String userId = user.getId();
		LocalDate endDate = LocalDate.now();
		LocalDate startDateMIn6 = endDate.minusMonths(6);
		// 构造返回值及参数
		Response<Pager<OrderMallManageDto>> response = new Response<Pager<OrderMallManageDto>>();
		PageInfo pageInfo = new PageInfo(pageNo, size);
		Map<String, Object> paramMap = Maps.newHashMap();
		checkArgument(StringUtils.isNotBlank(userId), "userId.can.not.be.empty");
		paramMap.put("createOper", userId);
		// 默认选择逻辑删除
		paramMap.put("delFlag", Contants.DEL_INTEGER_FLAG_0);
		// 商城默认不处理“虚拟商品”订单
		paramMap.put("goodsTypeFlag", Contants.SUB_ORDER_TYPE_01);
		// 非积分订单
		paramMap.put("ordertypeIdFlag", Contants.BUSINESS_TYPE_JF);
		// 判断商城是否查询6个月之前的数据
		if (StringUtils.isEmpty(limitFlag)) {
			paramMap.put("startTime", startDateMIn6.toString());
			paramMap.put("endTime", endDate.toString());
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
			List<OrderSubModel> orderSubModelList = new ArrayList<OrderSubModel>();
			List<String> mainIds = Lists.newArrayList();
			// 获取主订单
			if (StringUtils.isEmpty(limitFlag)) {
				pager = orderSubDao.findMainIdLikeByPage(paramMap, pageInfo.getOffset(), pageInfo.getLimit());
			} else {
				pager = tblOrderHistoryDao.findMainIdLikeByPage(paramMap, pageInfo.getOffset(), pageInfo.getLimit());
			}

			mainIds = pager.getData();
			if (mainIds == null || mainIds.isEmpty()) {
				return response;
			}
			List<OrderMallManageDto> orderMallManageDtos = Lists.newArrayList();
			// 获取主订单下子订单信息
			for (String orderMainId : mainIds) {
				OrderMallManageDto orderMallManageDto = new OrderMallManageDto();

				List<OrderSubModel> orderSubModels = Lists.newArrayList();
				List<OrderInfoDto> orderInfoDtos = Lists.newArrayList();
				OrderMainModel orderMainModel = new OrderMainModel();
				// 获取主订单信息
				if (StringUtils.isEmpty(limitFlag)) {
					orderMainModel = orderMainDao.findById(orderMainId);
				} else {
					TblOrdermainHistoryModel tblOrdermainHistoryModel = new TblOrdermainHistoryModel();
					tblOrdermainHistoryModel = tblOrdermainHistoryDao.findById(orderMainId);
					if (tblOrdermainHistoryModel == null) {
						response.setError("OrderServiceImpl.findMall.eroor.tblOrdermainHistoryModel.can.not.be.null");
						return response;
					}
					BeanMapper.copy(tblOrdermainHistoryModel, orderMainModel);
				}
				if (orderMainModel == null) {
					response.setError("OrderServiceImpl.findMall.eroor.orderMainModel.can.not.be.null");
					return response;
				}
				orderMallManageDto.setOrderMainModel(orderMainModel);
				// 获取子订单信息
				if (StringUtils.isEmpty(limitFlag)) {
					orderSubModels = orderSubDao.findByOrderMainId(orderMainId);
				} else {
					List<TblOrderHistoryModel> orderHistoryModels = Lists.newArrayList();
					orderHistoryModels = tblOrderHistoryDao.findByOrderMainId(orderMainId);
					for (TblOrderHistoryModel tblOrderHistoryModel : orderHistoryModels) {
						OrderSubModel orderSubModel = new OrderSubModel();
						BeanMapper.copy(tblOrderHistoryModel, orderSubModel);
						orderSubModels.add(orderSubModel);
					}
				}
				for (OrderSubModel orderSubModel : orderSubModels) {
					OrderInfoDto orderInfoDto = new OrderInfoDto();
					orderInfoDto.setOrderSubModel(orderSubModel);
					// 置订单是否使用优惠券及积分标识 true-使用
					orderInfoDto.makeBonusTotalFlag();
					orderInfoDto.makeVoucherFlag();
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
								|| Contants.SUB_ORDER_STATUS_0310.equals(orderSubModel.getCurStatusId())) {
							orderInfoDto.setOrderTransFlag(Boolean.TRUE);

						} else {
							orderInfoDto.setOrderTransFlag(Boolean.FALSE);
						}
					} else {
						orderInfoDto.setOrderTransFlag(Boolean.FALSE);
					}
					orderInfoDtos.add(orderInfoDto);
				}
				orderMallManageDto.setOrderInfoDtos(orderInfoDtos);
				orderMallManageDtos.add(orderMallManageDto);
			}
			response.setResult(new Pager<OrderMallManageDto>(pager.getTotal(), orderMallManageDtos));
			return response;

		} catch (Exception e) {
			log.error("OrderServiceImpl.findMall.qury.error", Throwables.getStackTraceAsString(e));
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
	public Response<OrderDetailDto> findOrderInfo(@Param("id") String orderId) {
		Response<OrderDetailDto> response = new Response<OrderDetailDto>();
		try {
			// 校验
			OrderDetailDto orderDetailDto = new OrderDetailDto();
			checkArgument(StringUtils.isNotBlank(orderId), "orderId.can.not.be.empty");
			// 获取子订单详情
			OrderSubModel orderSubModel = null;
			orderSubModel = orderSubDao.findById(orderId);
			if (orderSubModel == null) {
				response.setError("OrderServiceImpl.findOrderInfo.eroor.orderSubModel.can.not.be.null");
				return response;
			}
			// 校验主订单号
			String ordermainId = orderSubModel.getOrdermainId();
			checkArgument(StringUtils.isNotBlank(ordermainId), "ordermainId.can.not.be.empty");
			// 获取主订单收货人信息
			OrderMainModel orderMainModel = null;
			orderMainModel = orderMainDao.findById(ordermainId);
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
				Date time=new SimpleDateFormat("HHmmss").parse(orderSubModel.getBonusTrnTime());
				orderSubModel.setBonusTrnTime(new SimpleDateFormat("HH:mm:ss").format(time));
			}
			orderDetailDto.setOrderSubModel(orderSubModel);
			orderDetailDto.makeVoucherFlag();
			orderDetailDto.makeBonusTotalFlag();
			orderDetailDto.setOrderMainModel(orderMainModel);
			orderDetailDto.setOrderTransModel(orderTransModel);
			orderDetailDto.setOrderDoDetailModels(orderDoDetailModels);
			response.setResult(orderDetailDto);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl findOrderInfo.eroor", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.findOrderInfo.eroor");
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
		Map<String, Boolean> responseMap = new HashMap<>();
		try {
			if (map.isEmpty()) {
				response.setError("OrderService.updateOrder.eroor.paramMap.be.empty");
				return response;
			}
			String orderId = (String) map.get("orderId");
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
					response.setError("OrderService.cancelOrder.eroor.orderSubModel.be.null");
					return response;
				}
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
			// todo 待处理已过期
			case Contants.VENDOR_ORDER_UPDATE_TYPE_CODE_EXPIRED:
				// 已发码 当订单状态未发生改变时将"已发码"状态置为"已过期"状态
				// 供应商操作标识
				orderSubModel.setVendorOperFlag("1");
				paramMap.put("orderSubModel", orderSubModel);
				paramMap.put("targetCurStatusId", Contants.SUB_ORDER_STATUS_8888);
				paramMap.put("curStatusId", Contants.SUB_ORDER_STATUS_9999);
				paramMap.put("curStatusNm", Contants.SUB_ORDER_CODE_EXPIRED);
				response = updateSignVendor(paramMap);

				break;

			default:
				// 当订单状态都不是以上情况时默认出错
				response.setError("OrderService.updateOrder.eroor.curStatusId.be.wrong");
				return response;
			}
			return response;

		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderService updateOrder error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderService.updateOrder.error");
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
				response.setError("OrderService.updateOrderMall.eroor.paramMap.be.empty");
				return response;
			}
			String ordermainId = (String) paramMap.get("ordermainId");
			String id = (String) paramMap.get("id");
			// 校验订单ID
			checkArgument(StringUtils.isNotBlank(ordermainId), "ordermainId.can.not.be.empty");
			OrderMainModel orderMainModel = new OrderMainModel();
			orderMainModel = orderMainDao.findById(ordermainId);
			// 校验返回结果是否为空
			if (orderMainModel == null) {
				response.setError("OrderService.updateOrderMall.eroor.orderMainModel.be.null");
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
			orderMainModel.setModifyOper(id);
			orderMainManager.updateCancelOrder(orderMainModel);
			responseMap.put("result", Boolean.TRUE);
			response.setResult(responseMap);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderService updateOrderMall error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
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
			Boolean result = orderSubManager.updateSignVendor(orderSubModel, orderDoDetailModel);
			responseMap.put("result", result);
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
			checkArgument(StringUtils.isNotBlank(orderId), "orderId be empty");
			checkArgument(StringUtils.isNotBlank(userId), "Id be empty");
			OrderSubModel orderSubModel = new OrderSubModel();
			orderSubModel = orderSubDao.findById(orderId);
			// 校验返回结果是否为空
			if (orderSubModel == null) {
				response.setError("OrderService.updateOrder.eroor.orderSubModel.be.null");
				return response;
			}
			if (!(Contants.SUB_ORDER_STATUS_0308.equals(orderSubModel.getCurStatusId()))) {
				responseMap.put("result", Boolean.FALSE);
				response.setResult(responseMap);
				return response;
			}
			// 获取提醒次数 为空增添第一次提醒时间
			Integer remindeTimes = orderSubModel.getRemindeTimes();
			if (remindeTimes == null) {
				orderSubModel.setFirstRemindeTime(new Date());
				orderSubModel.setRemindeTimes(1);
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
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderService updateOrder error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderService.updateOrder.error");
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
	public Response<Map<String, Boolean>> deliverGoods(OrderTransModel orderTransModel, User user) {
		Response<Map<String, Boolean>> response = new Response<>();
		Map<String, Boolean> responseMap = new HashMap<>();
		try {
			if (orderTransModel == null) {
				response.setError("OrderService.deliverGoods.eroor.orderTransModel.be.empty");
				return response;
			}
			// 校验订单ID
			String orderId = orderTransModel.getOrderId();
			checkArgument(StringUtils.isNotBlank(orderId), "orderId.can.not.be.empty");
			OrderSubModel orderSubModel = orderSubDao.findById(orderId);
			if (orderSubModel == null) {
				response.setError("orderSubModel.be.null");
				return response;
			}
			if (!Contants.SUB_ORDER_STATUS_0308.equals(orderSubModel.getCurStatusId())) {
				response.setError("CurStatusId.be.changed");
				return response;
			}
			OrderTransModel orderTransModel1 = null;
			orderTransModel1 = orderTransDao.findByOrderId(orderId);
			if (orderTransModel1 != null) {
				responseMap.put("result", Boolean.FALSE);
				response.setResult(responseMap);
			}
			// 当该子订单不存在物流信息时，新增物流信息
			// 子订单号
			orderTransModel.setOrderId(orderId);
			// 创建时间
			orderTransModel.setCreateTime(new Date());
			// 发货时间
			orderTransModel.setDoTime(new Date());
			orderTransModel.setCreateOper(user.getName());
			// 逻辑删除标记 0：未删除 1：已删除
			orderTransModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);

			// 更新子订单表当前状态为已发货
			orderSubModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0309);
			orderSubModel.setCurStatusNm(Contants.SUB_ORDER_DELIVERED);
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
			orderDoDetailModel.setCreateOper(user.getName());
			// 处理用户
			orderDoDetailModel.setDoUserid(user.getName());
			// 用户类型（2：供应商）
			orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_2);
			// 逻辑删除标记 0：未删除 1：已删除
			orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);
			Boolean result = orderSubManager.update(orderSubModel, orderDoDetailModel, orderTransModel);
			responseMap.put("result", result);
			response.setResult(responseMap);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("OrderService.deliverGoods.error,error code: {}", Throwables.getStackTraceAsString(e));
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
		try {
			if (paramMap.isEmpty()) {
				response.setError("OrderService.revokeOrder.eroor.paramMap.be.empty");
				return response;
			}
			String orderId = paramMap.get("orderId");
			String typeFlag = paramMap.get("typeFlag");
			String vendorId = paramMap.get("vendorId");
			String userId = paramMap.get("userId");
			String season = paramMap.get("season");
			String supplement = paramMap.get("supplement");
			// 校验订单ID,供应商ID，区分标示
			checkArgument(StringUtils.isNotBlank(orderId), "orderId.can.not.be.empty");
			checkArgument(StringUtils.isNotBlank(typeFlag), "typeFlag.be.empty");
			checkArgument(StringUtils.isNotBlank(vendorId) || StringUtils.isNotBlank(userId),
					"vendorId.and.userId.be.empty");
			checkArgument(StringUtils.isNotBlank(season), "season.be.empty");
			OrderSubModel orderSubModel = new OrderSubModel();
			orderSubModel = orderSubDao.findById(orderId);
			// 校验返回结果是否为空
			if (orderSubModel == null) {
				response.setError("OrderService.revokeOrder.eroor.orderSubModel.be.null");
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
				response.setError("OrderService.updateOrder.eroor.typeFlag.be.wrong");
				return response;
			}
			return response;

		} catch (IllegalArgumentException e) {
			log.error("OrderService.updateOrder.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderService updateOrder error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderService.updateOrder.error");
			return response;
		}
	}

	@Override
	public Response<Map<String, Object>> returnOrderMall(Map<String, String> paramMap) {
		Response<Map<String, Object>> response = new Response<>();
		Map<String, Object> responseMap = new HashMap<>();
		try {
			if (paramMap.isEmpty()) {
				response.setError("OrderService.returnOrderMall.eroor.paramMap.be.empty");
				return response;
			}
			String orderId = paramMap.get("orderId");
			String typeFlag = paramMap.get("typeFlag");
			String userId = paramMap.get("userId");
			String season = paramMap.get("season");
			String supplement = paramMap.get("supplement");
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
					response.setError("OrderService.returnOrderMall.eroor.orderSubModel.be.null");
					return response;
				}
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
			responseMap.put("result", Boolean.TRUE);
			response.setResult(responseMap);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("OrderService.returnOrderMall.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderService returnOrderMall error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		}
	}

	@Override
	public Response<Map<String, Object>> revokeOrderMall(Map<String, String> paramMap) {
		Response<Map<String, Object>> response = new Response<>();
		Map<String, Object> responseMap = new HashMap<>();
		try {
			if (paramMap.isEmpty()) {
				response.setError("OrderService.revokeOrderMall.eroor.paramMap.be.empty");
				return response;
			}
			String orderId = paramMap.get("orderId");
			String typeFlag = paramMap.get("typeFlag");
			;
			String userId = paramMap.get("userId");
			String season = paramMap.get("season");
			String supplement = paramMap.get("supplement");
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
					response.setError("OrderService.revokeOrderMall.eroor.orderSubModel.be.null");
					return response;
				}
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
			orderSubManager.updateRevokeForMall(orderSubModel, orderDoDetailModel, orderRrturnTrackDetailModel);
			responseMap.put("result", Boolean.TRUE);
			response.setResult(responseMap);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("OrderService.revokeOrderMall.error,error code: {}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderService revokeOrderMall error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError(e.getMessage());
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
			Date nowTime = new Date();
			Date receiveTime = orderSubModel.getReceivedTime();
			Calendar calendar = Calendar.getInstance();
			int hour = calendar.get(Calendar.HOUR_OF_DAY);
			// 业务1800至2400不能点击退货
			if (Integer.valueOf(timeStart).intValue() <= hour && hour <= Integer.valueOf(timeEnd).intValue()) {
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
				response.setError("OrderService.findOrderTrans.eroor.orderTransModel.be.null");
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
			response.setError(e.getMessage());
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
	// todo 代码需要修改
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

	public Response<Map<String, PagePaymentReqDto>> createOrder(OrderCommitSubmitDto orderCommitSubmitDto,
			UserAccount selectedCardInfo, User user) {

		Response<Map<String, PagePaymentReqDto>> response = new Response<>();
		Map<String, PagePaymentReqDto> responseMap = Maps.newHashMap();
		try {
			checkArgument(orderCommitSubmitDto != null, "orderCommitSubmitDto can not be empty");
			// 选择的支付卡卡号
			String cardNo = orderCommitSubmitDto.getCardNo();
			checkArgument(!cardNo.isEmpty(), "cardNo can not be empty");
			// 卡号对应的卡片类型是信用卡还是借记卡
			String cardType = Contants.CARD_TYPE_Y;// 借记卡
			if (UserAccount.CardType.CREDIT_CARD.equals(selectedCardInfo.getCardType())) {
				cardType = Contants.CARD_TYPE_C;
			}

			// 1:借记卡２：信用卡
			String payType = orderCommitSubmitDto.getPayType();
			checkArgument(!payType.isEmpty(), "payType can not be empty");
			// 判断支付方式和所选卡号是否相符
			if (Contants.CART_PAY_TYPE_1.equals(payType)) {
				checkArgument(Contants.CARD_TYPE_Y.equals(cardType), "所选卡号和支付方式不符");
			}
			if (Contants.CART_PAY_TYPE_2.equals(payType)) {
				checkArgument(Contants.CARD_TYPE_C.equals(cardType), "所选卡号和支付方式不符");
			}

			List<OrderCommitInfoDto> orderCommitInfoDtoList = orderCommitSubmitDto.getOrderCommitInfoList();
			List<String> itemCodes = Lists.newArrayList();
			Integer totalNum = 0;
			Long jfTotalNum = 0L;
			Map<String, Integer> itemNumMap = Maps.newHashMap();
			Map<String, OrderCommitInfoDto> itemInfoMap = Maps.newHashMap();
			for (OrderCommitInfoDto orderCommitInfoDto : orderCommitInfoDtoList) {
				// 单品编码
				String itemCode = orderCommitInfoDto.getCode();
				itemCodes.add(itemCode);
				checkArgument(!itemCode.isEmpty(), "itemCode can not be empty");
				// 购买数量
				Integer num = orderCommitInfoDto.getItemCount();
				totalNum = totalNum + num;
				// jfTotalNum = jfTotalNum + num * orderCommitInfoDto.getJfCount();
				checkArgument(num > 0, "购买数量不能小于1");
				itemNumMap.put(itemCode, num);
				itemInfoMap.put(itemCode, orderCommitInfoDto);
				// 借记卡不支持优惠券和积分
				if (Contants.CARD_TYPE_Y.equals(cardType)) {
					checkArgument(
							orderCommitInfoDto.getJfCount() == null || orderCommitInfoDto.getJfCount().intValue() == 0,
							"借记卡不支持优惠券和积分");
					checkArgument(StringUtils.isBlank(orderCommitInfoDto.getVoucherId()), "借记卡不支持优惠券和积分");
				}
			}
			Response<List<ItemModel>> itemModelResult = itemService.findByCodes(itemCodes);
			List<ItemModel> itemModels = itemModelResult.getResult();
			checkArgument(itemModels.size() == orderCommitInfoDtoList.size(), "购买的商品发生了变化，请重新购买");
			List<String> goodsCodes = Lists.newArrayList();
			// 判断单品库存数
			BigDecimal totalPrice = new BigDecimal("0");
			// TODO:库存整体需要重新设计一下需要扣减库存
			for (ItemModel itemModel : itemModels) {
				goodsCodes.add(itemModel.getGoodsCode());
				checkArgument(itemModel.getStock() >= itemNumMap.get(itemModel.getCode()), "库存不够");
				totalPrice = totalPrice
						.add(itemModel.getPrice().multiply(new BigDecimal(itemNumMap.get(itemModel.getCode()))));
				itemModel.setStock(itemModel.getStock() - itemNumMap.get(itemModel.getCode()));
				itemModel.setModifyOper(user.getId());
			}
			Response<List<GoodsModel>> goodsModels = goodsService.findByCodes(goodsCodes);
			checkArgument(goodsModels.getResult().size() > 0, "购买的商品发生了变化，请重新购买");
			Map<String, GoodsModel> goodsInfo = Maps.newHashMap();
			List<String> vendorCodes = Lists.newArrayList();
			List<Long> productIds = Lists.newArrayList();
			String goodsType = goodsModels.getResult().get(0).getGoodsType();
			// 判断是否是实物，O2O商品
			if (Contants.SUB_ORDER_TYPE_00.equals(goodsType) || Contants.SUB_ORDER_TYPE_02.equals(goodsType)) {
				// 实物，O2O商品结算数量最大为99件
				checkArgument(totalNum <= 99, "购买总数量不能大于99");
			}
			// 根据卡号取得第三级卡产品编码
			// String cardLevel3 = "";
			// ACardCustToelectronbankModel aCardCustToelectronbankModel = aCardCustToelectronbankService
			// .findByCardNbr(cardNo);
			// if (aCardCustToelectronbankModel != null) {
			// cardLevel3 = aCardCustToelectronbankModel.getCardFormatNbr();
			// }
			// 判断商品是否在售
			for (GoodsModel goodsModel : goodsModels.getResult()) {
				// 商城的场合
				checkArgument(Contants.CHANNEL_MALL_02.equals(goodsModel.getChannelMall()), "购买的商品已经下架");
				// 如后台设置了该商品属性有第三级卡产品编码的限制，则需要校验
				// if (StringUtils.isNotBlank(goodsModel.getCards())) {
				// checkArgument(goodsModel.getCards().contains(cardLevel3), "尊敬的用户，您的卡片类型与本商品要求不符，请您核实！");
				// }
				goodsInfo.put(goodsModel.getCode(), goodsModel);
				vendorCodes.add(goodsModel.getVendorId());
				productIds.add(goodsModel.getProductId());
			}
			// 生成大订单和小订单
			OrderMainModel orderMainModel = new OrderMainModel();
			// 根据支付方式判断
			if (Contants.CART_PAY_TYPE_1.equals(payType)) {
				orderMainModel.setOrdertypeId(Contants.BUSINESS_TYPE_YG);// 业务类型idyg:广发商城(一期)jf:积分商城fq:广发商城(分期)
				orderMainModel.setOrdertypeNm(Contants.BUSINESS_TYPE_NM_YG);// 业务类型idyg:广发商城(一期)jf:积分商城fq:广发商城(分期)
			}
			if (Contants.CART_PAY_TYPE_2.equals(payType)) {
				orderMainModel.setOrdertypeId(Contants.BUSINESS_TYPE_FQ);// 业务类型idyg:广发商城(一期)jf:积分商城fq:广发商城(分期)
				orderMainModel.setOrdertypeNm(Contants.BUSINESS_TYPE_NM_FQ);// 业务类型idyg:广发商城(一期)jf:积分商城fq:广发商城(分期)
			}
			orderMainModel.setCardno(cardNo);// 卡号
			orderMainModel.setSourceId(Contants.ORDER_SOURCE_ID_MALL);// 订单来源渠道id00: 商城01: callcenter02: ivr渠道03: 手机商城
			orderMainModel.setSourceNm(Contants.ORDER_SOURCE_NM_MALL);
			orderMainModel.setTotalNum(totalNum);// 商品总数量
			orderMainModel.setTotalPrice(totalPrice);// 商品总价格
			orderMainModel.setTotalBonus(jfTotalNum);// 商品总积分数量
			// 活动优惠总额
			// 积分抵扣总额
			// 优惠券使用总额
			// total_bonus,promot_discount,bonus_discount,voucher_discount
			orderMainModel.setLockedFlag("0");
			orderMainModel.setPaymentAmount(totalPrice);// 支付总金额
			if (orderMainModel.getPaymentAmount().compareTo(new BigDecimal(0)) > 0) {
				orderMainModel.setIsInvoice(orderCommitSubmitDto.getIsInvoice());// 是否开发票0-否，1-是
				orderMainModel.setInvoice(orderCommitSubmitDto.getInvoice());// 发票抬头
			}
			orderMainModel.setOrdermainDesc(orderCommitSubmitDto.getOrdermainDesc());// 订单主表备注
			// todo:tbl_esp_cust_inf
			orderMainModel.setContIdType(user.getCertType());// 订货人证件类型
			orderMainModel.setContIdcard(user.getCertNo());// 订货人证件号码
			orderMainModel.setContNm(user.getName());// 订货人姓名
			orderMainModel.setContNmPy("");// 订货人姓名拼音
			orderMainModel.setContPostcode(user.getZipCode());// 订货人邮政编码
			orderMainModel.setContAddress(user.getAddress());// 订货人详细地址
			orderMainModel.setContMobPhone(user.getMobile());// 订货人手机
			orderMainModel.setContHphone(user.getPhoneNo());// 订货人家里电话

			orderMainModel.setMerId(merchId);// 大商户号
			orderMainModel.setCommDate(DateHelper.getyyyyMMdd());// 业务日期
			orderMainModel.setCommTime(DateHelper.getHHmmss());// 业务时间

			orderMainModel.setCustSex(user.getSex());// 性别
			orderMainModel.setCustEmail(user.getEmail());
			orderMainModel.setEUpdateStatus("0");// 插入订单状态更新接口标志位 0:初始化 1：更新成功 2：更新失败

			// 有收货地址的场合（实物，实物＋Ｏ２Ｏ）
			if (Contants.SUB_ORDER_TYPE_00.equals(goodsType)) {
				checkArgument(orderCommitSubmitDto.getAddressId() != null, "请选择送货地址");
				orderMainModel.setBpCustGrp(orderCommitSubmitDto.getBpCustGrp());// 送货时间01: 工作日、双休日与假日均可送货02:
				// 只有工作日送货（双休日、假日不用送）03:
				// 只有双休日、假日送货（工作日不用送货）
				Response<MemberAddressModel> memberAddressResult = memberAddressService
						.findById(orderCommitSubmitDto.getAddressId());
				checkArgument(memberAddressResult.isSuccess(), "收货地址发生变化请重新选择");
				MemberAddressModel memberAddressModel = memberAddressResult.getResult();
				orderMainModel.setCsgName(memberAddressModel.getConsignee());// 收货人姓名
				orderMainModel.setCsgPostcode(memberAddressModel.getPostcode());// 收货人邮政编码
				orderMainModel.setCsgAddress(memberAddressModel.getAddress());// 收货人详细地址
				orderMainModel.setCsgPhone1(memberAddressModel.getMobile());// 收货人电话一
				orderMainModel.setCsgPhone2(memberAddressModel.getTelephone());// 收货人电话二
				orderMainModel.setCsgProvince(memberAddressModel.getProvinceName());// 省
				orderMainModel.setCsgCity(memberAddressModel.getCityName());// 市
				orderMainModel.setCsgBorough(memberAddressModel.getAreaName());// 区
				orderMainModel.setAcctAddFlag("1");// 收货地址是否是帐单地址0-否1-是
			} else {
				if (Contants.SUB_ORDER_TYPE_02.equals(goodsType)) {
					orderMainModel.setCsgName(orderCommitSubmitDto.getUserName());// 客户姓名
					orderMainModel.setCsgPhone1(orderCommitSubmitDto.getPhoneNo());// 收码电话
				}
			}
			orderMainModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0301);// 当前状态代码0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
			orderMainModel.setCurStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);// 当前状态代码0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
			orderMainModel.setCreateOper(user.getId());// 创建操作员id
			orderMainModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);// 逻辑删除标记为(0未删除，1已删除)
			// 数据库不为空项
			orderMainModel.setPermLimit(new BigDecimal(0));
			orderMainModel.setCashLimit(new BigDecimal(0));
			orderMainModel.setStagesLimit(new BigDecimal(0));

			// 取得供应商简称
			Response<List<VendorInfoModel>> vendorInfoModelList = vendorService.findByVendorIds(vendorCodes);
			Map<String, VendorInfoModel> vendorInfo = Maps.newHashMap();
			for (VendorInfoModel vendorInfoModel : vendorInfoModelList.getResult()) {
				vendorInfo.put(vendorInfoModel.getVendorId(), vendorInfoModel);
			}
			// 取得产品属性
			Response<List<ProductModel>> productModelList = productService.findByIds(productIds);
			Map<Long, ProductModel> productInfo = Maps.newHashMap();
			for (ProductModel productModel : productModelList.getResult()) {
				productInfo.put(productModel.getId(), productModel);
			}
			List<OrderSubModel> orderSubModelList = Lists.newArrayList();
			List<OrderGoodsDetailModel> orderGoodsDetailModelList = Lists.newArrayList();
			List<OrderDoDetailModel> orderDoDetailModelList = Lists.newArrayList();
			if (!Contants.BUSINESS_TYPE_JF.equals(orderMainModel.getOrdertypeId())) {
				for (ItemModel itemModel : itemModels) {
					OrderSubModel orderSubModel = new OrderSubModel();
					orderSubModel.setOperSeq(new Integer(0));
					orderSubModel.setOrdertypeId(orderMainModel.getOrdertypeId());// 业务类型代码YG:广发商城(一期)JF:积分商城FQ:广发商城(分期)
					orderSubModel.setOrdertypeNm(orderMainModel.getOrdertypeNm());// 业务类型名称
					String stagesNum = StringUtils.isBlank(itemInfoMap.get(itemModel.getCode()).getInstalments()) ? "1"
							: itemInfoMap.get(itemModel.getCode()).getInstalments();
					// todo:取得商品支付编码
					if (Contants.BUSINESS_TYPE_FQ.equals(orderSubModel.getOrdertypeId())) {
						HashMap queryMap = Maps.newHashMap();
						queryMap.put("itemCode", itemModel.getCode());
						queryMap.put("stagesCode", stagesNum);
						Response<TblGoodsPaywayModel> tblGoodsPaywayResult = goodsPayWayService
								.findByItemCodeAndStagesCode(queryMap);
						checkArgument(tblGoodsPaywayResult.isSuccess(), "商品支付方式发生变化请重新提交");
						TblGoodsPaywayModel tblGoodsPaywayModel = tblGoodsPaywayResult.getResult();
						orderSubModel.setGoodsPaywayId(tblGoodsPaywayModel.getGoodsPaywayId());// 商品支付编码
						orderSubModel.setSpecShopno(tblGoodsPaywayModel.getCategoryNo());// 邮购分期类别码
					}
					orderSubModel.setPaywayCode("0001");// 支付方式代码0001: 现金0002: 积分0003: 积分+现金0004:
					// 手续费0005: 现金+手续费0006: 积分+手续费0007:
					// 积分+现金+手续费
					orderSubModel.setPaywayNm("现金");// 支付方式代码0001: 现金0002: 积分0003: 积分+现金0004: 手续费0005:
					// 现金+手续费0006: 积分+手续费0007: 积分+现金+手续费
					// 商品代码
					orderSubModel.setCalMoney(new BigDecimal(0));// 清算总金额

					orderSubModel.setCardno(cardNo);// 卡号
					GoodsModel goodsModel = goodsInfo.get(itemModel.getGoodsCode());
					String vendorId = goodsModel.getVendorId();
					orderSubModel.setVendorId(vendorId);// 供应商代码
					orderSubModel.setVendorSnm(vendorInfo.get(vendorId).getSimpleName());// 供应商简称
					orderSubModel.setSourceId(orderMainModel.getSourceId());// 渠道代码00: 商城01: CallCenter02: IVR渠道03:
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

					// orderSubModel.setPayType("");// 佣金代码
					orderSubModel.setPayTypeNm("");// 佣金代码名称
					orderSubModel.setIncCode("");// 手续费率代码
					orderSubModel.setIncCodeNm("");// 手续费名称
					orderSubModel.setStagesNum(Integer.valueOf(stagesNum));// 现金[或积分]分期数
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
					orderSubModel.setIncTakePrice(new BigDecimal(0));// 退单时收取指定金额手续费
					orderSubModel.setVoucherPrice(new BigDecimal(0));// 优惠金额
					orderSubModel.setCreditFlag("");// 授权额度不足处理方式
					orderSubModel.setCalWay("");// 退货方式
					orderSubModel.setLockedFlag("0");// 订单锁标记
					orderSubModel.setVendorOperFlag("0");// 供应商操作标记
					orderSubModel.setCurStatusId(orderMainModel.getCurStatusId());// 当前状态代码
					orderSubModel.setCurStatusNm(orderMainModel.getCurStatusNm());// 当前状态名称
					orderSubModel.setCreateOper(orderMainModel.getCreateOper());// 创建操作员id

					// todo:数据库非必输字段
					orderSubModel.setTypeId("");// 商品类别ID
					orderSubModel.setLevelNm("");// 商品类别名称
					orderSubModel.setGoodsBrand("");// 品牌
					orderSubModel.setGoodsModel("");// 型号
					orderSubModel.setGoodsColor("");// 商品颜色

					// todo:
					orderSubModel.setActType("");// 活动类型

					orderSubModel.setMerId(vendorInfo.get(vendorId).getMerId());// 商户号
					orderSubModel.setReserved1(vendorInfo.get(vendorId).getUnionPayNo());// 保存银联商户号
					// hwh 20160217 增加属性一二
					orderSubModel.setGoodsAttr1(itemModel.getAttribute());// 销售属性（json串）
					orderSubModel.setGoodsAttr2("");
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
					String custCartId = "";
					if (Contants.CART_PAY_TYPE_1.equals(payType)) {
						custCartId = itemModel.getCode() + ":" + Contants.CART_PAY_TYPE_1;
					} else if (Contants.CART_PAY_TYPE_2.equals(payType)) {
						custCartId = itemModel.getCode() + ":" + Contants.CART_PAY_TYPE_2;
					}
					orderSubModel.setCustCartId(custCartId);// 此订单对应的购物车id
					// String miaoshaFlag = node.valueOf("@miaosha_flag");
					// String miaoshaAction = node.valueOf("@miaosha_action");
					// if(!"".equals(miaoshaFlag) && miaoshaFlag != null && "1".equals(miaoshaFlag)){//0元秒杀商品
					// log.info("0元秒杀商品,小订单保存miaoshaAction=" + miaoshaAction);
					// orderSubModel.setMiaosha_action_flag(Integer.valueOf(miaoshaAction));
					// }else{
					// todo:
					orderSubModel.setMiaoshaActionFlag(new Integer(0));
					// }
					// if(miaoshaFlag!=null&&!"".equals(miaoshaFlag)&&"2".equals(miaoshaFlag)){
					// orderSubModel.setMiaosha_action_flag(Integer.valueOf(9999));//标志第三方0元秒杀的订单
					// }

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

					// OrderGoodsDetailModel orderGoodsDetailModel = new OrderGoodsDetailModel();
					// orderGoodsDetailModel.setGoodsCode(itemModel.getGoodsCode());// 商品编码
					// orderGoodsDetailModel.setGoodsName(goodsModel.getName());// 商品名称
					// orderGoodsDetailModel.setItemCode(itemModel.getCode());// 单品编码
					// orderGoodsDetailModel.setItemPrice(itemModel.getPrice());// 商城价格
					// orderGoodsDetailModel.setItemMarketPrice(itemModel.getMarketPrice());// 市场价格
					// orderGoodsDetailModel.setItemNum(1);// 单品数量
					// orderGoodsDetailModel.setItemSmallPic(itemModel.getImage1());// 单品小图标
					// orderGoodsDetailModel.setO2oCode(itemModel.getO2oCode());// o2o商品编码
					// orderGoodsDetailModel.setO2oVoucherCode(itemModel.getO2oVoucherCode());// o2o商品兑换码
					// orderGoodsDetailModel.setInstallmentPrice(itemModel.getPrice()
					// .divide(new BigDecimal(orderSubModel.getStagesNum()), 2, BigDecimal.ROUND_DOWN));// 分期价格
					// orderGoodsDetailModel.setInstallmentNum(orderSubModel.getStagesNum());// 分期数
					// orderGoodsDetailModel.setMainImage(itemModel.getImage1());// 主图片
					// orderGoodsDetailModel.setProductAttrs(productInfo.get(goodsModel.getProductId()).getAttribute());//
					// 产品属性（json）
					//
					// orderGoodsDetailModel.setFreightSize(goodsModel.getFreightSize());// 商品体积
					// orderGoodsDetailModel.setFreightWeight(goodsModel.getFreightWeight());// 商品重量
					// orderGoodsDetailModel.setItemImage1(itemModel.getImage1());//
					// orderGoodsDetailModel.setItemImage2(itemModel.getImage2());//
					// orderGoodsDetailModel.setItemImage3(itemModel.getImage3());//
					// orderGoodsDetailModel.setItemImage4(itemModel.getImage4());//
					// orderGoodsDetailModel.setItemImage5(itemModel.getImage5());//
					//
					// orderGoodsDetailModel.setBrandId(goodsModel.getGoodsBrandId());// 品牌id
					// orderGoodsDetailModel.setBackCategory1Id(goodsModel.getBackCategory1Id());// 一级后台类目
					// orderGoodsDetailModel.setBackCategory2Id(goodsModel.getBackCategory2Id());// 二级后台类目
					// orderGoodsDetailModel.setBackCategory3Id(goodsModel.getBackCategory3Id());// 三级后台类目
					// orderGoodsDetailModel.setPromotionTitle(goodsModel.getPromotionTitle());// 营销语
					// orderGoodsDetailModel.setSaleChannel(orderMainModel.getSourceId());// 销售渠道
					// orderGoodsDetailModel.setInnerFlag(goodsModel.getIsInner());// 是否内宣商品
					// orderGoodsDetailModel.setStageNumber(goodsModel.getInstallmentNumber());// 最高期数
					// orderGoodsDetailModel.setMailOrderCode(goodsModel.getMailOrderCode());// 邮购分期类别码
					// orderGoodsDetailModel.setAdWord(goodsModel.getAdWord());// 商品卖点
					// orderGoodsDetailModel.setGiftWord(goodsModel.getGiftDesc());// 赠品信息
					// orderGoodsDetailModel.setIntroduction(goodsModel.getIntroduction());// 商品描述
					// orderGoodsDetailModel.setServiceType(goodsModel.getServiceType());// 服务承诺
					// orderGoodsDetailModel.setBuyLimit(goodsModel.getLimitCount());// 限购数量
					// orderGoodsDetailModel.setCreateOper(user.getId());// 创建人
					// orderGoodsDetailModel.setDelFlag(Contants.DEL_FLAG_0);// 逻辑删除标志0未删1已删
					// orderGoodsDetailModel.setItemAttrs(itemModel.getAttribute());// 销售属性（json）

					for (int i = 0; i < itemNumMap.get(itemModel.getCode()); i++) {
						String voucher_no = "";
						String voucher_nm = "";
						String voucher_price = "";
						if (i == 0) {// 同一个商品中优惠券只放在第一个小订单
							// voucher_no = StringUtil.dealNull(node.valueOf("@privilegeId"));//优惠券ID
							// voucher_nm = StringUtil.dealNull(node.valueOf("@privilegeName"));//优惠券名称
							// voucher_price = StringUtil.dealNull(node.valueOf("@privilegeMoney"));//优惠券价格
							voucher_no = "";
							voucher_nm = "";
							voucher_price = "";
						}
						orderSubModel.setVoucherNo(voucher_no);
						orderSubModel.setVoucherNm(voucher_nm);
						BigDecimal totMoney = itemModel.getPrice();
						BigDecimal singleMoney = itemModel.getPrice();
						BigDecimal perStage = itemInfoMap.get(itemModel.getCode()).getInstalmentsPrice();
						if (!"".equals(voucher_no) && !"".equals(voucher_price)) {
							totMoney = totMoney.subtract(new BigDecimal(voucher_price));// 单价需要减去优惠券
							singleMoney = singleMoney.subtract(new BigDecimal(voucher_price));// 单价需要减去优惠券
							perStage = totMoney.divide(new BigDecimal(orderSubModel.getStagesNum()), 2,
									BigDecimal.ROUND_DOWN);
							log.info("减去优惠券的小订单总价：" + totMoney + "分期价：" + perStage);
						}
						orderSubModel.setTotalMoney(totMoney);// 现金总金额
						orderSubModel.setSinglePrice(singleMoney);// 单价
						orderSubModel.setInstallmentPrice(perStage);// 分期价格
						orderSubModel.setIncTakePrice(perStage);// 退单时收取指定金额手续费(未用)
						String discountPoint = "";// StringUtil.dealNull(node.valueOf("@single_bonus"));//抵扣积分
						String discountMoney = "";// StringUtil.dealNull(node.valueOf("@discount"));//积分抵扣金额
						String pointType = "";// StringUtil.dealNull(node.valueOf("@point_type"));//积分类型
						orderSubModel.setIntegraltypeId(pointType);// 只有普通积分参与积分扣减

						if (!"".equals(voucher_price)) {
							orderSubModel.setVoucherPrice(new BigDecimal(voucher_price));// 优惠券金额
						}
						if (!"".equals(discountMoney)) {
							orderSubModel.setUitdrtamt(new BigDecimal(discountMoney));
						}
						if ("".equals(discountPoint)) {
							discountPoint = "0";
						}
						orderSubModel.setSingleBonus(Long.valueOf(discountPoint));
						orderSubModel.setBonusTotalvalue(Long.valueOf(discountPoint));

						OrderSubModel orderSubModelNew = new OrderSubModel();
						BeanUtils.copyProperties(orderSubModel, orderSubModelNew);
						orderSubModelList.add(orderSubModelNew);

						// orderGoodsDetailModelList.add(orderGoodsDetailModel);

						// todo 插入订单明细 bug19408
						OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
						orderDoDetailModel.setDoTime(new Date());
						orderDoDetailModel.setDoUserid(user.getId());// 处理用户
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
			orderMainManager.createOrder(orderMainModel, orderSubModelList, orderGoodsDetailModelList,
					orderDoDetailModelList, itemModels);

			if (orderCommitSubmitDto.getAddressId() != null) {
				memberAddressService.setDefaultNotExists(orderCommitSubmitDto.getAddressId(), user.getCustId());
			}
			// TODO:从购物车跳转过来的订单，订单生成成功后删除购物车中对应记录
			List<String> itemKeys = Lists.newArrayList();
			for (OrderSubModel orderSubModel : orderSubModelList) {
				itemKeys.add(orderSubModel.getCustCartId());
			}
			cartService.batchDeletePermanent(user.getId(), itemKeys);

			PagePaymentReqDto pagePaymentReqDto = new PagePaymentReqDto();
			getReturnObjForPay(pagePaymentReqDto, orderMainModel, orderSubModelList);
			responseMap.put("result", pagePaymentReqDto);
			response.setResult(responseMap);
			return response;
		} catch (IllegalArgumentException e) {
			log.error("OrderService createOrder error,error code: {}", Throwables.getStackTraceAsString(e));
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
			orderMainDao.update(orderMainModel);
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
	 * 支付结果更新
	 *
	 * @param paymentResults 支付结果
	 * @return
	 */

	public Response<Map<String, Boolean>> updatePaymentResult(List<Map<String, Object>> paymentResults, User user) {
		Response<Map<String, Boolean>> response = new Response<>();
		Map<String, Boolean> responseMap = Maps.newHashMap();
		try {
			if (paymentResults.isEmpty()) {
				response.setError("OrderService.updatePaymentResult.error.map.be.empty");
				return response;
			}
			List<OrderSubModel> orderSubModelList = Lists.newArrayList();
			List<OrderDoDetailModel> orderDoDetailModelList = Lists.newArrayList();
			for (Map<String, Object> paymentResult : paymentResults) {
				String orderId = (String) paymentResult.get("orderId");
				String statusId = (String) paymentResult.get("statusId");

				OrderSubModel orderSubModel = orderSubDao.findById(orderId);
				// 校验返回结果是否为空
				if (orderSubModel == null) {
					response.setError("OrderService.updatePaymentResult.error.orderSubModel.be.null");
					return response;
				}
				// 校验订单状态是否正确
				if (!(Contants.SUB_ORDER_STATUS_0301.equals(orderSubModel.getGoodsType())
						|| Contants.SUB_ORDER_STATUS_0316.equals(orderSubModel.getGoodsType())
						|| Contants.SUB_ORDER_STATUS_0308.equals(orderSubModel.getGoodsType())
						|| Contants.SUB_ORDER_STATUS_0307.equals(orderSubModel.getGoodsType())
						|| Contants.SUB_ORDER_STATUS_0305.equals(orderSubModel.getGoodsType()))) {
					response.setError("OrderService.updatePaymentResult.error.goodsType.be.wrong");
					return response;
				}
				// 更新人ID
				orderSubModel.setModifyOper(user.getId());
				// TODO:假定０失败１成功２处理中 空状态未明
				switch (statusId) {
				case "1":
					orderSubModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0308);
					orderSubModel.setCurStatusNm(Contants.SUB_ORDER_PAYMENT_SUCCEED);
					break;
				case "0":
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
			log.error("OrderService.updatePaymentResult.error,error code: {}", Throwables.getStackTraceAsString(e));
			throw new ResponseException(Contants.ERROR_CODE_500, e.getMessage());
		} catch (Exception e) {
			log.error("OrderService updatePaymentResult error,cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("OrderService.updatePaymentResult.error");
			return response;
		}

	}

	/**
	 * 提交订单画面初期显示
	 *
	 * @param itemKeys 购物车中对应的单品情报key
	 * @return
	 */
	@Override
	public Response<Map<String, Object>> findOrderInfoForCommitOrder(@Param("itemKeys") String itemKeys,
			@Param("user") User user) {
		// 构造返回值及参数
		Response<Map<String, Object>> response = new Response<>();
		Map<String, Object> result = Maps.newHashMap();
		List<OrderCommitInfoDto> resultList = Lists.newArrayList();
		try {
			if (StringUtils.isEmpty(itemKeys)) {
				throw new IllegalArgumentException("没有选择单品");
			}
			List<String> itemCodes = Lists.newArrayList();
			String[] itemKeyList = null;
			// 购物车跳转到提交订单画面
			String payType = null;
			if (StringUtils.isNotEmpty(itemKeys)) {
				itemKeyList = itemKeys.split(",");
				for (String itemKey : itemKeyList) {
					itemCodes.add(itemKey.substring(0, itemKey.indexOf(":")));
				}
				payType = itemKeyList[0].substring(itemKeyList[0].indexOf(":") + 1, itemKeyList[0].length());
			}

			Response<List<ItemModel>> itemModelListResult = itemService.findByCodes(itemCodes);
			List<ItemModel> itemModelList = itemModelListResult.getResult();
			if (itemCodes.size() != itemModelList.size()) {
				throw new IllegalArgumentException("存在失效单品");
			}
			Map<String, ItemModel> itemInfoMap = Maps.newHashMap();
			List<String> goodsCodes = Lists.newArrayList();
			for (ItemModel itemModel : itemModelList) {
				itemInfoMap.put(itemModel.getCode(), itemModel);
				goodsCodes.add(itemModel.getGoodsCode());
			}
			// 商品类型
			boolean isMaterial = false;
			String goodsType = Contants.SUB_ORDER_TYPE_00;
			Response<List<GoodsModel>> goodsModels = goodsService.findByCodes(goodsCodes);
			Map<String, String> goodsNameMap = Maps.newHashMap();
			for (GoodsModel goodsModel : goodsModels.getResult()) {
				goodsNameMap.put(goodsModel.getCode(), goodsModel.getName());
				goodsType = goodsModel.getGoodsType();
				if (Contants.SUB_ORDER_TYPE_00.equals(goodsModel.getGoodsType())) {
					isMaterial = true;
				}
			}
			if (isMaterial) {
				result.put("goodsType", Contants.SUB_ORDER_TYPE_00);
			} else {
				result.put("goodsType", goodsType);
				result.put("userName", user.getName());
				result.put("phoneNo", user.getMobile());
			}
			// 取得购物车中内容
			Response<Map<String, String>> cartResult = cartService.getMapPermanent(user);
			Map scaleMap = null;
			if (Contants.CART_PAY_TYPE_2.equals(payType)) {
				scaleMap = pointRelatedService.getBestPointScale(true, user);
			}
			BigDecimal total = new BigDecimal(0);// 订单总额
			BigDecimal realPayment = new BigDecimal(0);// 实付款
			for (int i = 0; i < itemModelList.size(); i++) {
				ItemModel itemModel = itemModelList.get(i);
				OrderCommitInfoDto orderCommitInfoDto = new OrderCommitInfoDto();
				String itemInfo = cartResult.getResult().get(itemKeyList[i]);
				CartDto cartDto = jsonMapper.fromJson(itemInfo, CartDto.class);
				payType = cartDto.getPayType();
				BeanMapper.copy(itemInfoMap.get(cartDto.getItemCode()), orderCommitInfoDto);
				orderCommitInfoDto.setInstalments(
						StringUtils.isBlank(cartDto.getInstalments()) || "null".equals(cartDto.getInstalments()) ? "1"
								: cartDto.getInstalments());
				orderCommitInfoDto.setItemCount(cartDto.getItemCount());
				ItemsAttributeDto itemsAttributeDto = JsonMapper.JSON_NON_DEFAULT_MAPPER
						.fromJson(itemModel.getAttribute(), ItemsAttributeDto.class);
				if (itemsAttributeDto != null) {
					List<OrderItemAttributeDto> itemAttributeDtoList = Lists.newArrayList();
					for (ItemsAttributeSkuDto itemsAttributeSkuDto : itemsAttributeDto.getSkus()) {
						OrderItemAttributeDto itemAttributeDto = new OrderItemAttributeDto();
						itemAttributeDto.setAttributeKey(itemsAttributeSkuDto.getAttributeValueKey());
						itemAttributeDto.setAttributeName(itemsAttributeSkuDto.getAttributeValueName());
						itemAttributeDto
								.setAttributeValueKey(itemsAttributeSkuDto.getValues().get(0).getAttributeValueKey());
						itemAttributeDto
								.setAttributeValueName(itemsAttributeSkuDto.getValues().get(0).getAttributeValueName());
						itemAttributeDtoList.add(itemAttributeDto);
					}
					orderCommitInfoDto.setItemAttributeDtoList(itemAttributeDtoList);
				}

				// TODO:分期价格计算
				if (Contants.CART_PAY_TYPE_1.equals(payType)) {
					orderCommitInfoDto.setInstalmentsPrice(orderCommitInfoDto.getPrice());
				} else if (Contants.CART_PAY_TYPE_2.equals(payType)) {
					orderCommitInfoDto.setInstalmentsPrice(orderCommitInfoDto.getPrice()
							.divide(new BigDecimal(cartDto.getInstalments()), 2, BigDecimal.ROUND_HALF_UP));
				}
				// 小计
				orderCommitInfoDto.setSubTotal(
						orderCommitInfoDto.getPrice().multiply(new BigDecimal(orderCommitInfoDto.getItemCount())));
				// 订单总额
				total = total.add(orderCommitInfoDto.getSubTotal());
				// 商品名称
				orderCommitInfoDto.setGoodsName(goodsNameMap.get(itemModel.getGoodsCode()));
				// 积分
				// 积分总额
				// 优惠券
				resultList.add(orderCommitInfoDto);
			}
			result.put("itemInfoList", resultList);
			// 实付款等于订单总额减去扣减值
			realPayment = total;
			result.put("payType", payType);
			result.put("total", total);
			result.put("realPayment", realPayment);
			// 可选择卡号和对应积分兑换比例
			// HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes())
			// .getRequest();
			// HashMap loginInfo = (HashMap) request.getSession().getAttribute(user.getId());
			// List<HashMap> loginCardInfoObj = (List) loginInfo.get("loginCardInfos");
			// if (loginInfo == null || loginCardInfoObj == null) {
			// throw new IllegalArgumentException("user's card not exists in session");
			// }

			List<HashMap> cardNos = Lists.newArrayList();
			KeyReader keyReader = new KeyReader();
			for (UserAccount userAccount : user.getAccountList()) {
				HashMap cardInfo = Maps.newHashMap();
				String cardNo = userAccount.getCardNo();
				// 信用卡支付的场合
				if (Contants.CART_PAY_TYPE_2.equals(payType)
						&& UserAccount.CardType.CREDIT_CARD.equals(userAccount.getCardType())) {
					String cardSign = SignUtil.sign(cardNo, keyReader.readPrivateKey(SignManager.DEFAULT_RSA_PRI_KEY,
							true, SignManager.RSA_ALGORITHM_NAME));
					cardInfo.put("key", cardSign);
					cardInfo.put("value", StringHelper.maskCardNo(cardNo));
					cardNos.add(cardInfo);
				}
				// 借记卡支付的场合
				if (Contants.CART_PAY_TYPE_1.equals(payType)
						&& !UserAccount.CardType.CREDIT_CARD.equals(userAccount.getCardType())) {
					String cardSign = SignUtil.sign(cardNo, keyReader.readPrivateKey(SignManager.DEFAULT_RSA_PRI_KEY,
							true, SignManager.RSA_ALGORITHM_NAME));
					cardInfo.put("key", cardSign);
					cardInfo.put("value", StringHelper.maskCardNo(cardNo));
					cardNos.add(cardInfo);
				}
			}
			result.put("cardNos", cardNos);
			response.setResult(result);
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl findOrderInfo query error", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.findOrderInfo.query.error");
			return response;
		}
	}

	/***
	 *
	 * @param itemCode
	 * @param orderMainId
	 * @param user
	 * @return
	 * @throws Exception
	 */
	@Override
	public Response<Map<String, Boolean>> createTieinSaleOrder(String itemCode, String orderMainId, User user)
			throws Exception {
		Map<String, Boolean> responseMap = Maps.newHashMap();
		Response<Map<String, Boolean>> response = new Response<>();
		try {
			checkArgument(StringUtils.isNotBlank(itemCode), "itemCode.can.not.be.empty");
			checkArgument(StringUtils.isNotBlank(orderMainId), "orderMainId.can.not.be.empty");
			OrderMainModel orderMainModel = orderMainDao.findById(orderMainId);
			// 选择的支付卡卡号
			String cardNo = orderMainModel.getCardno();
			checkArgument(StringUtils.isNotBlank(cardNo), "cardNo.can.not.be.empty");
			String orderTypeId = orderMainModel.getOrdertypeId();
			// 购买数量
			Integer num = 1;
			ItemModel itemModel = itemService.findById(itemCode);
			String goodsCode = itemModel.getGoodsCode();
			checkArgument(itemModel.getStock() >= num, "stock.be.not.enough");
			BigDecimal totalPrice = new BigDecimal("0");
			totalPrice = totalPrice.add(itemModel.getPrice().multiply(new BigDecimal(num)));
			itemModel.setStock(itemModel.getStock() - num);
			itemModel.setModifyOper(user.getVendorId());
			GoodsModel goodsModel = goodsService.findById(goodsCode).getResult();
			List<String> vendorCodes = Lists.newArrayList();
			List<Long> productIds = Lists.newArrayList();
			String goodsType = goodsModel.getGoodsType();
			// 判断是否是实物，O2O商品
			if (Contants.SUB_ORDER_TYPE_00.equals(goodsType) || Contants.SUB_ORDER_TYPE_02.equals(goodsType)) {
				// 实物，O2O商品结算数量最大为99件 重新计算订单数
				checkArgument(orderMainModel.getTotalNum() + num <= 99, "rderSub.number.be.over");
			}
			// 判断商品是否在售
			checkArgument(Contants.CHANNEL_MALL_02.equals(goodsModel.getChannelMall()), "goods.be.undercarriage");

			vendorCodes.add(user.getVendorId());
			productIds.add(goodsModel.getProductId());
			Response<List<VendorInfoModel>> vendorInfoModelList = vendorService.findByVendorIds(vendorCodes);
			Map<String, VendorInfoModel> vendorInfo = Maps.newHashMap();
			for (VendorInfoModel vendorInfoModel : vendorInfoModelList.getResult()) {
				vendorInfo.put(vendorInfoModel.getVendorId(), vendorInfoModel);
			}
			// 取得产品属性
			Response<List<ProductModel>> productModelList = productService.findByIds(productIds);
			Map<Long, ProductModel> productInfo = Maps.newHashMap();
			for (ProductModel productModel : productModelList.getResult()) {
				productInfo.put(productModel.getId(), productModel);
			}

			orderMainModel.setTotalNum(orderMainModel.getTotalNum() + num);
			orderMainModel.setTotalPrice(orderMainModel.getTotalPrice().add(totalPrice));
			orderMainModel.setModifyOper(user.getVendorId());
			OrderSubModel orderSubModel = new OrderSubModel();
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
			orderSubModel.setVendorSnm(vendorInfo.get(user.getVendorId()).getSimpleName());// 供应商简称
			orderSubModel.setSourceId(orderMainModel.getSourceId());// 渠道代码00:
			// 商城01:
			// CallCenter02:
			// IVR渠道03:
			// 手机商城04:
			// 短信渠道05:
			// 微信广发银行06：微信广发信用卡
			orderSubModel.setSourceNm(orderMainModel.getSourceNm());
			orderSubModel.setGoodsId(itemModel.getCode());// 商（单）品代码
			orderSubModel.setGoodsNm(goodsModel.getName());// 商品名
			orderSubModel.setCalMoney(itemModel.getPrice());
			orderSubModel.setTotalMoney(itemModel.getPrice());// 现金总金额
			orderSubModel.setSinglePrice(itemModel.getPrice());// 单个商品对应的价格
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
			orderSubModel.setGoodsNum(num);// 商品数量
			orderSubModel.setGoodssendFlag("0");// 发货标记0－未发货[默认]1－已发货2－已签收
			orderSubModel.setGoodsaskforFlag("0");// 请款标记0－未请款[默认]1－已请款

			// orderSubModel.setStagesNum(goodsModel.getInstallmentNumber());// 现金[或积分]分期数
			orderSubModel.setVendorOperFlag("1");// 供应商操作标记0－未操作1－操作过
			orderSubModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0301);// 当前状态代码-订单状态0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
			orderSubModel.setCurStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);
			orderSubModel.setCardtype(Contants.CARD_TYPE_Y);// 卡标志C：信用卡Y：借记卡
			orderSubModel.setCreateOper(orderMainModel.getCreateOper());// 创建操作员id
			orderSubModel.setItemSmallPic(itemModel.getImage1());// 单品小图标
			orderSubModel.setGoodsAttr1(itemModel.getAttribute());// 销售属性（json串）
			orderSubModel.setDelFlag(Contants.DEL_FLAG_0);// 逻辑删除标志0未删1已删

			// TODO
			Response<List<TblGoodsPaywayModel>> tblGoodsPaywayModelResponse = orderTieinSaleService
					.findByItemCode(itemCode);
			List<TblGoodsPaywayModel> tblGoodsPaywayModelList = tblGoodsPaywayModelResponse.getResult();
			if (tblGoodsPaywayModelList == null || tblGoodsPaywayModelList.isEmpty()) {
				response.setError("tblGoodsPaywayModel.be.null");
				return response;
			}
			TblGoodsPaywayModel tblGoodsPaywayModel = new TblGoodsPaywayModel();
			tblGoodsPaywayModel = tblGoodsPaywayModelList.get(tblGoodsPaywayModelList.size() - 1);
			if (tblGoodsPaywayModel == null) {
				response.setError("tblGoodsPaywayModel.be.null");
				return response;
			}

			orderSubModel.setStagesNum(tblGoodsPaywayModel.getStagesCode());
			orderSubModel.setInstallmentPrice(tblGoodsPaywayModel.getPerStage());
			// 数据库不为空项
			orderSubModel.setVerifyFlag("");
			orderSubModel.setOrigMoney(new BigDecimal(0));

			OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
			orderDoDetailModel.setDoUserid(user.getVendorId());// 处理用户
			orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_3);// 用户类型0：系统用户[批量]1：内部用户[cc]2：供应商3：持卡人
			orderDoDetailModel.setStatusId(Contants.SUB_ORDER_STATUS_0301);// 状态代码0301--待付款0316--订单状态未明0308--支付成功0307--支付失败0305--处理中0309--已发货0306--发货处理中0310--已签收0312--已撤单0304--已废单0334--退货申请0327--退货成功0335--拒绝退货申请0380--拒绝签收0381--无人签收0382--订单推送失败
			orderDoDetailModel.setStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);// 状态名称
			orderDoDetailModel.setCreateOper(orderSubModel.getCreateOper());// 创建人
			orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);// 逻辑删除标记为(0未删除，1已删除)
			Boolean result = orderMainManager.createOrder(orderMainModel, orderSubModel, orderDoDetailModel, itemModel);
			// TODO 调用接口
			// TODO 再次更改子订单状态 有待付款至支付状态
			responseMap.put("result", result);
			response.setResult(responseMap);
			return response;
		} catch (IllegalArgumentException e) {
			response.setError(e.getMessage());
			return response;
		} catch (Exception e) {
			log.error("OrderServiceImpl createTieinSaleOrder.eroor", Throwables.getStackTraceAsString(e));
			response.setError("OrderServiceImpl.createTieinSaleOrder.eroor");
			return response;
		}
	}

	/**
	 * 获取返回的报文
	 *
	 * @param pagePaymentReqDto
	 * @param orderMain
	 * @param orderSubModelList
	 */
	private void getReturnObjForPay(PagePaymentReqDto pagePaymentReqDto, OrderMainModel orderMain,
			List orderSubModelList) throws Exception{
		log.info("into getReturnObjForPay");
		String orderid = orderMain.getOrdermainId();// 大订单号
		String amount = orderMain.getTotalPrice().toString();// 总金额
		// 回调地址
		String payType = "";// 支付类型
		String pointType = "";// 积分类型
		String pointSum = "0";// 总积分值
		String isMerge = "0";// 是否合并支付
		String payAccountNo = orderMain.getCardno();// 支付账号
		String serialNo = "";// 交易流水号
		String tradeDate = orderMain.getCommDate();// 订单日期
		String tradeTime = orderMain.getCommTime();// 订单时间
		/******* 优惠券需求添加begin ******/
		String certType = orderMain.getContIdType();// 证件类型
		String certNo = orderMain.getContIdcard();// 证件号
		String otherOrdersInf = "";// 优惠券、积分信息串
		/******* 优惠券需求添加end ******/
		pagePaymentReqDto.setSerialNo("");// 商城生成的流水号 为空
		pagePaymentReqDto.setTradeDate(tradeDate);// 交易日期 为空
		pagePaymentReqDto.setTradeTime(tradeTime);// 交易时间 为空
		pagePaymentReqDto.setOrderid(orderid);// 大订单号
		pagePaymentReqDto.setAmount(amount);// 总金额
		pagePaymentReqDto.setMerchId(merchId);// 大商户号
		pagePaymentReqDto.setReturl(returl);// 回调地址
		pagePaymentReqDto.setPointType("");// 积分类型 为空
		pagePaymentReqDto.setPointSum("0");// 总积分值 为空
		pagePaymentReqDto.setIsMerge(isMerge);// 是否合并支付 为空
		pagePaymentReqDto.setPayAccountNo(payAccountNo);// 支付账号 为空
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
			if (i == 0) {// 如果是第一个子订单
				orders = orderSubModel.getMerId() + "|" + orderSubModel.getOrderId() + "|"
						+ orderSubModel.getTotalMoney() + "|" + orderSubModel.getStagesNum() + "|"
						+ orderSubModel.getInstallmentPrice();

				if (!"".equals(orderSubModel.getVoucherNo()) || orderSubModel.getBonusTotalvalue().longValue() != 0) {
					// 存在使用积分、优惠券
					flag = true;
				}
				otherOrdersInf = orderSubModel.getOrderIdHost() + "|" + orderSubModel.getMerId() + "|"
						+ orderSubModel.getOrderId() + "|" + orderSubModel.getVoucherNo() + "|"
						+ orderSubModel.getIntegraltypeId() + "|" + orderSubModel.getBonusTotalvalue() + "|"
						+ orderSubModel.getUitdrtamt();

			} else {
				orders = orders + "|" + orderSubModel.getMerId() + "|" + orderSubModel.getOrderId() + "|"
						+ orderSubModel.getTotalMoney() + "|" + orderSubModel.getStagesNum() + "|"
						+ orderSubModel.getInstallmentPrice();

				if (!"".equals(orderSubModel.getVoucherNo()) || orderSubModel.getBonusTotalvalue().longValue() != 0) {
					// 存在使用积分、优惠券
					flag = true;
				}
				otherOrdersInf = otherOrdersInf + "|" + orderSubModel.getOrderIdHost() + "|" + orderSubModel.getMerId()
						+ "|" + orderSubModel.getOrderId() + "|" + orderSubModel.getVoucherNo() + "|"
						+ orderSubModel.getIntegraltypeId() + "|" + orderSubModel.getBonusTotalvalue() + "|"
						+ orderSubModel.getUitdrtamt();
			}
		}
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
		String singGene = merchId + "|" + orderid + "|" + amount + "|" + pointType + "|" + pointSum + "|" + isMerge
				+ "|" + payType + "|" + orders + "|" + payAccountNo + "|" + serialNo + "|" + tradeDate + "|" + tradeTime
				+ "|" + otherOrdersInf + "|" + certType + "|" + certNo;// 签名因子

//		String sign = Hashing.md5().newHasher().putString(singGene, Charsets.UTF_8)
//				.putString(mainPrivateKey, Charsets.UTF_8).hash().toString();
		//改用旧系统加密方式
		String sign = SignAndVerify.sign_md(singGene, mainPrivateKey);// 签名
		pagePaymentReqDto.setSign(sign);// 签名
		pagePaymentReqDto.setPayAddress(payAddress);// 支付网关地址
	}

	/**
	 * 获取单品已购买的件数
	 * @param paramMap
	 * @return
	 *
	 * geshuo 20160707
	 */
	public Response<Map<String,Long>> findItemBuyCount(Map<String, Object> paramMap){
		Response<Map<String,Long>> response = new Response<>();
		try{
			Map<String,Long> result = Maps.newHashMap();
			List<BuyCountModel> countList = orderSubDao.findItemBuyCount(paramMap);
			for(BuyCountModel countModel:countList){
				result.put(countModel.getItemCode(),countModel.getBuyCount());
			}
			response.setResult(result);
			return response;
		}catch (Exception e){
			log.error("OrderServiceImpl findGoodsBuyCount query error", Throwables.getStackTraceAsString(e));
			response.setSuccess(false);
			response.setError("OrderServiceImpl.findGoodsBuyCount.query.error");
			return response;
		}
	}

}
