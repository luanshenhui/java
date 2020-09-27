package cn.com.cgbchina.restful.provider.impl.order;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.search.Pair;
import com.spirit.user.User;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.PayReturnCode;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.model.EspAreaInfModel;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.PromotionPayWayModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.EspAreaInfService;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.item.service.PromotionPayWayService;
import cn.com.cgbchina.related.model.TblParametersModel;
import cn.com.cgbchina.related.service.BusinessService;
import cn.com.cgbchina.rest.common.util.MallReturnCode;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.SMSOrderAdd;
import cn.com.cgbchina.rest.provider.model.order.SMSOrderAddReturn;
import cn.com.cgbchina.rest.provider.service.order.SMSOrderAddService;
import cn.com.cgbchina.rest.provider.vo.order.PriceLevelVo;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.coupon.CouponInfo;
import cn.com.cgbchina.rest.visit.model.order.O2OOrderInfo;
import cn.com.cgbchina.rest.visit.model.order.SendOrderToO2OInfo;
import cn.com.cgbchina.rest.visit.model.payment.CCPointResult;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequest;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequestResult;
import cn.com.cgbchina.rest.visit.model.point.QueryPointResult;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfo;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfoResult;
import cn.com.cgbchina.rest.visit.model.user.UserInfo;
import cn.com.cgbchina.rest.visit.service.payment.StagingRequestService;
import cn.com.cgbchina.rest.visit.service.point.PointService;
import cn.com.cgbchina.restful.provider.service.order.OrderChannelService;
import cn.com.cgbchina.trade.dto.OrderMainDto;
import cn.com.cgbchina.trade.dto.OrderSubDetailDto;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.TblOrderExtend1Model;
import cn.com.cgbchina.trade.service.DealO2OOrderService;
import cn.com.cgbchina.trade.service.OrderService;
import cn.com.cgbchina.trade.service.PriceSystemService;
import cn.com.cgbchina.trade.service.RestOrderService;
import cn.com.cgbchina.trade.service.TblOrderMainService;
import cn.com.cgbchina.trade.vo.CustLevelInfo;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.model.EspCustNewModel;
import cn.com.cgbchina.user.model.LocalCardRelateModel;
import cn.com.cgbchina.user.model.TblVendorRatioModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.EspCustNewService;
import cn.com.cgbchina.user.service.LocalCardRelateService;
import cn.com.cgbchina.user.service.VendorService;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL401 短信下单接口
 * 
 * @author huangchaoyong
 * 
 */
@Service
@Slf4j
public class SMSOrderAddServiceImpl implements SMSOrderAddService {
	@Value("#{app.merchId}")
	private String merchId;
	@Value("#{app.birthdayLimit}")
	private String birthdayLimit;
	@Resource
	private BusinessService businessService;
	@Resource
	private ItemService itemService;
	@Resource
	private GoodsPayWayService goodsPayWayService;
	@Resource
	private MallPromotionService mallPromotionService;
	@Resource
	private PromotionPayWayService promotionPayWayService;
	@Resource
	private GoodsService goodsService;
	@Resource
	private VendorService vendorService;
	@Resource
	private IdGenarator idGenarator;
	@Resource
	private OrderService orderService;
	@Resource
	private StagingRequestService stagingRequestService;
	@Resource
	private TblOrderMainService tblOrderMainService;
	@Resource
	private DealO2OOrderService dealO2OOrderService;
	@Resource
	private PointService pointService;
	@Resource
	private PriceSystemService priceSystemService;
	@Resource
	private LocalCardRelateService localCardRelateService;
	@Resource
	private EspAreaInfService espAreaInfService;
	@Resource
	private EspCustNewService espCustNewService;
	@Resource
	private OrderChannelService orderChannelService;
	@Resource
	cn.com.cgbchina.rest.visit.service.order.OrderService o2oOrdersService;
	@Resource
	private RestOrderService restOrderService;

	@Override
	public SMSOrderAddReturn add(SMSOrderAdd smsOrderAdd) {
		SMSOrderAddReturn sMSOrderAddReturn = new SMSOrderAddReturn();
		/********* 支付起停控制begin *********/
		if (!isQT()) {
			sMSOrderAddReturn.setReturnCode("000076");
			sMSOrderAddReturn.setReturnDes("短信渠道不允许支付");
			return sMSOrderAddReturn;
		}
		/********* 支付起停控制end *********/
		// 证件号
		String contIdCard = Strings.nullToEmpty(smsOrderAdd.getContIdCard());
		// 卡号
		String cardNo = Strings.nullToEmpty(smsOrderAdd.getCardNo());
		// 商品编码
		String goods_xid = Strings.nullToEmpty(smsOrderAdd.getGoodsId());
		// 商品数量
		int goodsNum = Integer.parseInt(Strings.nullToEmpty(smsOrderAdd.getGoodsNm()));
		// 业务类型 00:广发 01:积分
		String businessType = Strings.nullToEmpty(smsOrderAdd.getBusinessType());
		// 优惠券金额 没有则默认送0
		String voucherMoney = Strings.nullToEmpty(smsOrderAdd.getVoucherMoney());
		try {
			// 获取客户信息
			UserInfo user = orderChannelService.getUserByCertNo(contIdCard);
			if (user == null || Strings.isNullOrEmpty(user.getCustomerId())) {// 调用个人网银查客户号异常
				user = new UserInfo();
				user.setCertNo(contIdCard);
				user.setCustomerName(smsOrderAdd.getCustName());
			}
			String create_oper = Strings.nullToEmpty(user.getCustomerId());
			String memberName = user.getCustomerName();

			if (Strings.isNullOrEmpty(create_oper)) {
				create_oper = contIdCard;
			}
			
			// businessType=00是广发短信下单，只支持分期商品 生成订单之后直接走BPS
			if ("00".equals(businessType)) {
				// 校验
				OrderMainDto orderMainDto = check(smsOrderAdd, null, create_oper);
				if (orderMainDto != null && !Strings.isNullOrEmpty(orderMainDto.getReturnCode())) {
					log.info("mal401广发下单验证失败");
					sMSOrderAddReturn.setReturnDes(orderMainDto.getReturnDes());
					sMSOrderAddReturn.setReturnCode(orderMainDto.getReturnCode());
					return sMSOrderAddReturn;
				}
				log.info("mal401广发下单验证成功");

				// 商品单价
				BigDecimal goodsPrice = orderMainDto.getGoodsPaywayModelMap().get(orderMainDto.getItemCode())
						.getGoodsPrice();
				/****** 短信下单优惠券获取 begin ****/
				log.info("mal401广发下单优惠券获取");
				CouponInfo couponInfo = null;
				boolean isPrivilege = false;// 默认没有优惠券
				if (!Strings.isNullOrEmpty(voucherMoney)) {// 优惠券金额大于0，则需要使用优惠券
					try {
						log.info("mal401广发下单优惠券获取");
						couponInfo = checkCoupon(user, orderMainDto, voucherMoney, goodsPrice);
						if (couponInfo != null) {
							isPrivilege = true;
						}
					} catch (Exception e) {
						log.error("MAL401广发下单获取优惠券信息校验出错：", e);
						sMSOrderAddReturn.setReturnCode("000098");
						sMSOrderAddReturn.setReturnDes("优惠券金额不匹配");
						return sMSOrderAddReturn;
					}
				}
				/****** 短信下单优惠券 end ****/

				// 构建订单
				BigDecimal totalPrice = goodsPrice.multiply(new BigDecimal(goodsNum));
				OrderMainModel orderMainModel = createOrderMainFQ(create_oper, totalPrice, smsOrderAdd);
				OrderSubDetailDto subDetailDto = createOrderInfos(orderMainModel, orderMainDto, couponInfo, memberName);

				// 保存订单
				log.info("mal401广发订单保存开始");
				Response<Boolean> response = restOrderService.saveYGOrder(orderMainModel,
						subDetailDto.getOrderSubModelList(), subDetailDto.getOrderDoDetailModelList(), orderMainDto,
						null);
				if (!response.isSuccess()) {
					throw new RuntimeException(response.getError());
				}

				// 订单支付
				log.info("mal401广发订单支付开始");
				List<OrderSubModel> orderSubModels = Lists.newArrayList();
				List<OrderSubModel> orderSubModels1 = subDetailDto.getOrderSubModelList();
				if (isPrivilege) {
					// 成功的优惠券订单
					orderSubModels = orderChannelService.payFQOrder(orderMainModel, orderSubModels1,
							smsOrderAdd.getValidDate());
				} else {
					for (OrderSubModel orderSubModel : orderSubModels1) {
						orderSubModels.add(orderSubModel);
					}
				}
				if (orderSubModels1.size() != orderSubModels.size()) {
					sMSOrderAddReturn.setReturnCode("000011");
				}
				// 发起ops分期订单申请
				sMSOrderAddReturn = gotobps(orderSubModels, orderMainModel, orderMainDto);
				log.info("mal401广发订单支付结束");

				// 020业务与商城供应商平台对接 ,当更新订单信息后，进行O2O推送处理，本单需求只做广发下单部分，积分暂时不支持。
				Response<BaseResult> baseResultResponse = dealO2OOrderService
						.dealO2OOrdersAfterPaySucc(orderMainModel.getOrdermainId(), null);
				if (!baseResultResponse.isSuccess()) {
					throw new Exception(baseResultResponse.getError());
				}

				Response<OrderMainModel> retMainResponse = tblOrderMainService
						.findByOrderMainId(orderMainModel.getOrdermainId());
				if (!retMainResponse.isSuccess()) {
					throw new RuntimeException(retMainResponse.getError());
				}
				orderMainModel = retMainResponse.getResult();
				sMSOrderAddReturn.setOrderMainId(orderMainModel.getOrdermainId());
				sMSOrderAddReturn.setAmountMoney(orderMainModel.getTotalPrice().toString());
				sMSOrderAddReturn.setAmountPoint(orderMainModel.getTotalBonus().toString());
				sMSOrderAddReturn.setCurStatusId(orderMainModel.getCurStatusId());
			} else {
				// businessType=01 积分短信下单 生成订单之后走电子支付NSCT016
				// 根据卡号,礼品编码拿到ODS以及积分系统的数据VO
				PriceLevelVo priceLevelVo = getPriceFunc(cardNo, goods_xid);
				// VIP优先发货级别
				String custType = priceLevelVo.isVip() ? "D" : getCustType(priceLevelVo.getCustLevel());

				// 校验
				OrderMainDto orderMainDto = check(smsOrderAdd, priceLevelVo, create_oper);
				if (orderMainDto != null && !Strings.isNullOrEmpty(orderMainDto.getReturnCode())) {
					log.info("mal401积分下单验证失败");
					sMSOrderAddReturn.setReturnDes(orderMainDto.getReturnDes());
					sMSOrderAddReturn.setReturnCode(orderMainDto.getReturnCode());
					return sMSOrderAddReturn;
				}
				log.info("mal401积分下单验证成功");

				ItemModel itemModel = orderMainDto.getItemModelMap().get(orderMainDto.getItemCode());
				// 构建订单
				OrderMainModel orderMainModel = createOrderMainJF(orderMainDto, priceLevelVo, smsOrderAdd, create_oper);
				OrderSubDetailDto subDetailDto = createOrderInfosJF(orderMainModel, orderMainDto, custType, memberName);

				log.info("mal401积分订单保存开始");
				Response<Boolean> response = restOrderService.saveJFOrder(orderMainModel,
						subDetailDto.getOrderSubModelList(), subDetailDto.getOrderDoDetailModelList(),
						orderMainDto.getStockRestMap());
				if (!response.isSuccess()) {
					throw new RuntimeException(response.getError());
				}
				/******* 保存订单，扣减库存，注意事务控制end *********/

				String retCode = "";
				String retErrMsg = "";
				log.info("mal401积分订单支付开始");
				try {
					// 电子支付
					CCPointResult baseResult = (CCPointResult) orderChannelService.doPayJF(orderMainModel,
							smsOrderAdd.getValidDate());
					// 更新支付状态、是否需要回滚库存需要做事务控制
					retCode = baseResult.getRetCode();
					retErrMsg = baseResult.getRetErrMsg();
					if (MallReturnCode.RETURN_SUCCESS_CODE.equals(retCode)) {
						retErrMsg = "交易成功";
					}
					if (baseResult != null && baseResult.getPayTime() != null
							&& !Strings.isNullOrEmpty(baseResult.getPayTime())) {
						Date payTime = DateHelper.string2Date(baseResult.getPayTime(), DateHelper.YYYYMMDDHHMMSS);
						for (OrderSubModel orderSub : subDetailDto.getOrderSubModelList()) {
							orderSub.setOrder_succ_timeStr(baseResult.getPayTime());
							orderSub.setOrder_succ_time(payTime);
							orderMainModel.setPayResultTime(baseResult.getPayTime());
						}
					}else {
						Date payTime = orderMainModel.getCreateTime();
						if (payTime == null){
							payTime = new Date();
						}
						for (OrderSubModel orderSub : subDetailDto.getOrderSubModelList()) {
							orderSub.setOrder_succ_timeStr(DateHelper.date2string(payTime,DateHelper.YYYYMMDDHHMMSS));
							orderSub.setOrder_succ_time(payTime);
							orderMainModel.setPayResultTime(DateHelper.date2string(payTime,DateHelper.YYYYMMDDHHMMSS));
						}
					}
					updateOrders(orderMainModel, subDetailDto.getOrderSubModelList(), retCode);
					send2o2o(orderMainModel.getOrdermainId(), itemModel);

				} catch (Exception e) {
					retCode = "000000";
					retErrMsg = "支付异常";
					log.error("短信支付，更新订单出现异常：", e);
				}
				log.info("mal401积分订单支付结束");
				sMSOrderAddReturn.setReturnCode(retCode);
				sMSOrderAddReturn.setReturnDes(retErrMsg);
				sMSOrderAddReturn.setOrderMainId(orderMainModel.getOrdermainId());
				sMSOrderAddReturn.setAmountMoney(orderMainModel.getTotalPrice().toString());
				sMSOrderAddReturn.setAmountPoint(orderMainModel.getTotalBonus().toString());
				sMSOrderAddReturn.setCurStatusId(orderMainModel.getCurStatusId());

			}

		} catch (Exception e) {
			log.error("【MAL401】流水,Exception:", e);
			sMSOrderAddReturn.setReturnCode("000009");
			sMSOrderAddReturn.setReturnDes("系统繁忙，请稍后再试");
		}
		return sMSOrderAddReturn;
	}

	/**
	 * MAL401接口校验
	 * 
	 * @param smsOrderAdd
	 * @param priceLevelVo
	 * @param create_oper
	 * @return
	 */
	private OrderMainDto check(SMSOrderAdd smsOrderAdd, PriceLevelVo priceLevelVo, String create_oper) {
		OrderMainDto orderMainDto = new OrderMainDto();
		String goodsId = Strings.nullToEmpty(smsOrderAdd.getGoodsId());
		String businessType = Strings.nullToEmpty(smsOrderAdd.getBusinessType());
		int goodsNum = Integer.valueOf(Strings.nullToEmpty(smsOrderAdd.getGoodsNm()));

		// 根据商品编码查询出商品
		ItemModel itemModel = null;
		if ("00".equals(businessType)) {// 广发商城
			itemModel = itemService.findByMid(goodsId).getResult();
		} else {// 积分商城
			itemModel = itemService.findItemByXid(goodsId).getResult();
		}

		// 如果找不到商品
		if (itemModel == null) {// 如果找不到商品
			orderMainDto.setReturnCode("000031");
			orderMainDto.setReturnDes("找不到该商品");
			return orderMainDto;
		}
		String itemCode = itemModel.getCode();
		GoodsModel goodsModel = goodsService.findById(itemModel.getGoodsCode()).getResult();
		Response<VendorInfoDto> vendorInfoDtoResponse = vendorService.findById(goodsModel.getVendorId());
		VendorInfoDto vendorInfoDto = vendorInfoDtoResponse.getResult();

		// 共同检验
		orderMainDto = checkCommon(goodsNum, itemModel, goodsModel, vendorInfoDtoResponse, vendorInfoDto);
		if (!Strings.isNullOrEmpty(orderMainDto.getReturnCode())) {
			return orderMainDto;
		}

		// if(!orderChannelService.checkThreeCard(goodsModel.getCode(), smsOrderAdd.getCardNo())){
		// orderMainDto.setReturnCode("000071");
		// orderMainDto.setReturnDes("该卡第三级卡产品不满足购买此商品条件");
		// return orderMainDto;
		// }

		TblGoodsPaywayModel goodsPaywayModel = null;
		if ("00".equals(businessType)) {// 广发下单
			if (Contants.IS_INNER_0.equals(goodsModel.getIsInner())) {// 内宣商品
				orderMainDto.setReturnCode("000074");
				orderMainDto.setReturnDes("暂时支持普通和团购商品购买");
				return orderMainDto;
			}

			// 控制短信下单只支持分期商品,根据goodsId查询出的tblGoodsPayway为表中最高分期数的那条记录
			goodsPaywayModel = goodsPayWayService.findMaxGoodsPayway(itemCode).getResult();

			orderMainDto = checkPayway(goodsPaywayModel);
			if (!Strings.isNullOrEmpty(orderMainDto.getReturnCode())) {
				return orderMainDto;
			}

			// ===========================活动信息检验============================
			Response<MallPromotionResultDto> mallPromotionResponse = mallPromotionService.findPromByItemCodes("1",
					itemModel.getCode(), Contants.SOURCE_ID_MESSAGE);
			MallPromotionResultDto mallPromotionResultDto = mallPromotionResponse.getResult();
			if (mallPromotionResultDto != null) {// 存在正在进行的活动
				if (mallPromotionResultDto.getPromType() == Contants.PROMOTION_PROM_TYPE_4) {
					Response<PromotionPayWayModel> promPayWayResponse = promotionPayWayService
							.findMaxPromotionPayway(itemModel.getCode(), mallPromotionResultDto.getId().toString());
					if (promPayWayResponse.isSuccess() && promPayWayResponse.getResult() != null) {// 存在正在进行的活动
						PromotionPayWayModel promotionPayWayModel = promPayWayResponse.getResult();
						Map<String, String> promItemMap = Maps.newHashMap();
						promItemMap.put("promId", mallPromotionResultDto.getId().toString());
						promItemMap.put("periodId", mallPromotionResultDto.getPeriodId());
						promItemMap.put("itemCode", itemCode);
						promItemMap.put("itemCount", String.valueOf(goodsNum));
						promItemMap.put("promotionType", Contants.PROMOTION_PROM_TYPE_STRING_40);
						List<Map<String, String>> promItemList = Lists.newArrayList();
						promItemList.add(promItemMap);
						orderMainDto.setPromItemMap(promItemList);
						orderMainDto.getPromotionTypeMap().put(itemCode, Contants.PROMOTION_PROM_TYPE_4);
						goodsPaywayModel = BeanUtils.copy(promotionPayWayModel, TblGoodsPaywayModel.class);
					} else {
						orderMainDto.setReturnCode("000074");
						orderMainDto.setReturnDes("暂时只支持普通和团购商品购买");
						return orderMainDto;
					}
				} else {
					orderMainDto.setReturnCode("000074");
					orderMainDto.setReturnDes("暂时只支持普通和团购商品购买");
					return orderMainDto;
				}
			}
			// ================================活动检验结束===============================

		} else {// 积分下单
			// 校验卡板
			List<String> custBoard = priceLevelVo.getCustBoard();// 积分系统查询到的卡板
			String cardBoard = String.valueOf(priceLevelVo.getCardBoard());
			String goodsboard = String.valueOf(goodsModel.getCards());
			String isMerge = Strings.nullToEmpty(smsOrderAdd.getIsMerge());
			// 卡号
			String cardNo = Strings.nullToEmpty(smsOrderAdd.getCardNo());
			// 是否选择积分+现金支付0-是,1-否
			String isMoney = Strings.nullToEmpty(smsOrderAdd.getIsMoney());

			Map<String, Object> paramaMap = Maps.newHashMap();
			paramaMap.put("areaId", goodsModel.getRegionType());
			Response<EspAreaInfModel> areaInfModelResponse = espAreaInfService.findByAreaId(paramaMap);
			if (!areaInfModelResponse.isSuccess()) {
				throw new RuntimeException(areaInfModelResponse.getError());
			}
			EspAreaInfModel espAreaInf = areaInfModelResponse.getResult();
			String areaboard = String.valueOf(espAreaInf.getFormatId());
			// 拒绝虚拟礼品
			if ("01".equals(goodsModel.getGoodsType())) {
				orderMainDto.setReturnCode("000073");
				orderMainDto.setReturnDes("暂时不支持虚拟礼品购买");
				return orderMainDto;
			}

			// 校验积分类型（判断接口中卡号对应的积分类型与商品积分类型是否匹配）
			List<String> custTypeList = priceLevelVo.getCardJfType();
			if ("0".equals(isMerge)) {// 合并支付
				custTypeList = priceLevelVo.getCustJfType();
				if (!judgeCardBoard(goodsboard, areaboard, custBoard)) {
					orderMainDto.setReturnCode("000071");
					orderMainDto.setReturnDes("该客户卡板不满足购买此礼品条件");
					return orderMainDto;
				}
			} else {
				if (!judgeCardBoard(goodsboard, areaboard, cardBoard)) {
					orderMainDto.setReturnCode("000071");
					orderMainDto.setReturnDes("该客户卡板不满足购买此礼品条件");
					return orderMainDto;
				}
			}

			if (custTypeList == null || !judgeCardJftype(goodsModel.getPointsType(), custTypeList)) {
				orderMainDto.setReturnCode("000072");
				orderMainDto.setReturnDes("该客户积分类型不满足购买此礼品条件");
				return orderMainDto;
			}

			// 判断卡片等级
			if (!priceSystemService.checkCardLevel(itemModel.getCode(), null, cardNo)) {
				orderMainDto.setReturnCode("000101");
				orderMainDto.setReturnDes("卡片无法兑换此礼品");
				return orderMainDto;
			}

			// 纯积分最优支付方式
			String goodsPaywayId = priceLevelVo.getGoodsPaywayId();
			// 生日当月
			boolean isBirth = priceLevelVo.isBirth();
			boolean useBirth = false;
			if (isBirth) {
				// 生日当月
				useBirth = judgeBirth(create_oper, goodsNum);
			}
			// "0"--金普
			if (useBirth && Contants.MEMBER_LEVEL_JP.equals(priceLevelVo.getCustLevel())) {
				// 生日价次数满足并且用户最优等级为普通等级
				Response<TblGoodsPaywayModel> tblGoodsPaywayResponse = goodsPayWayService
						.getBirthPayway(itemModel.getCode());
				goodsPaywayModel = tblGoodsPaywayResponse.getResult();
			}
			if (goodsPaywayModel == null) {
				// 不是选用生日价，则选择其他价格
				Response<List<TblGoodsPaywayModel>> jxpaywayResponse = goodsPayWayService
						.findJxpayway(itemModel.getCode(), goodsPaywayId, isMoney);
				List<TblGoodsPaywayModel> jxpayway = jxpaywayResponse.getResult();
				if (jxpayway == null || jxpayway.isEmpty()) {
					orderMainDto.setReturnCode("000076");
					orderMainDto.setReturnDes("礼品无此定价");
					return orderMainDto;
				}
				goodsPaywayModel = jxpayway.get(0);
			}

			orderMainDto = checkPayway(goodsPaywayModel);
			if (!Strings.isNullOrEmpty(orderMainDto.getReturnCode())) {
				return orderMainDto;
			}
		}

		orderMainDto.setItemCode(itemCode);
		orderMainDto.addItemModel(itemModel);
		orderMainDto.putGoodsInfo(itemCode, goodsModel);
		orderMainDto.putGoodsPayway(itemCode, goodsPaywayModel);
		orderMainDto.putVendorInfoDto(itemCode, vendorInfoDto);
		orderMainDto.addTotalPrice(goodsPaywayModel.getGoodsPrice().multiply(new BigDecimal(goodsNum)));
		orderMainDto.addJfTotalNum(new Long(goodsPaywayModel.getGoodsPoint() * goodsNum));
		orderMainDto.setGoodsCount(goodsNum);
		orderMainDto.putRestStock(itemCode, goodsNum);// 用于减库存
		return orderMainDto;
	}

	private OrderMainDto checkPayway(TblGoodsPaywayModel goodsPaywayModel) {
		OrderMainDto orderMainDto = new OrderMainDto();

		if (goodsPaywayModel == null) {
			orderMainDto.setReturnCode("000031");
			orderMainDto.setReturnDes("找不到该商品");
			return orderMainDto;
		}

		// if (Contants.IS_INNER_0.equals(goodsPaywayModel.getIsAction())) {// 内宣商品
		// orderMainDto.setReturnCode("000074");
		// orderMainDto.setReturnDes("暂时支持普通和团购商品购买");
		// return orderMainDto;
		// }
		if ("d".equalsIgnoreCase(goodsPaywayModel.getIscheck())) {// 如果支付方式已被删除
			orderMainDto.setReturnCode("000016");
			orderMainDto.setReturnDes("该支付方式已经删除");
			return orderMainDto;
		}

		return orderMainDto;
	}

	/**
	 * 共同检验
	 * 
	 * @param goodsNum
	 * @param itemModel
	 * @param goodsModel
	 * @param vendorInfoDtoResponse
	 * @param vendorInfoDto
	 * @return
	 */
	private OrderMainDto checkCommon(int goodsNum, ItemModel itemModel, GoodsModel goodsModel,
			Response<VendorInfoDto> vendorInfoDtoResponse, VendorInfoDto vendorInfoDto) {
		OrderMainDto orderMainDto = new OrderMainDto();
		// 校验礼品、数量有效性
		if (goodsNum <= 0 || goodsNum > 99) {
			orderMainDto.setReturnCode("000047");
			orderMainDto.setReturnDes("商品数量异常");
			return orderMainDto;
		}
		// 如果找不到商品
		if (goodsModel == null) {
			orderMainDto.setReturnCode("000031");
			orderMainDto.setReturnDes("找不到该商品");
			return orderMainDto;
		}
		// 如果不存在相应的合作商
		if (vendorInfoDtoResponse == null || vendorInfoDto == null) {
			orderMainDto.setReturnCode("000034");
			orderMainDto.setReturnDes("对应合作商不存在");
			return orderMainDto;
		}

		// 不在上架状态
		if (!Contants.CHANNEL_SMS_02.equals(goodsModel.getChannelSms())) {
			orderMainDto.setReturnCode("000036");
			orderMainDto.setReturnDes("该商品不是上架状态");
			return orderMainDto;
		}

		// 校验商品有效期
		Date onShelfSmsDate = goodsModel.getOnShelfSmsDate();
		Date offShelfSmsDate = goodsModel.getOffShelfSmsDate();
		Date curDate = new Date();
		if (null == offShelfSmsDate) {
			if (null == onShelfSmsDate || curDate.before(onShelfSmsDate)) {
				orderMainDto.setReturnCode("000033");
				orderMainDto.setReturnDes("现在日期不在商品有效期之内");
				return orderMainDto;
			}
		} else {
			if (curDate.after(offShelfSmsDate)) {
				if (onShelfSmsDate.before(offShelfSmsDate) || onShelfSmsDate.after(curDate)) {
					orderMainDto.setReturnCode("000033");
					orderMainDto.setReturnDes("现在日期不在商品有效期之内");
					return orderMainDto;
				}
			} else {
				if (curDate.before(onShelfSmsDate)) {
					orderMainDto.setReturnCode("000033");
					orderMainDto.setReturnDes("现在日期不在商品有效期之内");
					return orderMainDto;
				}
			}
		}

		// 检测商品数量
		int goodsBacklog = itemModel.getStock().intValue();
		int goodsBacklogI = goodsBacklog - goodsNum;// 扣减后的商品数量
		if (goodsBacklogI < 0) {// 如果扣除商品数量后实际库存小于0
			orderMainDto.setReturnCode("000038");
			orderMainDto.setReturnDes("产品已售罄，请您挑选其他的产品。");
			return orderMainDto;
		}
		return orderMainDto;
	}

	/**
	 * 优惠券获取
	 * 
	 * @param user
	 * @param orderMainDto
	 * @param voucherMoney
	 * @param goodsPrice
	 * @return
	 */
	private CouponInfo checkCoupon(UserInfo user, OrderMainDto orderMainDto, String voucherMoney,
			BigDecimal goodsPrice) {
		CouponInfo couponInfo = null;
		// 正则 金额 11位整数.2位小数
		String regPattern = "^[0-9]{1,11}(.[0-9]{1,2})?$";
		Pattern pat = Pattern.compile(regPattern);
		Matcher ma = pat.matcher(voucherMoney);
		if (!ma.matches()) {
			throw new RuntimeException("优惠券金额格式错误:" + voucherMoney);
		}

		BigDecimal voucherMoneyBd = new BigDecimal("0.00");
		try {
			voucherMoneyBd = new BigDecimal(voucherMoney);
			voucherMoneyBd.setScale(2);
		} catch (Exception e) {
			throw new RuntimeException("优惠券金额转换失败" + voucherMoney + ",msg:" + e.getMessage(), e);
		}

		GoodsModel goodsModel = orderMainDto.getGoodsInfo().get(orderMainDto.getItemCode());
		// 优惠券金额大于0
		if (voucherMoneyBd.compareTo(new BigDecimal("0.00")) > 0) {
			List<CouponInfo> couponInfos = orderChannelService.queryCouponInfo(null, user, goodsModel, voucherMoneyBd,
					true);
			if (!couponInfos.isEmpty()) {
				couponInfo = couponInfos.get(0);
				// 下限金额
				BigDecimal limitMoneyBd = couponInfo.getLimitMoney();
				if (goodsPrice.compareTo(limitMoneyBd) < 0) {
					throw new RuntimeException("商品价格小于优惠券使用下限金额");
				}

			} else {
				throw new RuntimeException("该客户没有符合条件的优惠券！");
			}
		} else if (voucherMoneyBd.compareTo(new BigDecimal("0")) < 0) {// 加入小于0金额判断
			throw new RuntimeException("优惠券金额小于0");
		}
		return couponInfo;
	}

	/**
	 * 更新支付状态
	 * 
	 * @param orderSubModels
	 * 
	 * @param retCode
	 */
	private void updateOrders(OrderMainModel orderMainModel, List<OrderSubModel> orderSubModels, String retCode) {
		String cur_status_id = "";
		String cur_status_nm = "";
		if ("000000".equals(retCode)) {
			cur_status_id = "0308";
			cur_status_nm = "支付成功";
		} else if (PayReturnCode.isStateNoSure(retCode) || retCode == null) {// 如果支付时状态未明
			cur_status_id = "0316";
			cur_status_nm = "订单状态未明";
		} else {
			cur_status_id = "0307";
			cur_status_nm = "支付失败";
		}

		orderMainModel.setCurStatusId(cur_status_id);
		orderMainModel.setCurStatusNm(cur_status_nm);
		orderMainModel.setModifyOper("短信支付");
		orderMainModel.setErrorCode(retCode);
		List<OrderDoDetailModel> orderDoDetailModels = new ArrayList<>();
		Map<String, Integer> itemStockMap = new HashMap<>();
		int birthDayCount = 0;
		for (OrderSubModel orderSubModel : orderSubModels) {
			orderSubModel.setCurStatusId(cur_status_id);
			orderSubModel.setCurStatusNm(cur_status_nm);
			orderSubModel.setModifyOper("短信支付");
			orderSubModel.setErrorCode(retCode);
			// orderSubModel.setOrder_succ_time(new Date());

			OrderDoDetailModel tblOrderDodetail = new OrderDoDetailModel();
			tblOrderDodetail.setStatusId(cur_status_id);
			tblOrderDodetail.setStatusNm(cur_status_nm);
			tblOrderDodetail.setDoDesc(retCode);
			tblOrderDodetail.setDoTime(new Date());
			tblOrderDodetail.setDoUserid("电子支付");
			tblOrderDodetail.setUserType("0");
			tblOrderDodetail.setOrderId(orderSubModel.getOrderId());
			tblOrderDodetail.setDelFlag(0);
			tblOrderDodetail.setCreateOper("电子支付");
			tblOrderDodetail.setCreateTime(new Date());
			orderDoDetailModels.add(tblOrderDodetail);
			if ("0307".equals(cur_status_id)) {
				String itemCd = orderSubModel.getGoodsId();// 保存回滚库存数量
				int cnt = orderSubModel.getGoodsNum();
				if (itemStockMap.containsKey(itemCd)) {
					itemStockMap.put(itemCd, itemStockMap.get(itemCd) + cnt);
				} else {
					itemStockMap.put(itemCd, cnt);
				}
				// 使用生日价支付回滚生日次数
				if ("0004".equals(orderSubModel.getMemberLevel())) {
					birthDayCount += 1;
				}
			}
		}
		User user = new User(orderMainModel.getCreateOper(), orderMainModel.getContNm());
		Response<Boolean> response = restOrderService.updateOrders(orderMainModel, orderSubModels, orderDoDetailModels,
				itemStockMap, birthDayCount, user);
		if (!response.isSuccess()) {
			throw new RuntimeException(response.getError());
		}
	}

	/**
	 * 发送订单至外系统
	 * 
	 * @param orderMainId
	 * @param itemModel
	 */
	private void send2o2o(String orderMainId, ItemModel itemModel) {
		Response<OrderMainModel> retMainResponse = tblOrderMainService.findByOrderMainId(orderMainId);
		if (!retMainResponse.isSuccess()) {
			throw new RuntimeException(retMainResponse.getError());
		}
		OrderMainModel orderMainModel = retMainResponse.getResult();
		if ("0308".equals(orderMainModel.getCurStatusId())) {
			// 支付成功,判断O2O订单,则调用方法推送至外系统
			try {
				Response<List<OrderSubModel>> orderSubListResponse = orderService.findByorderMainId(orderMainId);
				if (!orderSubListResponse.isSuccess()) {
					throw new RuntimeException(orderSubListResponse.getError());
				}
				List<OrderSubModel> orderSubModelList = orderSubListResponse.getResult();
				if (orderSubModelList != null && orderSubModelList.size() > 0) {
					OrderSubModel orderSubModel = orderSubModelList.get(0);
					String vendorId = orderSubModel.getVendorId();
					Response<VendorInfoModel> vendorInfoDtoResponse = vendorService.findVendorInfosByVendorId(vendorId);
					if (!vendorInfoDtoResponse.isSuccess()) {
						throw new RuntimeException(vendorInfoDtoResponse.getError());
					}
					VendorInfoModel vendorInfoModel = vendorInfoDtoResponse.getResult();
					// 需要实时推送
					if (!Strings.isNullOrEmpty(vendorInfoModel.getActionFlag())
							&& "00".equals(vendorInfoModel.getActionFlag())) {
						SendOrderToO2OInfo sendOrderToO2OInfo = changeOrderListToMap(orderMainModel, vendorInfoModel,
								orderSubModelList, itemModel);
						o2oOrdersService.sendO2OOrderInfo(sendOrderToO2OInfo);
					}
				}
			} catch (Exception e) {
				log.error("多线程调o2o系统失败：" + e);
			}
		}
	}

	private SendOrderToO2OInfo changeOrderListToMap(OrderMainModel orderMainModel, VendorInfoModel vendorInfoModel,
			List<OrderSubModel> orderSubModels, ItemModel itemModel) throws Exception {
		SendOrderToO2OInfo sendOrderToO2OInfo = new SendOrderToO2OInfo();
		BigDecimal payMoney = new BigDecimal("0.00");
		sendOrderToO2OInfo.setOrganId("");
		sendOrderToO2OInfo.setOrderno(orderMainModel.getOrdermainId());
		sendOrderToO2OInfo.setVendorName(vendorInfoModel.getVendorId());
		List<O2OOrderInfo> sendO2OOrderInfoList = new ArrayList<O2OOrderInfo>();
		O2OOrderInfo sendO2OOrderInfo;

		for (OrderSubModel orderSubModel : orderSubModels) {// 遍历小订单信息
			sendO2OOrderInfo = new O2OOrderInfo();
			payMoney = payMoney.add(orderSubModel.getCalMoney());
			sendO2OOrderInfo.setSubOrderId(orderSubModel.getOrderId());
			sendO2OOrderInfo.setSOrderId(itemModel.getO2oCode());
			sendO2OOrderInfo.setGoodsId(itemModel.getO2oVoucherCode());
			sendO2OOrderInfo.setType(0);
			sendO2OOrderInfo.setPrice(orderSubModel.getCalMoney());
			sendO2OOrderInfo.setNumber(orderSubModel.getGoodsNum());
			sendO2OOrderInfo
					.setAmount(orderSubModel.getCalMoney().multiply(new BigDecimal(orderSubModel.getGoodsNum())));
			sendO2OOrderInfo.setMobile(orderMainModel.getCsgPhone1());
			sendO2OOrderInfoList.add(sendO2OOrderInfo);

		}
		sendOrderToO2OInfo.setO2OOrderInfos(sendO2OOrderInfoList);
		sendOrderToO2OInfo.setPayment(payMoney);

		return sendOrderToO2OInfo;
	}

	/**
	 * 根据客户等级获得发货等级
	 */
	private String getCustType(String custLevel) {
		String custType = Contants.CUST_LEVEL_CODE_A;
		if (Contants.MEMBER_LEVEL_DJ.equals(custLevel)) {
			// 若用户名下有顶级卡,返回顶级卡等级
			return Contants.CUST_LEVEL_CODE_C;
		} else if (Contants.MEMBER_LEVEL_TJ.equals(custLevel)) {
			custType = Contants.CUST_LEVEL_CODE_B;
		}
		return custType;
	}

	/**
	 * 根据客户号 商品数目来判断生日价次数是否可用
	 * 
	 * @param custId
	 * @param goodsNum
	 * @return
	 */
	private boolean judgeBirth(String custId, int goodsNum) {
		// 查询
		Response<EspCustNewModel> response = espCustNewService.findById(custId);
		if (!response.isSuccess()) {
			throw new RuntimeException(response.getError());
		}
		EspCustNewModel espCustNewModel = response.getResult();
		if (espCustNewModel != null) {// 根据客户号查询到生日使用信息
			Integer birthLimit = Integer.parseInt(birthdayLimit);
			Integer birthUsedCount = espCustNewModel.getBirthUsedCount();
			if (birthUsedCount.intValue() + goodsNum <= birthLimit.intValue()) {// 数据库中生日使用次数超出了限制
				return true;
			}
		}
		return false;
	}

	/**
	 * 根据传入参数（卡号、礼品编码），获得最优价格
	 */
	private PriceLevelVo getPriceFunc(String cardNo, String goodsXid) {
		PriceLevelVo plVo = new PriceLevelVo();
		try {
			List<String> custLevelList = Lists.newArrayList();
			// 是否生日
			boolean isBrithday = false;
			// 是否VIP
			boolean isVipFlag = false;
			// 客户级别
			String custLevel = "";
			// 积分系统返回的客户等级
			List<String> bonusCustLevelList = Lists.newArrayList();
			// 积分系统的卡板，顺序与bonusCustLevelList对应
			List<String> bonusCardBroadList = Lists.newArrayList();
			// 积分系统的积分类型，顺序与bonusCustLevelList对应
			List<String> bonusCardjgidList = Lists.newArrayList();
			// 接口中所传的卡号对应的积分类型
			List<String> jfTypes = Lists.newArrayList();
			// 由于积分系统返回的报文包含翻页信息，有可能需要查询多个页面
			int bonusCurPage = 0;
			int bonusTotalPage = 1;
			QueryPointsInfo queryPointsInfo = null;
			QueryPointResult queryPointResult = null;
			String cardFormat = "";

			// 进行翻页查询
			while (bonusCurPage < bonusTotalPage) {
				queryPointsInfo = new QueryPointsInfo();
				queryPointsInfo.setChannelID("MALL");
				queryPointsInfo.setCurrentPage(String.valueOf(bonusCurPage));
				queryPointsInfo.setCardNo(cardNo);
				// 调用积分查询接口B=bms011
				queryPointResult = pointService.queryPoint(queryPointsInfo);

				List<QueryPointsInfoResult> queryPointsInfoResults = queryPointResult.getQueryPointsInfoResults();

				for (QueryPointsInfoResult queryPointsInfoResult : queryPointsInfoResults) {
					bonusCustLevelList.add(queryPointsInfoResult.getLevelCode());
					String cardFormatTemp = queryPointsInfoResult.getProductCode();
					bonusCardBroadList.add(cardFormatTemp);
					bonusCardjgidList.add(queryPointsInfoResult.getJgId());
					if (cardNo.equals(queryPointsInfoResult.getCardNo())) {
						jfTypes.add(queryPointsInfoResult.getJgId());
						cardFormat = cardFormatTemp;
					}
				}

				bonusCurPage++;
				String totalPage = queryPointResult.getTotalPages();
				try {
					bonusTotalPage = Integer.parseInt(totalPage.trim());
				} catch (Exception e) {
					log.error("转换总页数时出现异常，积分返回总页数：" + bonusTotalPage);
					log.error(e.getMessage(), e);
				}
			}
			// 通过卡号获取客户证件号
			CustLevelInfo custInfo = priceSystemService.getCustLevelInfoByCard(cardNo);
			if (custInfo == null) {// FIXME 现系统报文返回没有生日和vip字段
				// 获取不了用户级别信息,使用原有的积分系统数据判断客户级别
				log.error("Can't find cust level info, cardNo=" + cardNo);
				// 取得生日信息，如果当月生日，则返回生日价
				String birthDay = "";// FIXME 接口没有返回客户生日
				if (!Strings.isNullOrEmpty(birthDay)) {
					isBrithday = DateHelper.isBrithDay(birthDay);
				}
				// 等积分系统正常后读取报文
				custLevelList = getCustLevelStr(bonusCustLevelList, bonusCardBroadList);

				// VIP客户增加VIP价格
				String isVip = "";// FIXME 接口没有返回vip字段
				if ("0".equals(isVip)) {// 增加VIP等级
					custLevelList.add(Contants.MEMBER_LEVEL_VIP);
					isVipFlag = true;
				}
				custLevel = getMemberLevelByList(custLevelList, isVip);
			} else {
				// 使用南航白金卡那部分数据
				custLevelList = genCustLevelList(custInfo.getMemberLevel());
				custLevel = custInfo.getMemberLevel();
				isBrithday = DateHelper.isBrithDay(custInfo.getBirthDay());
				isVipFlag = custInfo.isVipFlag();
				if (custInfo.getCardFormatNbr() != null) {
					cardFormat = Strings.nullToEmpty(String.valueOf(custInfo.getCardFormatNbr().get(cardNo)));
				}
				bonusCardBroadList = custInfo.getCustFomat();
			}
			// 商品ID的队列
			Response<ItemModel> itemModelResponse = itemService.findItemByXid(goodsXid);
			if (!itemModelResponse.isSuccess()) {
				throw new RuntimeException(itemModelResponse.getError());
			}
			ItemModel itemModel = itemModelResponse.getResult();
			Response<List<TblGoodsPaywayModel>> listResponse = goodsPayWayService
					.findPaywayByGoodsIds(itemModel.getCode());
			if (!listResponse.isSuccess()) {
				throw new RuntimeException(listResponse.getError());
			}
			List<TblGoodsPaywayModel> paywayList = listResponse.getResult();
			TblGoodsPaywayModel payway = getCustTopLevelPaywayBonusMap(paywayList, custLevelList);
			// 组装VO
			plVo.setBirth(isBrithday);
			plVo.setVip(isVipFlag);
			plVo.setCustLevel(custLevel);

			if (payway != null) {
				plVo.setGoodsPaywayId(payway.getGoodsPaywayId());
			}
			plVo.setCardBoard(cardFormat);
			plVo.setCustBoard(bonusCardBroadList);
			plVo.setCardJfType(jfTypes);
			plVo.setCustJfType(bonusCardjgidList);
		} catch (Exception e) {
			log.error("获取最优价时出错：", e);
			throw new RuntimeException(e);
		}
		return plVo;
	}

	/**
	 * 将积分系统的会员等级转换成商城需要的会员等级
	 */
	private List<String> getCustLevelStr(List<String> bonusCustLevelList, List<String> bonusCardBroadList) {

		Set<String> tempSet = Sets.newHashSet();
		List<String> custLeveList = Lists.newArrayList();

		for (int bonusCount = 0; bonusCount < bonusCustLevelList.size(); bonusCount++) {
			String custLevel = bonusCustLevelList.get(bonusCount);

			if ("04".equals(custLevel)) {// 顶级卡
				tempSet.add(Contants.MEMBER_LEVEL_DJ);
				break;
			} else if ("03".equals(custLevel)) {// 白金卡
				String cardBroad = bonusCardBroadList.get(bonusCount);
				Response<LocalCardRelateModel> localCardRelateResponse = localCardRelateService
						.findByFormatId(cardBroad);// 先查询卡板信息
				if (localCardRelateResponse.isSuccess()) {
					LocalCardRelateModel localCardRelate = localCardRelateResponse.getResult();
					if (localCardRelate != null && "2".equals(localCardRelate.getProCode())) {
						tempSet.add(Contants.MEMBER_LEVEL_DJ);// 增值白金
						break;
					} else {
						tempSet.add(Contants.MEMBER_LEVEL_TJ);// 尊越/臻享白金+钛金卡
					}
				}
			} else if ("02".equals(custLevel)) {// 钛金卡
				tempSet.add(Contants.MEMBER_LEVEL_TJ);// 尊越/臻享白金+钛金卡
			}
		}

		custLeveList.add(Contants.MEMBER_LEVEL_JP);// 默认加入金普价
		if (tempSet.contains(Contants.MEMBER_LEVEL_DJ)) {// 存在顶级卡等级
			custLeveList.add(Contants.MEMBER_LEVEL_DJ);
			custLeveList.add(Contants.MEMBER_LEVEL_TJ);
		} else if (tempSet.contains(Contants.MEMBER_LEVEL_TJ)) {// 存在钛金等级价格
			custLeveList.add(Contants.MEMBER_LEVEL_TJ);
		}

		return custLeveList;
	}

	/**
	 * 客户级别
	 */
	private String getMemberLevelByList(List<String> list, String vipFlag) throws Exception {
		String custLevel = Contants.MEMBER_LEVEL_JP;
		for (String memberLevel : list) {
			if (Contants.MEMBER_LEVEL_DJ.equals(memberLevel)) {
				// 若用户名下有顶级卡,返回顶级卡等级
				return memberLevel;
			} else if (Contants.MEMBER_LEVEL_TJ.equals(memberLevel)) {
				custLevel = memberLevel;
			} else if (Contants.IS_VIP.equals(vipFlag) && !Contants.MEMBER_LEVEL_TJ.equals(custLevel)) {
				custLevel = Contants.MEMBER_LEVEL_VIP;
			}
		}
		return custLevel;
	}

	/**
	 * 根据客户最优等级获得其可享受的等级定价
	 */
	private List<String> genCustLevelList(String custLevel) {
		List<String> lt = Lists.newArrayList();
		if (Contants.MEMBER_LEVEL_DJ.equals(custLevel)) {
			lt.add(Contants.MEMBER_LEVEL_DJ);
			lt.add(Contants.MEMBER_LEVEL_TJ);
			lt.add(Contants.MEMBER_LEVEL_JP);
		} else if (Contants.MEMBER_LEVEL_TJ.equals(custLevel)) {
			lt.add(Contants.MEMBER_LEVEL_TJ);
			lt.add(Contants.MEMBER_LEVEL_JP);
		} else if (Contants.MEMBER_LEVEL_VIP.equals(custLevel)) {
			lt.add(Contants.MEMBER_LEVEL_VIP);
			lt.add(Contants.MEMBER_LEVEL_JP);
		} else {
			lt.add(Contants.MEMBER_LEVEL_JP);
		}
		return lt;
	}

	/**
	 * 提取出当前客户最高的客户级别对应的【纯积分】支付方式Map，返回的Map格式为Map<String,TblGoodsPayway>, 以goodsId为Key
	 */
	private TblGoodsPaywayModel getCustTopLevelPaywayBonusMap(List<TblGoodsPaywayModel> paywayList,
			List<String> custLevelList) {
		TblGoodsPaywayModel goodsPaywayModel = null;
		if (paywayList != null && custLevelList != null)
			for (String memberLevel : custLevelList) {
				// 遍历客户等级集合
				for (TblGoodsPaywayModel payway : paywayList) {
					// 遍历支付信息集合
					if (Strings.padStart(memberLevel, 4, '0').equals(payway.getMemberLevel())
							&& Contants.PAY_WAY_CODE_JF.equals(payway.getPaywayCode())) {
						// 客户等级与支付等级相等且为纯积分支付方式
						if (goodsPaywayModel == null) {// 返回结果集paywayMap里不存在该商品的支付信息
							goodsPaywayModel = payway;
						} else if (goodsPaywayModel != null
								&& payway.getGoodsPoint() < goodsPaywayModel.getGoodsPoint()) {
							// paywayMap里存在该商品的支付信息但新的支付方式价格更低
							goodsPaywayModel = payway;
						}
					}
				}
			}
		return goodsPaywayModel;
	}

	/**
	 * 组装小订单表list以及订单历史表list
	 * 
	 * @param orderMainModel
	 * @param orderMainDto
	 * @param couponInfo
	 * @param memberName
	 * @return
	 */
	private OrderSubDetailDto createOrderInfos(OrderMainModel orderMainModel, OrderMainDto orderMainDto,
			CouponInfo couponInfo, String memberName) {
		log.info("mal401广发下单小订单设置开始");
		OrderSubDetailDto orderSubDetailDto = new OrderSubDetailDto();

		String itemCode = orderMainDto.getItemCode();
		ItemModel itemModel = orderMainDto.getItemModelMap().get(itemCode);
		GoodsModel goodsModel = orderMainDto.getGoodsInfo().get(itemCode);
		TblGoodsPaywayModel goodsPaywayModel = orderMainDto.getGoodsPaywayModelMap().get(itemCode);
		VendorInfoDto vendorInfoDto = orderMainDto.getVendorInfoDtoMap().get(itemCode);
		Map<String, String> promItemMap = new HashMap<>();
		if (orderMainDto.getPromItemMap() != null && !orderMainDto.getPromItemMap().isEmpty()) {// 活动信息
			promItemMap = orderMainDto.getPromItemMap().get(0);
		}

		for (int i = 0; i < orderMainModel.getTotalNum(); i++) {
			/*** 短信渠道增加优惠券 start **/
			BigDecimal goodsPrice = goodsPaywayModel.getGoodsPrice();
			BigDecimal privilegeMoneyBD = null;// 优惠券金额
			if (couponInfo != null && 0 == i) {// 优惠券不为空，第1个订单
				// 商品价格 - 优惠券金额
				privilegeMoneyBD = couponInfo.getPrivilegeMoney();
				goodsPrice = goodsPrice.subtract(privilegeMoneyBD);
			}
			BigDecimal perStagePrice = goodsPrice.divide(new BigDecimal(goodsPaywayModel.getStagesCode()), 2,
					BigDecimal.ROUND_HALF_UP);
			/*** 短信渠道增加优惠券 end **/
			// 组装小订单
			OrderSubModel orderSubModel = new OrderSubModel();
			String orderMainId = orderMainModel.getOrdermainId();
			orderSubModel.setOrderId(orderMainId + StringUtils.leftPad(String.valueOf(i + 1), 2, "0"));
			orderSubModel.setOrdermainId(orderMainId);
			orderSubModel.setOrderIdHost(idGenarator.orderSerialNo());
			orderSubModel.setOperSeq(new Integer(0));// 业务订单同步序号
			orderSubModel.setOrdertypeId(orderMainModel.getOrdertypeId());
			orderSubModel.setOrdertypeNm(orderMainModel.getOrdertypeNm());
			orderSubModel.setPaywayCode(goodsPaywayModel.getPaywayCode());// 支付方式代码0001:
																			// 现金0002:
																			// 积分0003:
																			// 积分+现金0004:手续费0005:
																			// 现金+手续费0006:
																			// 积分+手续费0007:积分+现金+手续费
			String paywayName = "";
			if (goodsPaywayModel.getPaywayCode().equals("0001")) {
				paywayName = "现金";
			} else if (goodsPaywayModel.getPaywayCode().equals("0002")) {
				paywayName = "积分";
			} else if (goodsPaywayModel.getPaywayCode().equals("0003")) {
				paywayName = "积分+现金";
			} else if (goodsPaywayModel.getPaywayCode().equals("0004")) {
				paywayName = "手续费";
			} else if (goodsPaywayModel.getPaywayCode().equals("0005")) {
				paywayName = "现金+手续费";
			} else if (goodsPaywayModel.getPaywayCode().equals("0006")) {
				paywayName = "积分+手续费";
			} else if (goodsPaywayModel.getPaywayCode().equals("0007")) {
				paywayName = "积分+现金+手续费";
			}
			orderSubModel.setPaywayNm(paywayName);// 支付方式名称 未完成
			orderSubModel.setCardno(orderMainModel.getCardno());// 卡号
			orderSubModel.setVerifyFlag("");// 下单验证标记
			orderSubModel.setVendorId(goodsModel.getVendorId());// 供应商代码
			orderSubModel.setVendorSnm(vendorInfoDto.getSimpleName());// 供应商名称简写
			orderSubModel.setSourceId(orderMainModel.getSourceId());// 渠道代码
			orderSubModel.setSourceNm(orderMainModel.getSourceNm());// 渠道名称
			orderSubModel.setGoodsCode(goodsModel.getCode());
			orderSubModel.setGoodsId(itemModel.getCode());// 商品代码
			orderSubModel.setGoodsPaywayId(goodsPaywayModel.getGoodsPaywayId());// 商品支付编码
			orderSubModel.setGoodsNum(1);// 商品数量
			orderSubModel.setGoodsNm(goodsModel.getName());// 商品名称
			orderSubModel.setCurrType("156");// 商品币种
			orderSubModel.setExchangeRate(new BigDecimal(100));// 对人民币的汇率值
			orderSubModel.setGoodssendFlag("0");// 发货标记
			orderSubModel.setGoodsaskforFlag("0");// 请款标记
			orderSubModel.setSpecShopnoType("");// 特店类型
			orderSubModel.setPayTypeNm("");// 佣金代码名称
			orderSubModel.setIncCode("");// 手续费率代码
			orderSubModel.setIncCodeNm("");// 手续费名称
			orderSubModel.setStagesNum(goodsPaywayModel.getStagesCode());// 现金[或积分]分期数
			orderSubModel.setCommissionType("");// 佣金计算类别
			orderSubModel.setCommissionRate(new BigDecimal(0));// 佣金区间佣金率(不包含%)
			orderSubModel.setCommission(new BigDecimal(0));// 佣金金额【与币种一致】
			orderSubModel.setBonusTotalvalue(goodsPaywayModel.getGoodsPoint());// 积分总数
			orderSubModel.setCalMoney(goodsPaywayModel.getGoodsPrice());// 清算总金额
			orderSubModel.setOrigMoney(new BigDecimal(0));// 原始现金总金额
			orderSubModel.setTotalMoney(goodsPrice);// 现金总金额
			orderSubModel.setIncWay("00");// 手续费获取方式
			orderSubModel.setIncRate(new BigDecimal(0));// 手续费率(不包含%)
			orderSubModel.setIncMoney(new BigDecimal(0));// 手续费总金额

			orderSubModel.setUitfeeflg(new Integer("0"));// 手续费减免期数
			orderSubModel.setUitfeedam(new BigDecimal(0));// 手续费减免金额
			orderSubModel.setUitdrtuit(new Integer("0"));// 本金减免期数
			orderSubModel.setUitdrtamt(new BigDecimal(0));// 本金减免金额
			orderSubModel.setIncBackPrice(new BigDecimal(0));// 手续费退回指定金额
			orderSubModel.setIncTakePrice(perStagePrice);// 设置分期价格
			orderSubModel.setCreditFlag("");// 授权额度不足处理方式
			orderSubModel.setCalWay("");// 退货方式
			orderSubModel.setLockedFlag("0");// 订单锁标记
			orderSubModel.setVendorOperFlag("0");// 供应商操作标记
			orderSubModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0301);// 当前状态代码
			orderSubModel.setCurStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);// 当前状态名称
			orderSubModel.setCreateOper(orderMainModel.getCreateOper());// 创建操作员ID
			orderSubModel.setCreateTime(orderMainModel.getCreateTime());// 创建时间
			orderSubModel.setVersionNum(new Integer(0));// 记录更新控制版本号
			orderSubModel.setGoodsType(goodsModel.getGoodsType());// 商品类别ID
			if ("00".equals(goodsModel.getGoodsType())) {
				orderSubModel.setGoodsTypeName("实物");
			} else if ("01".equals(goodsModel.getGoodsType())) {
				orderSubModel.setGoodsTypeName("虚拟");
			} else if ("02".equals(goodsModel.getGoodsType())) {
				orderSubModel.setGoodsTypeName("O2O");
			}
			orderSubModel.setMemberName(memberName); // 会员姓名

			// 数据库非必输字段
			orderSubModel.setMerId(vendorInfoDto.getMerId());// 小商户号
			// 后台类目
			Long backCategoryId = null;
			Response<List<Pair>> pairResponse = goodsService.findCategoryByGoodsCode(itemModel.getGoodsCode());
			if (pairResponse.isSuccess() && pairResponse.getResult() != null) {
				List<Pair> pairList = pairResponse.getResult();
				backCategoryId = pairList.get(3).getId();
			}
			orderSubModel.setTypeId(backCategoryId == null ? "" : backCategoryId.toString()); // 三级后台类目
			orderSubModel.setLevelNm("");// 商品类别名称 未完成
			orderSubModel.setItemSmallPic(itemModel.getImage1());// 单品小图标
			orderSubModel.setGoodsBrand(goodsModel.getGoodsBrandId().toString());// 品牌
			orderSubModel.setGoodsModel(itemModel.getAttributeName2());// 型号
			orderSubModel.setGoodsColor(itemModel.getAttributeName1());// 商品颜色
			orderSubModel.setActType(promItemMap.get("promotionType"));// 活动类型
			orderSubModel.setPeriodId(
					promItemMap.get("periodId") == null ? null : Integer.valueOf(promItemMap.get("periodId")));
			orderSubModel.setActId(promItemMap.get("promId"));
			orderSubModel.setBonusTrnDate(orderMainModel.getCommDate());// 支付日期
			orderSubModel.setBonusTrnTime(orderMainModel.getCommTime());// 支付时间
			orderSubModel.setModifyTime(new Date());// 修改时间
			orderSubModel.setTmpStatusId("0000");// 临时状态代码
			orderSubModel.setCommDate(orderMainModel.getCommDate());// 业务日期
			orderSubModel.setCommTime(orderMainModel.getCommTime());// 业务时间
			orderSubModel.setBonusType(goodsModel.getPointsType());// 积分类型
			orderSubModel.setSingleBonus(goodsPaywayModel.getGoodsPoint());// 积分
			orderSubModel.setSinglePrice(goodsPrice);// 20150122 hwh 修改
			orderSubModel.setGoodssendFlag("0");// 发货标记 0－未发货[默认] 1－已发货 2－已签收
			orderSubModel.setEUpdateStatus("0");// 插入订单状态更新接口标志位 0:初始化
			// 1：更新成功 2：更新失败
			orderSubModel.setIntegraltypeId(goodsModel.getPointsType());// 积分类型
			orderSubModel.setMemberLevel(goodsPaywayModel.getMemberLevel());// 价格等级
			orderSubModel.setCardtype("C");// 借记卡信用卡标识 C：信用卡 Y：借记卡
			orderSubModel.setCustCartId("0");// 购物车id
			orderSubModel.setCustType(null);// vip优先发货客户等级
			orderSubModel.setSpecShopno(goodsPaywayModel.getCategoryNo());// 邮购分期费率类别码
			orderSubModel.setReserved1(vendorInfoDto.getUnionPayNo());// 银联商户号(发给清算系统的)
			/** 短信渠道增加优惠券 start **/
			if (couponInfo != null && 0 == i) {
				orderSubModel.setVoucherNo(couponInfo.getPrivilegeId());// 优惠劵编号
				orderSubModel.setVoucherNm(couponInfo.getPrivilegeName());// 优惠券名称
				if (null != privilegeMoneyBD) {// 优惠券金额
					orderSubModel.setVoucherPrice(privilegeMoneyBD);
				} else {
					orderSubModel.setVoucherPrice(new BigDecimal(0));// 由于此字段非空，因此必须传默认值
				}
			} else {
				orderSubModel.setVoucherPrice(new BigDecimal(0));
				orderSubModel.setVoucherNo("");
			}
			/** 短信渠道增加优惠券 end **/

			orderSubModel.setGoodsAttr1(itemModel.getAttributeKey1());// 商品属性一
			orderSubModel.setGoodsAttr2(itemModel.getAttributeKey2());// 商品属性二
			orderSubModel.setDelFlag(Contants.DEL_FLAG_0);// 逻辑删除标志0未删1已删
			orderSubModel.setFenefit(new BigDecimal(0));
			orderSubModel.setO2oExpireFlag(0);
			orderSubModel.setRemindeFlag(0);
			orderSubModel.setMiaoshaActionFlag(0);
			// orderSubModel.setOrder_succ_time(orderMainModel.getCreateTime());
			orderSubDetailDto.addOrderSubModel(orderSubModel);

			// 处理订单处理历史明细表
			OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
			orderDoDetailModel.setOrderId(orderSubModel.getOrderId());
			orderDoDetailModel.setDoTime(orderSubModel.getCreateTime());
			orderDoDetailModel.setDoUserid(orderSubModel.getCreateOper());
			orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_3);// 用户类型0：系统用户[批量]1：内部用户[cc]2：供应商3：持卡人
			orderDoDetailModel.setStatusId(orderSubModel.getCurStatusId());
			orderDoDetailModel.setStatusNm(orderSubModel.getCurStatusNm());
			orderDoDetailModel.setMsgContent("");
			orderDoDetailModel.setDoDesc("短信下单");
			orderDoDetailModel.setCreateOper(orderSubModel.getCreateOper());// 创建人
			orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);// 逻辑删除标记为(0未删除，1已删除)
			orderSubDetailDto.addOrderDoDetailModel(orderDoDetailModel);
		}
		log.info("mal401广发下单小订单设置结束");
		return orderSubDetailDto;
	}

	private OrderSubDetailDto createOrderInfosJF(OrderMainModel orderMainModel, OrderMainDto orderMainDto,
			String custType, String memberName) {
		log.info("mal401积分下单小订单设置开始");
		OrderSubDetailDto orderSubDetailDto = new OrderSubDetailDto();

		String itemCode = orderMainDto.getItemCode();
		ItemModel itemModel = orderMainDto.getItemModelMap().get(itemCode);
		GoodsModel goodsModel = orderMainDto.getGoodsInfo().get(itemCode);
		TblGoodsPaywayModel goodsPaywayModel = orderMainDto.getGoodsPaywayModelMap().get(itemCode);
		VendorInfoDto vendorInfoDto = orderMainDto.getVendorInfoDtoMap().get(itemCode);

		for (int i = 0; i < orderMainModel.getTotalNum(); i++) {
			// 组装小订单
			OrderSubModel orderSubModel = new OrderSubModel();
			String orderMainId = orderMainModel.getOrdermainId();
			orderSubModel.setOrderId(orderMainId + StringUtils.leftPad(String.valueOf(i + 1), 2, "0"));
			orderSubModel.setOrdermainId(orderMainModel.getOrdermainId());
			orderSubModel.setOrderIdHost(idGenarator.orderSerialNo());
			orderSubModel.setOperSeq(new Integer(0));// 业务订单同步序号
			orderSubModel.setOrdertypeId(orderMainModel.getOrdertypeId());
			orderSubModel.setOrdertypeNm(orderMainModel.getOrdertypeNm());
			orderSubModel.setPaywayCode(goodsPaywayModel.getPaywayCode());// 支付方式代码
			// 支付方式代码
			// 0001: 现金
			// 0002: 积分
			// 0003: 积分+现金
			// 0004: 手续费
			// 0005: 现金+手续费
			// 0006: 积分+手续费
			// 0007: 积分+现金+手续费
			String paywayName = "";
			if (goodsPaywayModel.getPaywayCode().equals("0001")) {
				paywayName = "现金";
			} else if (goodsPaywayModel.getPaywayCode().equals("0002")) {
				paywayName = "积分";
			} else if (goodsPaywayModel.getPaywayCode().equals("0003")) {
				paywayName = "积分+现金";
			} else if (goodsPaywayModel.getPaywayCode().equals("0004")) {
				paywayName = "手续费";
			} else if (goodsPaywayModel.getPaywayCode().equals("0005")) {
				paywayName = "现金+手续费";
			} else if (goodsPaywayModel.getPaywayCode().equals("0006")) {
				paywayName = "积分+手续费";
			} else if (goodsPaywayModel.getPaywayCode().equals("0007")) {
				paywayName = "积分+现金+手续费";
			}
			orderSubModel.setPaywayNm(paywayName);// 支付方式名称 未完成
			orderSubModel.setCardno(orderMainModel.getCardno());// 卡号
			orderSubModel.setVerifyFlag("");// 下单验证标记
			orderSubModel.setVendorId(goodsModel.getVendorId());// 供应商代码
			orderSubModel.setVendorSnm(vendorInfoDto.getSimpleName());// 供应商名称简写
			orderSubModel.setSourceId(orderMainModel.getSourceId());// 渠道代码
			orderSubModel.setSourceNm(orderMainModel.getSourceNm());// 渠道名称
			orderSubModel.setGoodsCode(goodsModel.getCode());
			orderSubModel.setGoodsId(itemModel.getCode());// 商品代码
			orderSubModel.setGoodsPaywayId(goodsPaywayModel.getGoodsPaywayId());// 商品支付编码
			orderSubModel.setGoodsNum(new Integer(1));// 商品数量
			orderSubModel.setGoodsNm(goodsModel.getName());// 商品名称
			orderSubModel.setCurrType("156");// 商品币种
			orderSubModel.setExchangeRate(new BigDecimal(100));// 对人民币的汇率值
			orderSubModel.setGoodssendFlag("0");// 发货标记
			orderSubModel.setGoodsaskforFlag("0");// 请款标记
			orderSubModel.setSpecShopnoType("");// 特店类型
			orderSubModel.setPayTypeNm("");// 佣金代码名称
			orderSubModel.setIncCode("");// 手续费率代码
			orderSubModel.setIncCodeNm("");// 手续费名称
			orderSubModel.setStagesNum(new Integer("1"));// 现金[或积分]分期数
			orderSubModel.setCommissionType("");// 佣金计算类别
			orderSubModel.setCommissionRate(new BigDecimal(0));// 佣金区间佣金率(不包含%)
			orderSubModel.setCommission(new BigDecimal(0));// 佣金金额【与币种一致】
			orderSubModel.setBonusTotalvalue(goodsPaywayModel.getGoodsPoint());// 积分总数
			orderSubModel.setCalMoney(
					goodsPaywayModel.getCalMoney() == null ? new BigDecimal(0) : goodsPaywayModel.getCalMoney());// 清算总金额
			orderSubModel.setOrigMoney(new BigDecimal(0));// 原始现金总金额
			orderSubModel.setTotalMoney(
					goodsPaywayModel.getGoodsPrice() == null ? new BigDecimal(0) : goodsPaywayModel.getGoodsPrice());// 现金总金额
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
			orderSubModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0301);// 当前状态代码
			orderSubModel.setCurStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);// 当前状态名称
			orderSubModel.setCreateOper(orderMainModel.getCreateOper());// 创建操作员ID
			orderSubModel.setCreateTime(orderMainModel.getCreateTime());// 创建时间
			orderSubModel.setVersionNum(new Integer(0));// 记录更新控制版本号
			orderSubModel.setGoodsType(goodsModel.getGoodsType());// 商品类别ID
			if ("00".equals(goodsModel.getGoodsType())) {
				orderSubModel.setGoodsTypeName("实物");
			} else if ("01".equals(goodsModel.getGoodsType())) {
				orderSubModel.setGoodsTypeName("虚拟");
			} else if ("02".equals(goodsModel.getGoodsType())) {
				orderSubModel.setGoodsTypeName("O2O");
			}
			orderSubModel.setMemberName(memberName); // 客户姓名

			// 数据库非必输字段
			orderSubModel.setMerId(vendorInfoDto.getMerId());// 小商户号
			// 后台类目
			Long backCategoryId = null;
			Response<List<Pair>> pairResponse = goodsService.findCategoryByGoodsCode(itemModel.getGoodsCode());
			if (pairResponse.isSuccess() && pairResponse.getResult() != null) {
				List<Pair> pairList = pairResponse.getResult();
				backCategoryId = pairList.get(3).getId();
			}
			orderSubModel.setTypeId(backCategoryId == null ? "" : backCategoryId.toString()); // 三级后台类目
			orderSubModel.setLevelNm("");// 商品类别名称 未完成
			orderSubModel.setItemSmallPic(itemModel.getImage1());// 单品小图标
			orderSubModel.setGoodsBrand(goodsModel.getGoodsBrandId().toString());// 品牌
			orderSubModel.setGoodsModel(itemModel.getAttributeName2());// 型号
			orderSubModel.setGoodsColor(itemModel.getAttributeName1());// 商品颜色
			orderSubModel.setActType("");// 活动类型
			orderSubModel.setBonusTrnDate(orderMainModel.getCommDate());// 支付日期
			orderSubModel.setBonusTrnTime(orderMainModel.getCommTime());// 支付时间
			orderSubModel.setModifyTime(new Date());// 修改时间
			orderSubModel.setTmpStatusId("0000");// 临时状态代码
			orderSubModel.setCommDate(orderMainModel.getCommDate());// 业务日期
			orderSubModel.setCommTime(orderMainModel.getCommTime());// 业务时间
			// 分期价格
			orderSubModel.setBonusType(goodsModel.getPointsType());// 积分类型
			orderSubModel.setSingleBonus(goodsPaywayModel.getGoodsPoint());// 积分
			orderSubModel.setSinglePrice(
					goodsPaywayModel.getGoodsPrice() == null ? new BigDecimal(0) : goodsPaywayModel.getGoodsPrice());// 单价
			orderSubModel.setGoodssendFlag("0");// 发货标记 0－未发货[默认] 1－已发货 2－已签收
			orderSubModel.setEUpdateStatus("0");// 插入订单状态更新接口标志位 0:初始化
			// 1：更新成功 2：更新失败
			orderSubModel.setIntegraltypeId(goodsModel.getPointsType());// 积分类型
			orderSubModel.setMemberLevel(goodsPaywayModel.getMemberLevel());// 价格等级
			orderSubModel.setCardtype("C");// 借记卡信用卡标识 C：信用卡 Y：借记卡
			orderSubModel.setCustCartId("0");// 购物车id
			orderSubModel.setCustType(custType);// vip优先发货客户等级
			orderSubModel.setVoucherPrice(new BigDecimal(0));
			orderSubModel.setVoucherNo("");
			orderSubModel.setGoodsAttr1(itemModel.getAttributeKey1());// 商品属性一
			orderSubModel.setGoodsAttr2(itemModel.getAttributeKey2());// 商品属性二
			orderSubModel.setDelFlag(Contants.DEL_FLAG_0);// 逻辑删除标志0未删1已删
			orderSubModel.setFenefit(new BigDecimal(0));
			orderSubModel.setO2oExpireFlag(0);
			orderSubModel.setRemindeFlag(0);
			orderSubModel.setMiaoshaActionFlag(0);
			// orderSubModel.setOrder_succ_time(orderMainModel.getCreateTime());
			orderSubDetailDto.addOrderSubModel(orderSubModel);

			// 处理订单历史表
			OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
			orderDoDetailModel.setOrderId(orderSubModel.getOrderId());
			orderDoDetailModel.setDoTime(orderSubModel.getCreateTime());
			orderDoDetailModel.setDoUserid(orderSubModel.getCreateOper());
			orderDoDetailModel.setUserType(Contants.VENDOR_USER_TYPE_3);
			orderDoDetailModel.setStatusId(orderSubModel.getCurStatusId());
			orderDoDetailModel.setStatusNm(orderSubModel.getCurStatusNm());
			orderDoDetailModel.setMsgContent("");
			orderDoDetailModel.setDoDesc("短信下单");
			orderDoDetailModel.setCreateOper(orderSubModel.getCreateOper());// 创建人
			orderDoDetailModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);// 逻辑删除标记为(0未删除，1已删除)
			orderSubDetailDto.addOrderDoDetailModel(orderDoDetailModel);
		}
		log.info("mal401积分下单小订单设置结束");
		return orderSubDetailDto;
	}

	private OrderMainModel createOrderMainFQ(String create_oper, BigDecimal totalPrice, SMSOrderAdd sMSOrderAdd) {
		log.info("MAL401广发下单开始设置大订单");
		OrderMainModel orderMainModel = new OrderMainModel();
		// 客户姓名
		String custName = sMSOrderAdd.getCustName();
		// 卡号
		String cardNo = sMSOrderAdd.getCardNo();
		// 证件号
		String contIdCard = sMSOrderAdd.getContIdCard();
		// 证件类型
		String contIdType = sMSOrderAdd.getContIdType();
		// 收货人姓名
		String csgName = sMSOrderAdd.getCsgName();
		// 收货人手机
		String csgMoblie = sMSOrderAdd.getCsgMoblie();
		// 收货人固话
		String csgPhone = sMSOrderAdd.getCsgPhone();
		// 省
		String csgProvince = sMSOrderAdd.getCsgProvince();
		// 市
		String csgCity = sMSOrderAdd.getCsgCity();
		// 区
		String csgBorough = sMSOrderAdd.getCsgBorough();
		// 街道详细地址
		String csgAddress = sMSOrderAdd.getCsgAddress();
		// 邮政编码
		String deliveryPost = sMSOrderAdd.getDeliveryPost();
		// 送货时间
		String sendTime = sMSOrderAdd.getSendTime();
		// 备注
		String ordermainDesc = sMSOrderAdd.getOrdermainDesc();
		// 是否合并支付
		String isMerge = sMSOrderAdd.getIsMerge();
		// 商品数量
		String goodsNm = sMSOrderAdd.getGoodsNm();
		// 大订单号
		String orderMainid = idGenarator.orderMainId(Contants.CHANNEL_SMS_CODE);
		orderMainModel.setOrdermainId(orderMainid);
		orderMainModel.setOrdertypeId(Contants.BUSINESS_TYPE_FQ);
		orderMainModel.setOrdertypeNm("乐购业务");
		orderMainModel.setCardno(cardNo);
		orderMainModel.setPermLimit(new BigDecimal(0));// 永久额度（默认0）
		orderMainModel.setCashLimit(new BigDecimal(0));// 取现额度（默认0）
		orderMainModel.setStagesLimit(new BigDecimal(0));// 分期额度（默认0）
		orderMainModel.setSourceId(Contants.CHANNEL_SMS_CODE);// 订购渠道（下单渠道）
		orderMainModel.setSourceNm("短信");// 渠道名称
		orderMainModel.setTotalNum(new Integer(goodsNm));// 商品总数量
		orderMainModel.setTotalBonus(0l);// 商品总积分数量
		orderMainModel.setTotalIncPrice(new BigDecimal(0));// 商品总手续费价格（无用）
		orderMainModel.setLockedFlag("0");// 订单锁标记（锁住订单，订单成功后解锁，解锁才能退货）
		Date d = DateTime.now().toDate();
		orderMainModel.setCreateTime(d);// 创建时间
		orderMainModel.setCreateOper(create_oper);// 创建操作员ID
		orderMainModel.setContIdType(contIdType);// 订货人证件类型
		orderMainModel.setContIdcard(contIdCard);// 订货人证件号码
		orderMainModel.setContNm(custName);// 订货人姓名
		orderMainModel.setContNmPy("");// 订货人姓名拼音
		orderMainModel.setContPostcode(deliveryPost);// 订货人邮政编码
		orderMainModel.setContAddress(csgAddress);// 订货人详细地址
		orderMainModel.setContMobPhone(csgMoblie);// 订货人手机
		orderMainModel.setContHphone(csgPhone);// 订货人家里电话
		orderMainModel.setCsgName(csgName);// 收货人姓名
		orderMainModel.setCsgPostcode(deliveryPost);// 收货人邮政编码
		orderMainModel.setCsgAddress(csgAddress);// 收货人详细地址
		orderMainModel.setCsgPhone1(csgMoblie);// 收货人电话一
		orderMainModel.setCsgPhone2(csgPhone);// 收货人电话二
		orderMainModel.setBpCustGrp(sendTime);// 送货时间
		orderMainModel.setOrdermainDesc(ordermainDesc);// 备注
		orderMainModel.setCommDate(DateHelper.getyyyyMMdd(d));// 业务日期
		orderMainModel.setCommTime(DateHelper.getHHmmss(d));// 业务时间
		orderMainModel.setAcctAddFlag("1");// 收货地址是否是帐单地址
		orderMainModel.setCustSex("");// 性别
		orderMainModel.setCustEmail("");
		orderMainModel.setCsgProvince(csgProvince);// 省
		orderMainModel.setCsgCity(csgCity);// 市
		orderMainModel.setCsgBorough(csgBorough);// 区
		orderMainModel.setMerId(merchId);// 大商户号
		orderMainModel.setSerialNo(idGenarator.orderSerialNo());// 流水号
		orderMainModel.setEUpdateStatus("0");// 插入订单状态更新接口标志位 0:初始化 1：更新成功2：更新失败
		orderMainModel.setTotalPrice(totalPrice);
		orderMainModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0301);// 状态
		orderMainModel.setCurStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);//
		orderMainModel.setIsmerge(isMerge);
		orderMainModel.setPsFlag("");// 空或0:vmi没同步过，1:vmi同步过
		orderMainModel.setCheckStatus("0");// 0:初始状态 1:已经对账
		orderMainModel.setIntegraltypeId(null);
		orderMainModel.setIsInvoice("0");// 默认不开发票
		orderMainModel.setInvoice("");// 发票抬头
		orderMainModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);// 逻辑删除标记为(0未删除，1已删除)
		log.info("MAL401广发下单设置大订单结束");
		return orderMainModel;
	}

	private OrderMainModel createOrderMainJF(OrderMainDto orderMainDto, PriceLevelVo priceLevelVo,
			SMSOrderAdd smsOrderAdd, String create_oper) {
		log.info("MAL401积分下单开始设置大订单");
		OrderMainModel orderMainModel = new OrderMainModel();
		int goodsNum = new Integer(smsOrderAdd.getGoodsNm());
		String itemCode = orderMainDto.getItemCode();
		GoodsModel goodsModel = orderMainDto.getGoodsInfo().get(itemCode);
		TblGoodsPaywayModel goodsPaywayModel = orderMainDto.getGoodsPaywayModelMap().get(itemCode);
		// 礼品积分定价
		long totalPoint = goodsPaywayModel.getGoodsPoint() * goodsNum;
		BigDecimal goodPrice = goodsPaywayModel.getGoodsPrice() == null ? new BigDecimal(0)
				: goodsPaywayModel.getGoodsPrice();

		String orderMainid = idGenarator.orderMainId(Contants.CHANNEL_SMS_CODE);// 大订单号
		orderMainModel.setOrdermainId(orderMainid);
		orderMainModel.setOrdertypeId(Contants.BUSINESS_TYPE_JF);
		orderMainModel.setOrdertypeNm("积分业务");
		orderMainModel.setCardno(smsOrderAdd.getCardNo());
		orderMainModel.setPermLimit(new BigDecimal(0));// 永久额度（默认0）
		orderMainModel.setCashLimit(new BigDecimal(0));// 取现额度（默认0）
		orderMainModel.setStagesLimit(new BigDecimal(0));// 分期额度（默认0）
		orderMainModel.setSourceId(Contants.CHANNEL_SMS_CODE);// 订购渠道（下单渠道）
		orderMainModel.setSourceNm("短信");// 渠道名称
		orderMainModel.setTotalNum(goodsNum);// 商品总数量
		orderMainModel.setTotalBonus(totalPoint);// 商品总积分数量
		orderMainModel.setTotalIncPrice(new BigDecimal(0));// 商品总手续费价格（无用）
		orderMainModel.setLockedFlag("0");// 订单锁标记（锁住订单，订单成功后解锁，解锁才能退货）
		Date d = DateTime.now().toDate();
		orderMainModel.setCreateTime(d);// 创建时间
		orderMainModel.setCreateOper(create_oper);// 创建操作员ID
		orderMainModel.setContIdType(smsOrderAdd.getContIdType());// 订货人证件类型
		orderMainModel.setContIdcard(smsOrderAdd.getContIdCard());// 订货人证件号码
		orderMainModel.setContNm(smsOrderAdd.getCustName());// 订货人姓名
		orderMainModel.setContNmPy("");// 订货人姓名拼音
		orderMainModel.setContPostcode(smsOrderAdd.getDeliveryPost());// 订货人邮政编码
		orderMainModel.setContAddress(smsOrderAdd.getCsgAddress());// 订货人详细地址
		orderMainModel.setContMobPhone(smsOrderAdd.getCsgMoblie());// 订货人手机
		orderMainModel.setContHphone(smsOrderAdd.getCsgPhone());// 订货人家里电话
		orderMainModel.setCsgName(smsOrderAdd.getCsgName());// 收货人姓名
		orderMainModel.setCsgPostcode(smsOrderAdd.getDeliveryPost());// 收货人邮政编码
		orderMainModel.setCsgAddress(smsOrderAdd.getCsgAddress());// 收货人详细地址
		orderMainModel.setCsgPhone1(smsOrderAdd.getCsgPhone());// 收货人电话一
		orderMainModel.setCsgPhone2(smsOrderAdd.getCsgPhone());// 收货人电话二
		orderMainModel.setBpCustGrp(smsOrderAdd.getSendTime());// 送货时间
		orderMainModel.setOrdermainDesc(smsOrderAdd.getOrdermainDesc());// 备注
		orderMainModel.setCommDate(DateHelper.getyyyyMMdd(d));// 业务日期
		orderMainModel.setCommTime(DateHelper.getHHmmss(d));// 业务时间
		orderMainModel.setAcctAddFlag("1");// 收货地址是否是帐单地址
		orderMainModel.setCustSex("");// 性别
		orderMainModel.setCustEmail("");
		orderMainModel.setCsgProvince(smsOrderAdd.getCsgProvince());// 省
		orderMainModel.setCsgCity(smsOrderAdd.getCsgCity());// 市
		orderMainModel.setCsgBorough(smsOrderAdd.getCsgBorough());// 区
		orderMainModel.setMerId(merchId);// 大商户号
		orderMainModel.setSerialNo(idGenarator.orderSerialNo());// 流水号
		orderMainModel.setEUpdateStatus("0");// 插入订单状态更新接口标志位 0:初始化 1：更新成功2：更新失败
		orderMainModel.setTotalPrice(goodPrice.multiply(new BigDecimal(goodsNum)));
		orderMainModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0301);// 状态
		orderMainModel.setCurStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);//
		orderMainModel.setIsmerge(smsOrderAdd.getIsMerge());
		orderMainModel.setPsFlag("");// 空或0:vmi没同步过，1:vmi同步过
		orderMainModel.setCheckStatus("0");// 0:初始状态 1:已经对账
		orderMainModel.setIntegraltypeId(goodsModel.getPointsType());
		orderMainModel.setIsInvoice("0");// 默认不开发票
		orderMainModel.setInvoice("");// 发票抬头
		orderMainModel.setDelFlag(Contants.DEL_INTEGER_FLAG_0);// 逻辑删除标记为(0未删除，1已删除)
		log.info("MAL401积分下单设置大订单结束");
		return orderMainModel;
	}

	/**
	 * 支付起停控制
	 * 
	 * @return
	 */
	private boolean isQT() {
		boolean flag = true;
		Response<List<TblParametersModel>> parametersListResponse = businessService.findJudgeQT("JF", "04");
		if (!parametersListResponse.isSuccess()) {
			throw new ResponseException(Contants.ERROR_CODE_500, "TblParametersServiceImpl.query.error");
		}
		List<TblParametersModel> parametersModelList = parametersListResponse.getResult();
		if (parametersModelList != null && parametersModelList.size() > 0) {// 手机渠道积分不允许支付
			TblParametersModel tblParametersModel = parametersModelList.get(0);
			String openCloseFlag = tblParametersModel.getOpenCloseFlag() == null ? ""
					: tblParametersModel.getOpenCloseFlag().toString();// 启动停止标示: 0:启动,1:停止
			if ("1".equals(openCloseFlag)) {
				flag = false;
			}
		}
		return flag;
	}

	/**
	 * 校验卡板
	 * 
	 * @param goodsboard
	 * @param areaboard
	 * @param cardBoard
	 * @return true符合 false不符合
	 */
	private boolean judgeCardBoard(String goodsboard, String areaboard, String cardBoard) {
		log.info("进入判断卡板方法，商品卡板：" + goodsboard + "分区卡板：" + areaboard + "客户卡板：" + cardBoard);
		if (!Strings.isNullOrEmpty(goodsboard)) {
			goodsboard = goodsboard.trim();
			if (goodsboard.equals(Contants.GOODS_CARDBORD_NO_LIMIT)) {// 商品卡板WWWW，没限制
				return true;
			} // 客户卡板为空
			if (Strings.isNullOrEmpty(cardBoard)) {
				return false;
			} // 判断客户卡板是否符合商品卡板
			String[] goods_board = goodsboard.split(",");
			for (int i = 0; i < goods_board.length; i++) {
				if (Strings.isNullOrEmpty(goods_board[i])) {
					continue;
				}
				if (cardBoard.contains(goods_board[i].trim())) {
					return true;
				}
			}
			return false;
		} else {
			if (Strings.isNullOrEmpty(areaboard)) {// 分区卡板为空
				return true;
			} // 客户卡板为空
			if (Strings.isNullOrEmpty(cardBoard)) {
				return false;
			} // 判断客户卡板是否符合分区卡板
			String[] area_board = areaboard.split(",");
			for (int i = 0; i < area_board.length; i++) {
				if (Strings.isNullOrEmpty(area_board[i])) {
					continue;
				}
				if (cardBoard.contains(area_board[i].trim())) {// 分区卡板不为空
					return true;
				}
			}
			return false;
		}
	}

	/**
	 * 判断卡板是否符合
	 */
	private boolean judgeCardBoard(String goodsboard, String areaboard, List<String> custBoard) {
		// 如果礼品卡板不为空
		if (!Strings.isNullOrEmpty(goodsboard)) {
			goodsboard = goodsboard.trim();
			if (goodsboard.equals(Contants.GOODS_CARDBORD_NO_LIMIT)) {// 商品卡板WWWW，没限制
				return true;
			}
			if (null == custBoard || custBoard.isEmpty()) {
				return false;
			} // 判断客户卡板是否符合商品卡板
			String[] goods_board = goodsboard.split(",");
			for (int i = 0; i < goods_board.length; i++) {
				if (Strings.isNullOrEmpty(goods_board[i])) {
					continue;
				}
				if (custBoard.contains(goods_board[i].trim())) {
					return true;
				}
			}
			return false;
		} else {// 如果礼品卡板为空
			if (Strings.isNullOrEmpty(areaboard)) {// 分区卡板为空
				return true;
			}
			if (null == custBoard || custBoard.size() == 0) {
				return false;
			} // 判断客户卡板是否符合分区卡板
			String[] area_board = areaboard.split(",");
			for (int i = 0; i < area_board.length; i++) {
				if (Strings.isNullOrEmpty(area_board[i])) {
					continue;
				}
				if (custBoard.contains(area_board[i].trim())) {// 分区卡板不为空
					return true;
				}
			}
			return false;
		}
	}

	/**
	 * 积分类型
	 */
	private boolean judgeCardJftype(String integral_type, List<String> custJftype) {
		if (custJftype != null && custJftype.contains(integral_type.trim())) {
			return true;
		}
		return false;
	}

	/**
	 * 发起ops分期订单申请
	 * 
	 * @param orderSubModels
	 * @param orderMainModel
	 * @param orderMainDto
	 * @return
	 */
	private SMSOrderAddReturn gotobps(List<OrderSubModel> orderSubModels, OrderMainModel orderMainModel,
			OrderMainDto orderMainDto) {
		SMSOrderAddReturn smsOrderAddReturn = new SMSOrderAddReturn();
		List<Map<String, Object>> orderResultMaps = Lists.newArrayList();
		String itemCode = orderMainDto.getItemCode();
		ItemModel itemModel = orderMainDto.getItemModelMap().get(itemCode);
		GoodsModel goodsModel = orderMainDto.getGoodsInfo().get(itemCode);
		List<TblOrderExtend1Model> tblOrderExtend1Models = new ArrayList<>();
		try {
			String returnCode = "";
			for (OrderSubModel orderSubModel : orderSubModels) {
				Map<String, Object> orderResultMap = Maps.newHashMap();

				TblOrderExtend1Model orderExtend1Model = new TblOrderExtend1Model();
				orderExtend1Model.setOrderId(orderSubModel.getOrderId());
				orderExtend1Model.setExtend1("1");
				orderExtend1Model.setExtend2(DateHelper.date2string(new Date(), DateHelper.YYYYMMDDHHMMSS));// 记录向bps发起请求的时间
				tblOrderExtend1Models.add(orderExtend1Model);

				/** 如果现金部分为0，并且是走新流程，则不调用BPS的接口，直接处理为支付成功 --大机补充需求start */
				StagingRequestResult stagingRequestResult = null;
				if (orderSubModel.getTotalMoney().compareTo(BigDecimal.ZERO) == 0) {// 如果现金部分为0，并且是走新流程
					stagingRequestResult = new StagingRequestResult();
					stagingRequestResult.setErrorCode("0000");// Bps返回的错误码
					stagingRequestResult.setApproveResult("0010");// Bps返回的返回码0000-全额
																	// 0010-逐期
																	// 0100-拒绝
																	// 0200-转人工
																	// 0210-异常转人工
					stagingRequestResult.setFollowDir("");// 后续流转方向0-不流转 1-流转
					stagingRequestResult.setCaseId("");// BPS工单号
					stagingRequestResult.setSpecialCust("");// 是否黑灰名单 0-黑名单
															// 1-灰名单 2-其他
					stagingRequestResult.setReleaseType("");// 释放类型
					stagingRequestResult.setRejectcode("");// 拒绝代码
					stagingRequestResult.setAprtcode("");// 逐期代码
					stagingRequestResult.setOrdernbr("00000000000");// 核心订单号、银行订单号:
																	// 默认11个0
					/** 如果现金部分为0，并且是走新流程，则不调用BPS的接口，直接处理为支付成功 --大机补充需求end */

				} else {// 如果现金部分不为0 或者走旧流程，调用BPS的接口
					StagingRequest stagingRequest = new StagingRequest();
					stagingRequest.setSrcCaseId(orderSubModel.getOrderId());
					stagingRequest.setInterfaceType("0");
					stagingRequest.setCardnbr(orderMainModel.getCardno());
					stagingRequest.setIdNbr(orderMainModel.getContIdcard());
					stagingRequest.setChannel("070");
					stagingRequest.setProject("");
					stagingRequest.setRequestType("2");
					stagingRequest.setCaseType("0500");
					stagingRequest.setSubCaseType("0501");
					stagingRequest.setCreator(orderMainModel.getCreateOper()==null?"System": orderMainModel.getCreateOper());

					stagingRequest.setBookDesc(orderMainModel.getCsgPhone1());
					stagingRequest.setReceiveMode("02");
					stagingRequest.setAddr(orderMainModel.getCsgProvince() + orderMainModel.getCsgCity()
							+ orderMainModel.getCsgBorough() + orderMainModel.getCsgAddress());// 省+市+区+详细地址
					stagingRequest.setPostcode(orderMainModel.getCsgPostcode());
					stagingRequest.setDrawer(orderMainModel.getInvoice());
					stagingRequest.setSendCode("D");

					stagingRequest.setRegulator("1");
					stagingRequest.setSmsnotice("1");
					stagingRequest.setSmsPhone("");
					stagingRequest.setContactNbr1(orderMainModel.getCsgPhone1());
					stagingRequest.setContactNbr2(orderMainModel.getCsgPhone2());
					stagingRequest.setSbookid(orderMainModel.getOrdermainId());
					stagingRequest.setBbookid("");
					stagingRequest.setReservation("0");
					stagingRequest.setReserveTime("");
					stagingRequest.setCerttype(orderMainModel.getContIdType());
					stagingRequest.setUrgentLvl("0200");
					stagingRequest.setMichelleId("");
					stagingRequest.setOldBankId("");
					stagingRequest.setProductCode(itemModel.getMid());
					stagingRequest.setProductName(orderSubModel.getGoodsNm());
					stagingRequest.setPrice(orderSubModel.getCalMoney());// 商品总价
					stagingRequest.setColor(orderSubModel.getGoodsColor());
					stagingRequest.setAmount("1");
					stagingRequest.setSumAmt(orderSubModel.getTotalMoney());
					stagingRequest.setSuborderid(orderSubModel.getOrderId());
					stagingRequest.setFirstPayment(new BigDecimal(0));
					stagingRequest.setBills(orderSubModel.getStagesNum().toString());
					stagingRequest.setPerPeriodAmt(orderSubModel.getIncTakePrice());
					stagingRequest.setSupplierCode(orderSubModel.getVendorId());

					// 获取分期费率
					Response<TblVendorRatioModel> vendorRatioResponse = vendorService
							.findRatioByVendorId(orderSubModel.getVendorId(), orderSubModel.getStagesNum());
					if (!vendorRatioResponse.isSuccess()) {
						throw new RuntimeException(vendorRatioResponse.getError());
					}
					TblVendorRatioModel vendorRatio = vendorRatioResponse.getResult();
					Response<VendorInfoModel> vendorResponse = vendorService
							.findVendorById(orderSubModel.getVendorId());
					if (!vendorResponse.isSuccess()) {
						throw new RuntimeException(vendorResponse.getError());
					}
					VendorInfoModel vendor = vendorResponse.getResult();
					BigDecimal totalMony = orderSubModel.getTotalMoney();
					vendorRatioMessage(stagingRequest, vendorRatio, vendor, String.valueOf(totalMony));

					stagingRequest.setRecommendCardnbr("");
					stagingRequest.setRecommendname("");
					stagingRequest.setRecommendCerttype("");
					stagingRequest.setRecommendid("");
					stagingRequest.setPrevCaseId("");
					stagingRequest.setCustName(orderMainModel.getContNm());// 订货人姓名
					stagingRequest.setIncomingTel("");
					stagingRequest.setPresentName(goodsModel.getGiftDesc());
					stagingRequest.setOrdermemo("正常订单");
					stagingRequest.setMemo("");
					stagingRequest.setForceTransfer("");
					stagingRequest.setSupplierName(orderSubModel.getVendorSnm());
					stagingRequest.setOldBankId("");
					stagingRequest.setSupplierDesc("");
					stagingRequest.setRecommendCardnbr("");
					stagingRequest.setRecommendname("");
					stagingRequest.setRecommendid("");
					stagingRequest.setReceiveName(orderMainModel.getCsgName());
					stagingRequest.setMerchantCode("");// 特店号暂时约定传空
					stagingRequest.setAcceptAmt(orderSubModel.getTotalMoney());
					String favorableType = "";// 优惠类型
					BigDecimal deductAmt = new BigDecimal(0);// 抵扣金额
					if (Strings.isNullOrEmpty(orderSubModel.getVoucherNo())) {
						favorableType = "01";
						deductAmt = orderSubModel.getVoucherPrice();
					}
					if (orderSubModel.getBonusTotalvalue() != null
							&& orderSubModel.getBonusTotalvalue().longValue() != 0) {
						favorableType = "02";
						deductAmt = orderSubModel.getUitdrtamt();
					}
					if (!Strings.isNullOrEmpty(orderSubModel.getVoucherNo())
							&& (orderSubModel.getBonusTotalvalue() != null
									&& orderSubModel.getBonusTotalvalue().longValue() != 0)) {
						favorableType = "03";
						deductAmt = orderSubModel.getVoucherPrice().add(orderSubModel.getUitdrtamt());
					}
					if (Strings.isNullOrEmpty(orderSubModel.getVoucherNo())
							&& (orderSubModel.getBonusTotalvalue() == null
									|| orderSubModel.getBonusTotalvalue().longValue() == 0)) {
						favorableType = "00";
					}
					stagingRequest.setFavorableType(favorableType);// 优惠类型
					stagingRequest.setDeductAmt(deductAmt);// 抵扣金额
					// 调用接口BP0005 OPS受理
					stagingRequestResult = stagingRequestService.getStagingRequest(stagingRequest);

				}
				if (!"000011".equals(returnCode) &&
						(Contants.bps_approveResult_fq.equals(stagingRequestResult.getApproveResult())
								||Contants.bps_approvetype_success.equals(stagingRequestResult.getApproveResult()))) {
					returnCode = MallReturnCode.RETURN_SUCCESS_CODE;
				}else {
					returnCode = "000011" ;
				}
				orderResultMap.put("returnGateWayEnvolopeVo", stagingRequestResult);
				orderResultMap.put("tblOrder", orderSubModel);
				orderResultMaps.add(orderResultMap);
			}
			smsOrderAddReturn.setReturnCode(returnCode);
			smsOrderAddReturn.setReturnCode(MallReturnCode.getReturnDes(returnCode));
		} catch (Exception e) {// 如果连bps报异常，订单状态不做修改，等待状态回查
			log.error("调用ops分期申请接口失败:", e);
			smsOrderAddReturn.setReturnCode("000027");
			smsOrderAddReturn.setReturnDes("调用ops分期申请接口失败");
		}
		// 根据BPS返回信息处理分期订单
		try {
			orderChannelService.dealFQorderBpswithTX(orderMainModel, orderResultMaps, tblOrderExtend1Models);
		} catch (Exception e) {
			log.error("根据BPS返回信息处理分期订单出错: ", e);
			smsOrderAddReturn.setReturnCode("000027");
			smsOrderAddReturn.setReturnDes("数据库操作异常");
			return smsOrderAddReturn;
		}

		return smsOrderAddReturn;
	}

	/**
	 * 配合信用卡大机改造BP0005接口新增字段-接口工程公共方法
	 * 
	 * @param stagingRequest
	 * @param vendorRatio
	 * @param vendor
	 * @param totalMoney
	 */
	private void vendorRatioMessage(StagingRequest stagingRequest, TblVendorRatioModel vendorRatio,
			VendorInfoModel vendor, String totalMoney) {
		if (vendorRatio != null) {
			stagingRequest.setFixedFeeHTFlag(vendorRatio.getFixedfeehtFlag());
			stagingRequest.setFixedAmtFee(vendorRatio.getFixedamtFee());
			stagingRequest.setFeeRatio1(vendorRatio.getFeeratio1());
			stagingRequest.setRatio1Precent(vendorRatio.getRatio1Precent());
			stagingRequest.setFeeRatio2(vendorRatio.getFeeratio2());
			stagingRequest.setRatio2Precent(vendorRatio.getRatio2Precent());
			stagingRequest.setFeeRatio2Bill(vendorRatio.getFeeratio2Bill());
			stagingRequest.setFeeRatio3(vendorRatio.getFeeratio3());
			stagingRequest.setRatio3Precent(vendorRatio.getRatio3Precent());
			stagingRequest.setFeeRatio3Bill(vendorRatio.getFeeratio3Bill());
			stagingRequest.setReducerateFrom(vendorRatio.getReducerateFrom());
			stagingRequest.setReducerateTo(vendorRatio.getReducerateTo());
			stagingRequest.setReduceHandingFee(vendorRatio.getReducerate());
			stagingRequest.setHtFlag(vendorRatio.getHtflag());
			// 如果“首尾付本金”(HTCAPITAL)大于现金金额(tblOrder.getTotalMoney())，默认送现金金额，如果小于等于现金金额,就送首尾付本金值--大机补充需求
			String htcapital = "";
			BigDecimal TotalMoneyDe = null;
			if (!"".equals(totalMoney)) {
				TotalMoneyDe = new BigDecimal(totalMoney);
			}
			if (vendorRatio.getHtant() == null || TotalMoneyDe == null) {
				htcapital = vendorRatio.getHtant() == null ? ""
						: String.valueOf(vendorRatio.getHtant().setScale(2, BigDecimal.ROUND_DOWN));
			} else {
				int compareResult = vendorRatio.getHtant().compareTo(TotalMoneyDe);
				if (compareResult > 0) {// “首尾付本金”(HTCAPITAL)大于现金金额(tblOrder.getTotalMoney())，送现金金额
					htcapital = String.valueOf(TotalMoneyDe.setScale(2, BigDecimal.ROUND_DOWN));
				} else {// 如果小于等于现金金额,就送首尾付本金值
					htcapital = String.valueOf(vendorRatio.getHtant().setScale(2, BigDecimal.ROUND_DOWN));
				}
			}
			stagingRequest.setHtCapital(new BigDecimal(htcapital));
		}
		if (vendor != null) {
			// 虚拟特店号
			stagingRequest.setVirtualStore(vendor.getVirtualVendorId());
		}
	}
}