package cn.com.cgbchina.restful.provider.service.order;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import cn.com.cgbchina.item.model.*;
import cn.com.cgbchina.item.service.*;
import lombok.extern.slf4j.Slf4j;

import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.item.dto.CouponScaleDto;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.model.PromotionPayWayModel;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.item.service.PromotionPayWayService;
import cn.com.cgbchina.related.model.TblParametersModel;
import cn.com.cgbchina.related.service.BusinessService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.RelaySmsReturn;
import cn.com.cgbchina.rest.provider.model.order.SmsInfo;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.RelaySmsReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.SmsInfoVO;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.coupon.CouponInfo;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequest;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequestResult;
import cn.com.cgbchina.rest.visit.model.point.QueryPointResult;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfo;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfoResult;
import cn.com.cgbchina.rest.visit.model.user.UserInfo;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.rest.visit.service.payment.StagingRequestService;
import cn.com.cgbchina.rest.visit.service.point.PointService;
import cn.com.cgbchina.trade.dto.OrderMainDto;
import cn.com.cgbchina.trade.dto.OrderSubDetailDto;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.TblOrderExtend1Model;
import cn.com.cgbchina.trade.service.DealO2OOrderService;
import cn.com.cgbchina.trade.service.OrderSendForO2OService;
import cn.com.cgbchina.trade.service.PriceSystemService;
import cn.com.cgbchina.trade.service.RestOrderService;
import cn.com.cgbchina.trade.service.SmsMessageService;
import cn.com.cgbchina.trade.service.TblOrderMainService;
import cn.com.cgbchina.user.dto.VendorInfoDto;
import cn.com.cgbchina.user.model.ACardCustToelectronbankModel;
import cn.com.cgbchina.user.model.ACustToelectronbankModel;
import cn.com.cgbchina.user.model.LocalCardRelateModel;
import cn.com.cgbchina.user.model.TblVendorRatioModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.ACardCustToelectronbankService;
import cn.com.cgbchina.user.service.ACustToelectronbankService;
import cn.com.cgbchina.user.service.LocalCardRelateService;
import cn.com.cgbchina.user.service.VendorService;
import cn.com.cgbchina.web.utils.Tools;

import com.google.common.base.Strings;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.search.Pair;

/**
 * DXZF01 上行短信内容实时转发 从xml对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 */
@Service
@TradeCode(value = "DXZF01")
@Slf4j
public class RelaySmsProvideServiceImpl implements SoapProvideService<SmsInfoVO, RelaySmsReturnVO> {
	@Resource
	private BusinessService businessService;
	@Resource
	private SmsTemplateService smsTemplateService;
	@Resource
	private ItemService itemService;
	@Resource
	private GoodsService goodsService;
	@Resource
	private GoodsPayWayService goodsPayWayService;
	@Resource
	private PriceSystemService priceSystemService;
	@Resource
	private ACustToelectronbankService aCustToelectronbankService;
	@Resource
	private ACardCustToelectronbankService aCardCustToelectronbankService;
	@Resource
	private PointsPoolService pointsPoolService;
	@Resource
	private TblOrderMainService tblOrderMainService;
	@Resource
	private MallPromotionService mallPromotionService;
	@Resource
	private PromotionPayWayService promotionPayWayService;
	@Resource
	private IdGenarator idGenarator;
	@Resource
	private VendorService vendorService;
	@Resource
	private StagingRequestService stagingRequestService;
	@Resource
	private PaymentService paymentService;
	@Resource
	private OrderSendForO2OService orderSendForO2OService;
	@Resource
	private SmsMessageService smsMessageService;
	@Resource
	private CouponScaleService couponScaleService;
	@Resource
	private LocalCardRelateService localCardRelateService;
	@Resource
	private PointService pointService;
	@Resource
	private DealO2OOrderService dealO2OOrderService;
	@Resource
	private OrderChannelService orderChannelService;
	@Resource
	private RestOrderService restOrderService;
	@Value("#{app.merchId}")
	private String merchId;

	@Override
	public RelaySmsReturnVO process(SoapModel<SmsInfoVO> model, SmsInfoVO content) {
		SmsInfo smsInfo = BeanUtils.copy(content, SmsInfo.class);
		RelaySmsReturn relaySmsReturn = new RelaySmsReturn();
		RelaySmsReturnVO relaySmsReturnVO = new RelaySmsReturnVO();
		/********* 支付起停控制begin *********/
		if (!isQT()) {
			relaySmsReturnVO.setReturnCode("0076");
			relaySmsReturnVO.setErrormsg("短信渠道不允许支付");
			return relaySmsReturnVO;
		}
		/********* 支付起停控制end *********/
		String mobile = smsInfo.getMobile();// 手机号码
		String cardNo = "";
		SmspInfModel smspInfModel = null;
		try{
			StringBuilder cardTemp = new StringBuilder();
			smspInfModel = getSmspInf(mobile, cardTemp);
			cardNo = cardTemp.toString();
		}catch(Exception e){
			log.error("获取短信维护信息出错", e);
			relaySmsReturnVO.setReturnCode("0107");
			relaySmsReturnVO.setReturnDes("客户没有资格");
			return relaySmsReturnVO;
		}

		Date nowDate = new Date();
		Date endDate = smspInfModel.getEndDate();
		if (nowDate.after(endDate)) {
			// 资格客户但时间过期，发送短信--您本次订购失败，如有疑问请致电4008895508-2-1咨询。
			// 发送短信
			smsMessageService.sendOverDueMsg(mobile);
			relaySmsReturnVO.setReturnCode("0108");
			relaySmsReturnVO.setReturnDes("短信模板已过期！");
			return relaySmsReturnVO;
		}

		String itemCode = Strings.nullToEmpty(smspInfModel.getItemCode());
		String pointType = "";// 默认为普通积分
		try {
			// 通过卡号在本地（南航白金卡）查询证件号
			String contIdCard = priceSystemService.getCertNbrByCard(cardNo);
			if (Strings.isNullOrEmpty(contIdCard)) {
				relaySmsReturnVO.setReturnCode("0110");
				relaySmsReturnVO.setReturnDes("无法获取证件号");
				return relaySmsReturnVO;
			}

			UserInfo user = orderChannelService.getUserByCertNo(contIdCard);
			if (user == null || Strings.isNullOrEmpty(user.getCustomerId())) {// 调用个人网银查客户号异常
				user = new UserInfo();
				user.setCustomerId("");
				user.setCertNo(contIdCard);
			}
			
			// 校验
			OrderMainDto orderMainDto = check(itemCode, cardNo);
			if (orderMainDto != null && !Strings.isNullOrEmpty(orderMainDto.getReturnCode())) {
				log.info("DXZF01广发下单验证失败");
				relaySmsReturnVO.setReturnDes(orderMainDto.getReturnDes());
				relaySmsReturnVO.setReturnCode(orderMainDto.getReturnCode());
				return relaySmsReturnVO;
			}
			log.info("DXZF01广发下单验证成功");
			
			ItemModel itemModel = orderMainDto.getItemModelMap().get(itemCode);
			GoodsModel goodsModel = orderMainDto.getGoodsInfo().get(itemCode);
			TblGoodsPaywayModel goodsPaywayModel = orderMainDto.getGoodsPaywayModelMap().get(itemCode);
			BigDecimal voucherPrice = smspInfModel.getVoucherPrice();// 优惠券金额
			String couponId = smspInfModel.getCouponId();// 优惠券项目编号
			String isPoint = smspInfModel.getIfPoint();// 是否使用积分
			BigDecimal goodsPrice = goodsPaywayModel.getGoodsPrice();// 商品价格

			
			boolean isPrivilege = false;// 默认没有优惠券或者积分
			// 优惠券金额大于0，则需要使用优惠券
			log.info("DXZF01广发下单优惠券获取");
			CouponInfo couponInfo = null;
			if (voucherPrice.compareTo(BigDecimal.ZERO) > 0) {
				couponInfo = checkCoupon(couponId, user, orderMainDto, voucherPrice, goodsPrice, mobile);
				if (couponInfo != null) {
					relaySmsReturnVO.setReturnCode(orderMainDto.getReturnCode());
					relaySmsReturnVO.setReturnDes(orderMainDto.getReturnDes());
					return relaySmsReturnVO;
				}
				isPrivilege = true;
			} else {
				voucherPrice = new BigDecimal(0);
			}

			log.info("DXZF01广发下单积分获取");
			Response<List<ACustToelectronbankModel>> custResponse = aCustToelectronbankService.findUserBirthInfo(contIdCard);
			if(!custResponse.isSuccess() || custResponse.getResult().isEmpty()){
				throw new Exception("查询客户基础信息出错或不存在");
			}
			ACustToelectronbankModel aCustToelectronbankModel = custResponse.getResult().get(0);
			// isPoint为1-是，则需要使用积分
			if ("1".equals(isPoint)) {
				orderMainDto = calUseBonus(orderMainDto, aCustToelectronbankModel, cardNo, voucherPrice, goodsPrice, String.valueOf(itemModel.getBestRate()), smsInfo.getSorceSenderNo());
				if (orderMainDto != null && !Strings.isNullOrEmpty(orderMainDto.getReturnCode())) {
					relaySmsReturnVO.setReturnDes(orderMainDto.getReturnDes());
					relaySmsReturnVO.setReturnCode(orderMainDto.getReturnCode());
					return relaySmsReturnVO;
				}
				if (orderMainDto.getJfTotalNum() > 0) {
					isPrivilege = true;
					pointType = "1";
				}
			}

			// 构建订单
			BigDecimal totalPrice = goodsPrice.subtract(voucherPrice).subtract(orderMainDto.getDeduction());// 现金总金额
			OrderMainModel orderMainModel = createOrderMainFQ(orderMainDto, Strings.nullToEmpty(user.getCustomerId()), cardNo, totalPrice, mobile, aCustToelectronbankModel);
			OrderSubDetailDto orderSubDetailDto = createOrderInfos(orderMainModel, orderMainDto, couponInfo, pointType);

			// 保存订单
			log.info("DXZF01广发订单保存开始");
			Response<Boolean> response = restOrderService.saveYGOrder(orderMainModel,
					orderSubDetailDto.getOrderSubModelList(), orderSubDetailDto.getOrderDoDetailModelList(), orderMainDto,
					null);
			if (!response.isSuccess()) {
				throw new RuntimeException(response.getError());
			}
			
			log.info("DXZF01广发订单支付开始");
			List<OrderSubModel> orderSubModels = new ArrayList<>();
			if (isPrivilege) {// 使用优惠券或者积分需要走电子支付
				orderSubModels = orderChannelService.payFQOrder(orderMainModel, orderSubDetailDto.getOrderSubModelList(), "0000");
			} else {
				List<OrderSubModel> orderLists = orderSubDetailDto.getOrderSubModelList();
				for (OrderSubModel orderSubModel : orderLists) {
					orderSubModels.add(orderSubModel);
				}
			}

			relaySmsReturn = gotobps(orderSubModels, orderMainModel, goodsModel, itemModel);
				
			// 020业务与商城供应商平台对接 ,当更新订单信息后，进行O2O推送处理，本单需求只做广发下单部分，积分暂时不支持。
			Response<BaseResult> baseResultResponse = dealO2OOrderService.dealO2OOrdersAfterPaySucc(
					orderMainModel.getOrdermainId(), null);
			if (!baseResultResponse.isSuccess()) {
				throw new Exception(baseResultResponse.getError());
			}
		} catch (Exception e) {
			log.error("DXZF01出现异常：", e);
			relaySmsReturnVO.setReturnCode("0009");
			relaySmsReturnVO.setReturnDes("系统繁忙，请稍后再试");
			return relaySmsReturnVO;
		}
		return BeanUtils.copy(relaySmsReturn, RelaySmsReturnVO.class);
	}

	/**
	 * 获取短信维护信息
	 * @param mobile
	 * @param cardTemp 
	 * @return
	 */
	private SmspInfModel getSmspInf(String mobile, StringBuilder cardTemp) {
		Response<List<SmspCustModel>> res = smsTemplateService.findAllByPhone(mobile);
		if (!res.isSuccess()) {
			throw new RuntimeException("客户没有资格");
		}
		
		List<SmspCustModel> smsCustpList = res.getResult();
		List<String> ids = Lists.newArrayList();
		for (SmspCustModel smspCustModel : smsCustpList) {
			ids.add(smspCustModel.getId().toString());
			if (!Strings.isNullOrEmpty(smspCustModel.getCardNo())) {
				cardTemp = cardTemp.append(smspCustModel.getCardNo());
			}
		}
		if (ids.isEmpty()) {
			throw new RuntimeException("客户没有资格");
		}
		Response<SmspInfModel> smspInfModelResponse = smsTemplateService.findAllByIds(ids);
		if (!smspInfModelResponse.isSuccess() || smspInfModelResponse.getResult() == null) {
			throw new RuntimeException("客户没有资格");
		}
		
		SmspInfModel smspInfModel = smspInfModelResponse.getResult();
		return smspInfModel;
	}

	/**
	 * DXZF01接口校验
	 * 
	 * @param itemCode
	 * @return
	 */
	private OrderMainDto check(String itemCode, String cardNo) {
		OrderMainDto orderMainDto = new OrderMainDto();
		int goodsNum = 1;

		// 根据商品编码查询出商品
		ItemModel itemModel = itemService.findByCodeAll(itemCode).getResult();

		// 如果找不到商品
		if (itemModel == null) {// 如果找不到商品
			orderMainDto.setReturnCode("000031");
			orderMainDto.setReturnDes("找不到该商品");
			return orderMainDto;
		}
		GoodsModel goodsModel = goodsService.findById(itemModel.getGoodsCode()).getResult();
		// 控制短信下单只支持分期商品,根据goodsId查询出的tblGoodsPayway为表中最高分期数的那条记录
		TblGoodsPaywayModel goodsPaywayModel = goodsPayWayService.findMaxGoodsPayway(itemCode).getResult();
		Response<VendorInfoDto> vendorInfoDtoResponse = vendorService.findById(goodsModel.getVendorId());
		VendorInfoDto vendorInfoDto = vendorInfoDtoResponse.getResult();

		// 共同检验
		orderMainDto = checkCommon(itemModel, goodsModel, goodsPaywayModel, vendorInfoDtoResponse, vendorInfoDto);
		if (!Strings.isNullOrEmpty(orderMainDto.getReturnCode())) {
			return orderMainDto;
		}
		
//		if(!orderChannelService.checkThreeCard(goodsModel.getCode(), cardNo)){
//			orderMainDto.setReturnCode("000071");
//			orderMainDto.setReturnDes("该卡第三级卡产品不满足购买此商品条件");
//			return orderMainDto;
//		}

		// ===========================活动信息检验============================
		Response<MallPromotionResultDto> mallPromotionResponse = mallPromotionService
				.findPromByItemCodes("1", itemModel.getCode(), Contants.SOURCE_ID_MESSAGE);
		MallPromotionResultDto mallPromotionResultDto = mallPromotionResponse.getResult();
		if (mallPromotionResultDto != null) {//存在正在进行的活动
			if(mallPromotionResultDto.getPromType() == Contants.PROMOTION_PROM_TYPE_4){
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
			}else {
				orderMainDto.setReturnCode("000074");
				orderMainDto.setReturnDes("暂时只支持普通和团购商品购买");
				return orderMainDto;
			}
		}
		// ================================活动检验结束===============================

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
	
	private OrderMainDto checkCommon(ItemModel itemModel, GoodsModel goodsModel, TblGoodsPaywayModel goodsPaywayModel,
			Response<VendorInfoDto> vendorInfoDtoResponse, VendorInfoDto vendorInfoDto) {
		OrderMainDto orderMainDto = new OrderMainDto();
		// 如果找不到商品
		if (goodsModel == null) {
			orderMainDto.setReturnCode("000031");
			orderMainDto.setReturnDes("找不到该商品");
			return orderMainDto;
		}

		if (Contants.IS_INNER_0.equals(goodsModel.getIsInner())) {// 内宣商品
			orderMainDto.setReturnCode("000074");
			orderMainDto.setReturnDes("暂时支持普通和团购商品购买");
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
			if(curDate.after(offShelfSmsDate)){
				if(onShelfSmsDate.before(offShelfSmsDate) || onShelfSmsDate.after(curDate)){
					orderMainDto.setReturnCode("000033");
					orderMainDto.setReturnDes("现在日期不在商品有效期之内");
					return orderMainDto;
				}
			}else{
				if(curDate.before(onShelfSmsDate)){
					orderMainDto.setReturnCode("000033");
					orderMainDto.setReturnDes("现在日期不在商品有效期之内");
					return orderMainDto;
				}
			}
		}

		// 检测商品数量
		int goodsBacklog = itemModel.getStock().intValue();
		int goodsBacklogI = goodsBacklog - 1;// 扣减后的商品数量
		if (goodsBacklogI < 0) {// 如果扣除商品数量后实际库存小于0
			orderMainDto.setReturnCode("000038");
			orderMainDto.setReturnDes("产品已售罄，请您挑选其他的产品。");
			return orderMainDto;
		}
		
		if (goodsPaywayModel == null) {
			orderMainDto.setReturnCode("000031");
			orderMainDto.setReturnDes("找不到该商品");
			return orderMainDto;
		}

//		if (Contants.IS_INNER_0.equals(goodsPaywayModel.getIsAction())) {// 内宣商品
//			orderMainDto.setReturnCode("000074");
//			orderMainDto.setReturnDes("暂时支持普通和团购商品购买");
//			return orderMainDto;
//		}
		if ("d".equalsIgnoreCase(goodsPaywayModel.getIscheck())) {// 如果支付方式已被删除
			orderMainDto.setReturnCode("000016");
			orderMainDto.setReturnDes("该支付方式已经删除");
			return orderMainDto;
		}
		
		return orderMainDto;
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
			String openCloseFlag = tblParametersModel.getOpenCloseFlag() == null ? "" : tblParametersModel
					.getOpenCloseFlag().toString();// 启动停止标示: 0:启动,1:停止
			if ("1".equals(openCloseFlag)) {
				flag = false;
			}
		}
		return flag;
	}


	// 检验优惠券
	private CouponInfo checkCoupon(String couponId, UserInfo user, OrderMainDto orderMainDto,
			BigDecimal voucherPrice, BigDecimal goodsPrice, String mobile) {
		GoodsModel goodsModel = orderMainDto.getGoodsInfo().get(orderMainDto.getItemCode());
		CouponInfo couponInfo = null;
		if (StringUtils.isEmpty(couponId)) {
			orderMainDto.setReturnCode("0111");
			orderMainDto.setReturnDes("优惠券项目编号不合法");
		}
		// 证件号，商品信息，优惠券金额，一个
		List<CouponInfo> couponList = orderChannelService.queryCouponInfo(couponId, user, goodsModel, voucherPrice, true);
		if (null != couponList && couponList.size() > 0) {// 存在优惠券
			couponInfo = (CouponInfo) couponList.get(0);
			String limitMoney = String.valueOf(couponInfo.getLimitMoney());
			if (limitMoney.length() == 0) {
				orderMainDto.setReturnCode("0113");
				orderMainDto.setReturnDes("优惠券下限金额有误");
			} else {
				try {
					// 下限金额除以100得到真实金额
					BigDecimal limitMoneyBd = new BigDecimal(limitMoney);
					if (goodsPrice.compareTo(limitMoneyBd) < 0) {
						orderMainDto.setReturnCode("0114");
						orderMainDto.setReturnDes("商品价格未达到优惠券下限金额");
					}
				} catch (Exception e) {
					orderMainDto.setReturnCode("0009");
					orderMainDto.setReturnDes("系统异常");
				}
			}
		} else {
			// 短信通知
			smsMessageService.sendConponMsg(mobile);
			orderMainDto.setReturnCode("0098");
			orderMainDto.setReturnDes("优惠券金额或者项目编号不匹配");
		}
		return couponInfo;
	}


	// 计算使用的积分
	private OrderMainDto calUseBonus(OrderMainDto orderMainDto, ACustToelectronbankModel aCustToelectronbankModel, String cardNo,
			BigDecimal voucherPrice, BigDecimal goodsPrice, String bsRate, String senderSN) {
		Long bonusVal = 0l;// 客户本次下单使用的积分
		BigDecimal bonusDisPrice = new BigDecimal("0.00");// 积分抵扣的金额
		PointPoolModel pointPoolModel = pointsPoolService.getCurMonthInfo().getResult(); // tblGoodsInfBySqlDao.getPointPool();
		Long singlePoint = 0l; // 单位积分
		if (pointPoolModel != null) {
			Long usedPoint = pointPoolModel.getUsedPoint();
			Long maxPoint = pointPoolModel.getMaxPoint();
			singlePoint = pointPoolModel.getSinglePoint();
			if (singlePoint <= 0) {
				orderMainDto.setJfTotalNum(bonusVal);
				orderMainDto.setDeduction(bonusDisPrice);
				return orderMainDto;
			}
			if (maxPoint - usedPoint > 0) {
				// 计算使用的积分
				BigDecimal bestRate = new BigDecimal(bsRate);// 最佳倍率
				Map<String, String> custLevel = getCustLevelInfo(aCustToelectronbankModel);
				BigDecimal custPointRate = new BigDecimal(String.valueOf(custLevel.get("custPointRate")));// 客户级别折扣比例
				long custBonus = getCustTotalBonus(cardNo);// 客户名下总积分
				// 商品价格-优惠券金额
				BigDecimal subPrice = goodsPrice.subtract(voucherPrice);
				// 商品抵扣百分比金额 = 商品价格X最佳倍率
				BigDecimal bestPrice = goodsPrice.multiply(bestRate);

				if (subPrice.compareTo(BigDecimal.ZERO) == -1) {
					orderMainDto.setReturnCode("0112");
					orderMainDto.setReturnDes("商品价格或优惠券金额有误");
					return orderMainDto;
				}

				BigDecimal singlePoint_bd = new BigDecimal(singlePoint);
				BigDecimal useBonus = null;// 使用积分
				if (subPrice.compareTo(bestPrice) <= 0) {// 扣减优惠券后的金额(商品价格-优惠券金额)<=商品抵扣百分比金额(商品价格X最佳倍率)
					// 使用积分 = (商品价格-优惠券金额)X单位积分
					useBonus = subPrice.multiply(singlePoint_bd);
				} else {// 扣减优惠券后的金额(商品价格-优惠券金额)>商品抵扣百分比金额(商品价格X最佳倍率)
					// 使用积分 = (商品价格X最佳倍率)X单位积分
					useBonus = bestPrice.multiply(singlePoint_bd);
				}
				useBonus = useBonus.divide(singlePoint_bd, BigDecimal.ROUND_DOWN).setScale(0, BigDecimal.ROUND_DOWN)
						.multiply(singlePoint_bd);// 使用积分需为单位积分的最大整数倍
				BigDecimal custDisBonus = useBonus.multiply(custPointRate);// 客户折扣后的积分=使用积分X客户级别折扣
				BigDecimal custBonus_bd = new BigDecimal(custBonus);
				if (custBonus_bd.compareTo(custDisBonus) >= 0) {// 客户总积分>=客户折扣后的积分
					bonusVal = custDisBonus.longValue();
					bonusDisPrice = useBonus.divide(singlePoint_bd, BigDecimal.ROUND_DOWN).setScale(0,
							BigDecimal.ROUND_DOWN);
				} else {// 客户总积分<客户折扣后的积分
					BigDecimal disSinglePoint = singlePoint_bd.multiply(custPointRate).setScale(0, BigDecimal.ROUND_UP);// 折扣单位积分需为整数
					if (disSinglePoint.compareTo(BigDecimal.ZERO) <= 0) {
						orderMainDto.setJfTotalNum(0l);
						orderMainDto.setDeduction(new BigDecimal("0.00"));
						return orderMainDto;
					}
					BigDecimal bonusVal_bd = custBonus_bd.divide(disSinglePoint, BigDecimal.ROUND_DOWN)
							.setScale(0, BigDecimal.ROUND_DOWN).multiply(disSinglePoint);
					bonusVal = bonusVal_bd.longValue();
					bonusDisPrice = custBonus_bd.divide(disSinglePoint, BigDecimal.ROUND_DOWN).setScale(0,
							BigDecimal.ROUND_DOWN);
				}
			} else {
				// 如果积分池积分小于0，则跳过积分的判断，下单不使用积分
				bonusVal = 0l;
				bonusDisPrice = new BigDecimal("0.00");
			}
			
			pointPoolModel.setUsedPoint(bonusVal * orderMainDto.getGoodsCount());
		}
		
		orderMainDto.setJfTotalNum(bonusVal);
		orderMainDto.setDeduction(bonusDisPrice);
		orderMainDto.setPointPoolModel(pointPoolModel);
		return orderMainDto;
	}

	private Map<String, String> getCustLevelInfo(ACustToelectronbankModel aCustToelectronbankModel) {
		// custLevel :
		// 0-如果没有送证件号码，默认为0；1-普卡/金卡；2-钛金卡/臻享白金卡；3-顶级卡/增值白金卡；4-VIP；5-生日
		// custPointRate: 如果custLevel为0，则默认为0；否则取对应折扣比例
		Map<String, String> returnMap = new HashMap<>();

		String memberLevel = "0000";// 默认金普等级
		String custLevel = "1";// 默认金普等级
		Date birthday = null;
		if (aCustToelectronbankModel != null) {
			String cardLevel = aCustToelectronbankModel.getCardLevelCd();// 卡等级代码
			String VipTp = aCustToelectronbankModel.getVipTpCd();// 客户VIP标志
			birthday = aCustToelectronbankModel.getBirthDay(); // 客户生日
			String certNbr = aCustToelectronbankModel.getCertNbr();// 证件号码
			if (Tools.isEmpty(certNbr)) {
				// 如果没有送证件号码，客户等级为0
				returnMap.put("custLevel", "0");// 客户级别
				returnMap.put("custPointRate", "0");// 客户级别折扣比例
				return returnMap;
			}
			// 通过客户证件号码,客户级别（数据集市提供的数据）,客户标识计算出客户最优等级（商城的客户级别）
			memberLevel = calMemberLevel(certNbr, cardLevel, VipTp);
		} else {
			// 若在本地客户表查不到数据（因该数据会从核心同步过来，但会存在延迟几天），则默认为金普等级
			memberLevel = "0000";
		}
		BigDecimal disc = new BigDecimal(1);
		Response<CouponScaleDto> couponScaleDtoResponse = couponScaleService.findAll();
		CouponScaleDto couponScaleDto = null;
		if (couponScaleDtoResponse.isSuccess()) {
			couponScaleDto = couponScaleDtoResponse.getResult();
		}
		if (couponScaleDto != null) {
			if ("0000".equals(memberLevel)) {
				// 金普
				disc = couponScaleDto.getCommonCard();
				custLevel = "1";
			} else if ("0001".equals(memberLevel)) {
				// 钛金卡 + 臻享白金
				disc = couponScaleDto.getPlatinumCard();
				custLevel = "2";
			} else if ("0002".equals(memberLevel)) {
				// 增值白金卡+顶级卡
				disc = couponScaleDto.getTopCard();
				custLevel = "3";
			} else if ("0003".equals(memberLevel)) {
				// VIP等级
				disc = couponScaleDto.getVIP();
				custLevel = "4";
			}
			if (birthday != null && isBirthday(birthday)) {
				BigDecimal birthDisc = couponScaleDto.getBirthday();
				if (birthDisc.compareTo(disc) < 0) {
					disc = birthDisc;
					custLevel = "5";// 生日
				}
			}
		}
		returnMap.put("custLevel", custLevel);// 客户级别
		returnMap.put("custPointRate", String.valueOf(disc));// 客户级别折扣比例
		return returnMap;
	}

	private String calMemberLevel(String certNbr, String cardLevel, String VipTp) {
		// 格式化客户标识
		if (VipTp != null && VipTp.length() > 2) {
			VipTp = VipTp.substring(0, 2);
		}
		if ("05".equals(cardLevel)) {
			// 若为顶级卡,返回增值白金/顶级级别
			return "0002";
		} else if ("04".equals(cardLevel)) {
			// 若为白金卡,通过卡板代码判断白金等级
			List<ACardCustToelectronbankModel> cardInfoList = aCardCustToelectronbankService.findListByCertNbr(certNbr)
					.getResult();
			if (cardInfoList != null) {

				for (int i = 0; i < cardInfoList.size(); i++) {
					ACardCustToelectronbankModel cardInfoMap = cardInfoList.get(i);
					String cardLevelId = null;// priceSystemDao.getCardRelate(cardInfoMap.getCardFormatNbr());//老库里LOCAL_CARD_RELATE
												// 表没有找到新库中对应的 --maguixin
					Response<LocalCardRelateModel> localCardRelateModelResponse = localCardRelateService
							.findByFormatId(cardInfoMap.getCardFormatNbr());
					if (localCardRelateModelResponse.isSuccess() && localCardRelateModelResponse.getResult() != null) {
						cardLevelId = localCardRelateModelResponse.getResult().getProCode();
					}
					if ("2".equals(cardLevelId)) {
						// 若为增值白金卡板,返回顶级卡级别
						return "0002";
					}
				}
			}
			// 若为普通白金,判断客户标识
			if ("VV".equals(VipTp) || "P1".equals(VipTp)) {
				// 客户标识为VV/P1,提升客户等级为顶级/增值白金等级
				return "0002";
			} else {
				return "0001";
			}
		} else if ("03".equals(cardLevel)) {
			// 若为钛金卡,判断客户标识
			if ("VV".equals(VipTp) || "P1".equals(VipTp)) {
				// 客户标识为VV/P1,提升客户等级为顶级/增值白金等级
				return "0002";
			} else {
				return "0001";
			}
		} else {
			// 若为金卡或普卡,判断客户标识
			if ("VV".equals(VipTp) || "P1".equals(VipTp)) {
				// 客户标识为VV/P1,提升客户等级为顶级/增值白金等级
				return "0002";
			} else if ("P2".equals(VipTp)) {
				// 客户标识为P2,提升客户等级为钛金卡
				return "0001";
			} else if (isVip(VipTp)) {
				// 客户标识为V1/V2/V3,提升客户等级为VIP等级
				return "0003";
			} else {
				// 返回金普卡等级
				return "0000";
			}
		}
	}

	private boolean isVip(String VipTp) {
		// 格式化客户标识
		if (VipTp != null && VipTp.length() > 2) {
			VipTp = VipTp.substring(0, 2);
		}
		if ("VV".equals(VipTp) || "V1".equals(VipTp) || "V2".equals(VipTp) || "V3".equals(VipTp)) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * @ 判断date的月份与当天的月份是否一致
	 */
	private boolean isBirthday(Date date) {
		return DateHelper.isBrithDay(DateHelper.getyyyyMMdd(date));
	}
	
	/**
	 * 调用积分系统获取客户总积分
	 * 
	 * @param cardNo
	 * @return
	 */
	private long getCustTotalBonus(String cardNo) {
		long custTotalBonus = 0;

		// 由于积分系统返回的报文包含翻页信息，有可能需要查询多个页面
		int bonusCurPage = 0;
		int bonusTotalPage = 1;
		QueryPointsInfo queryPointsInfo = null;
		QueryPointResult queryPointResult = null;
		try {
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
					Long account = Long.valueOf(0);
					if (queryPointsInfoResult.getAccount() != null) {
						account = Long.valueOf(queryPointsInfoResult.getAccount().toString());
					}
					custTotalBonus = custTotalBonus + account;
				}
				bonusCurPage++;
				String totalPage = queryPointResult.getTotalPages();
				try {
					bonusTotalPage = Integer.parseInt(totalPage.trim());
				} catch (Exception e) {
					log.error("【DXZF01】流水：转换总页数时出现异常，积分返回总页数："+bonusTotalPage, e);
					throw new Exception(e.getMessage());
				}
			}
		} catch (Exception e) {
			log.error("查询积分系统异常", e);
		}

		return custTotalBonus;
	}

	/**
	 * 获取大订单对象
	 * 
	 * @return
	 */
	private OrderMainModel createOrderMainFQ(OrderMainDto orderMainDto, String create_oper, String cardNo, BigDecimal totalPrice, String csgMoblie,ACustToelectronbankModel aCustToelectronbankModel) {
		log.info("DXZF01广发下单开始设置大订单");
		OrderMainModel orderMainModel = new OrderMainModel();
		String custName = aCustToelectronbankModel.getCustName();// 客户姓名
		String contIdCard = aCustToelectronbankModel.getCertNbr(); // 证件号
		String contIdType = "";// 证件类型
		String csgName = aCustToelectronbankModel.getCustName();// 收货人姓名
		String csgPhone = "";// 收货人固话
		String csgProvince = "";// 省
		String csgCity = "";// 市
		String csgBorough = "";// 区
		String csgAddress = aCustToelectronbankModel.getCustAddr();// 街道详细地址
		String deliveryPost = "";// 邮政编码
		String sendTime = "01";// 送货时间(短信渠道默认选取01)
		String ordermainDesc = "";// 备注
		String isMerge = "0";// 是否合并支付 0:合并（默认） 1:非合并
		String orderMainid = idGenarator.orderMainId(Contants.CHANNEL_SMS_CODE);// 大订单号

		orderMainModel.setOrdermainId(orderMainid);
		orderMainModel.setOrdertypeId(Contants.BUSINESS_TYPE_FQ);
		orderMainModel.setOrdertypeNm("乐购业务");
		orderMainModel.setCardno(cardNo);
		orderMainModel.setPermLimit(new BigDecimal(0));// 永久额度（默认0）
		orderMainModel.setCashLimit(new BigDecimal(0));// 取现额度（默认0）
		orderMainModel.setStagesLimit(new BigDecimal(0));// 分期额度（默认0）
		orderMainModel.setSourceId(Contants.CHANNEL_SMS_CODE);// 订购渠道（下单渠道）
		orderMainModel.setSourceNm("短信");// 渠道名称
		orderMainModel.setTotalNum(orderMainDto.getGoodsCount());// 商品总数量
		orderMainModel.setTotalBonus(orderMainDto.getJfTotalNum());// 商品总积分数量
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
		orderMainModel.setSerialNo(idGenarator.orderSerialNo());// 流水号 //
																
		orderMainModel.setEUpdateStatus("0");// 插入订单状态更新接口标志位 0:初始化 1：更新成功 2：更新失败
		orderMainModel.setTotalPrice(totalPrice);
		orderMainModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0301);// 状态
		orderMainModel.setCurStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);//
		orderMainModel.setIsmerge(isMerge);
		orderMainModel.setPsFlag("");// 空或0:vmi没同步过，1:vmi同步过
		orderMainModel.setCheckStatus("0");// 0:初始状态 1:已经对账
		orderMainModel.setIntegraltypeId(null);
		orderMainModel.setIsInvoice("0");//默认不开发票
		orderMainModel.setInvoice("");// 发票抬头
		orderMainModel.setDelFlag(0);
		log.info("DXZF01广发下单设置大订单结束");
		return orderMainModel;
	}

	/**
	 * 获取子订单以及订单履历记录
	 * @param orderMainModel
	 * @param orderMainDto
	 * @param couponInfo
	 * @param pointType
	 * @return
	 */
	private OrderSubDetailDto createOrderInfos(OrderMainModel orderMainModel, OrderMainDto orderMainDto, CouponInfo couponInfo, String pointType) {
		log.info("DXZF01积分下单小订单设置开始");
		OrderSubDetailDto orderSubDetailDto = new OrderSubDetailDto();
		
		String itemCode = orderMainDto.getItemCode();
		ItemModel itemModel = orderMainDto.getItemModelMap().get(itemCode);
		GoodsModel goodsModel = orderMainDto.getGoodsInfo().get(itemCode);
		TblGoodsPaywayModel goodsPaywayModel = orderMainDto.getGoodsPaywayModelMap().get(itemCode);
		VendorInfoDto vendorInfoDto = orderMainDto.getVendorInfoDtoMap().get(itemCode);
		Map<String, String> promItemMap = new HashMap<>();
		if(orderMainDto.getPromItemMap() != null && !orderMainDto.getPromItemMap().isEmpty()){//活动信息
			promItemMap = orderMainDto.getPromItemMap().get(0);
		}
		Long bonusVal = orderMainDto.getJfTotalNum();
		BigDecimal bonusDisPrice = orderMainDto.getDeduction();
		
		for (int i = 0; i < orderMainModel.getTotalNum(); i++) {
			BigDecimal newGoodsPrice = goodsPaywayModel.getGoodsPrice();
			// 积分抵扣
			if (bonusVal > 0) {
				newGoodsPrice = newGoodsPrice.subtract(bonusDisPrice);
			}
			// 优惠券抵扣
			BigDecimal privilegeMoneyBD = null;// 优惠券金额
			if (null != couponInfo && 0 == i) {// 优惠券不为空，第1个订单
				privilegeMoneyBD = couponInfo.getPrivilegeMoney();
				// 商品价格 - 优惠券金额
				newGoodsPrice = newGoodsPrice.subtract(privilegeMoneyBD);
			}
			BigDecimal newPerStagePrice = newGoodsPrice.divide(new BigDecimal(goodsPaywayModel.getStagesCode()), 2,
					BigDecimal.ROUND_HALF_UP);
			// 组装小订单
			OrderSubModel orderSubModel = new OrderSubModel();
			String orderMainId = orderMainModel.getOrdermainId();
			orderSubModel.setOrderId(orderMainId + StringUtils.leftPad(String.valueOf(i+1), 2, "0"));
			orderSubModel.setOrdermainId(orderMainId);
			orderSubModel.setOrderIdHost(idGenarator.orderSerialNo());
			orderSubModel.setOperSeq(Integer.valueOf(0));// 业务订单同步序号
			orderSubModel.setOrdertypeId(orderMainModel.getOrdertypeId());
			orderSubModel.setOrdertypeNm(orderMainModel.getOrdertypeNm());
			orderSubModel.setPaywayCode(goodsPaywayModel.getPaywayCode());
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
			orderSubModel.setItemSmallPic(itemModel.getImage1());// 单品小图标
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
			orderSubModel.setStagesNum(goodsPaywayModel.getStagesCode());// 现金[或积分]分期数
			orderSubModel.setCommissionType("");// 佣金计算类别
			orderSubModel.setCommissionRate(new BigDecimal(0));// 佣金区间佣金率(不包含%)
			orderSubModel.setCommission(new BigDecimal(0));// 佣金金额【与币种一致】
			orderSubModel.setCalMoney(goodsPaywayModel.getGoodsPrice());// 清算总金额
			orderSubModel.setOrigMoney(new BigDecimal(0));// 原始现金总金额
			orderSubModel.setTotalMoney(newGoodsPrice);// 现金总金额
			orderSubModel.setIncWay("00");// 手续费获取方式
			orderSubModel.setIncRate(new BigDecimal(0));// 手续费率(不包含%)
			orderSubModel.setIncMoney(new BigDecimal(0));// 手续费总金额

			orderSubModel.setUitfeeflg(new Integer("0"));// 手续费减免期数
			orderSubModel.setUitfeedam(new BigDecimal(0));// 手续费减免金额
			orderSubModel.setUitdrtuit(new Integer("0"));// 本金减免期数
			orderSubModel.setUitdrtamt(new BigDecimal(0));// 本金减免金额
			orderSubModel.setIncBackPrice(new BigDecimal(0));// 手续费退回指定金额
			orderSubModel.setIncTakePrice(newPerStagePrice);// 设置分期价格
			orderSubModel.setCreditFlag("");// 授权额度不足处理方式
			orderSubModel.setCalWay("");// 退货方式
			orderSubModel.setLockedFlag("0");// 订单锁标记
			orderSubModel.setVendorOperFlag("0");// 供应商操作标记
			orderSubModel.setCurStatusId(Contants.SUB_ORDER_STATUS_0301);// 当前状态代码
			orderSubModel.setCurStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);// 当前状态名称
			orderSubModel.setCreateOper(orderMainModel.getCreateOper());// 创建操作员ID
			orderSubModel.setCreateTime(orderMainModel.getCreateTime());// 创建时间
			orderSubModel.setVersionNum(new Integer(0));// 记录更新控制版本号
			orderSubModel.setMemberName(orderMainModel.getContNm());
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
			orderSubModel.setGoodsBrand(goodsModel.getGoodsBrandId().toString());// 品牌
			orderSubModel.setGoodsModel(itemModel.getAttributeName2());// 型号
			orderSubModel.setGoodsColor(itemModel.getAttributeName1());// 商品颜色
			orderSubModel.setGoodsType(goodsModel.getGoodsType());//商品类型
			//商品类型名称
			if("00".equals(goodsModel.getGoodsType())){
				orderSubModel.setGoodsTypeName("实物");
			}else if("01".equals(goodsModel.getGoodsType())){
				orderSubModel.setGoodsTypeName("虚拟");
			}else if("02".equals(goodsModel.getGoodsType())){
				orderSubModel.setGoodsTypeName("O2O");
			}
			
			orderSubModel.setActType(promItemMap.get("promotionType"));// 活动类型
			orderSubModel.setPeriodId(promItemMap.get("periodId") == null? null : Integer.valueOf(promItemMap.get("periodId")));
			orderSubModel.setActId(promItemMap.get("promId"));
			orderSubModel.setBonusTrnDate(orderMainModel.getCommDate());// 支付日期
			orderSubModel.setBonusTrnTime(orderMainModel.getCommTime());// 支付时间
			orderSubModel.setModifyTime(new Date());// 修改时间
			orderSubModel.setTmpStatusId("0000");// 临时状态代码
			orderSubModel.setCommDate(orderMainModel.getCommDate());// 业务日期
			orderSubModel.setCommTime(orderMainModel.getCommTime());// 业务时间
			orderSubModel.setBonusType(goodsModel.getPointsType());// 积分类型
			orderSubModel.setSinglePrice(newGoodsPrice);
			orderSubModel.setGoodssendFlag("0");// 发货标记 0－未发货[默认] 1－已发货 2－已签收
			orderSubModel.setEUpdateStatus("0");// 插入订单状态更新接口标志位 0:初始化
			// 1：更新成功 2：更新失败
			orderSubModel.setMemberLevel(goodsPaywayModel.getMemberLevel());// 价格等级
			orderSubModel.setCardtype("C");// 借记卡信用卡标识 C：信用卡 Y：借记卡
			orderSubModel.setCustCartId("0");// 购物车id
			orderSubModel.setCustType(null);// vip优先发货客户等级
			orderSubModel.setSpecShopno(goodsPaywayModel.getCategoryNo());// 邮购分期费率类别码
			orderSubModel.setReserved1(vendorInfoDto.getUnionPayNo());// 银联商户号(发给清算系统的)
			orderSubModel.setIntegraltypeId(pointType);// 积分类型
			orderSubModel.setSingleBonus(bonusVal);// 单个商品对应的积分数
			orderSubModel.setBonusTotalvalue(bonusVal);// 积分总数
			orderSubModel.setUitdrtamt(bonusDisPrice);// 积分抵扣金额
			orderSubModel.setDelFlag("0");
			orderSubModel.setRemindeFlag(0);
			orderSubModel.setO2oExpireFlag(0);
			orderSubModel.setFenefit(new BigDecimal(0.00));
			orderSubModel.setMiaoshaActionFlag(0);
			if (null != couponInfo && 0 == i) {
				orderSubModel.setVoucherNo(Tools.trim((String) couponInfo.getPrivilegeId()));// 优惠劵编号
				orderSubModel.setVoucherNm(Tools.trim((String) couponInfo.getPrivilegeName()));// 优惠券名称
				if (null != privilegeMoneyBD) {// 优惠券金额
					orderSubModel.setVoucherPrice(privilegeMoneyBD);
				} else {
					orderSubModel.setVoucherPrice(new BigDecimal(0));// 由于此字段非空，因此必须传默认值
				}
			} else {
				orderSubModel.setVoucherPrice(new BigDecimal(0));
				orderSubModel.setVoucherNo("");
			}
			orderSubModel.setGoodsAttr1(itemModel.getAttributeKey1());// 商品属性一
			orderSubModel.setGoodsAttr2(itemModel.getAttributeKey2());// 商品属性二
//			orderSubModel.setOrder_succ_time(orderMainModel.getCreateTime());

			orderSubDetailDto.addOrderSubModel(orderSubModel);

			// 处理订单历史表
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
		log.info("DXZF01广发下单小订单设置结束");
		return orderSubDetailDto;
	}

	/**
	 * 发起ops分期订单申请
	 * 
	 * @param orderSubModels
	 * @param orderMainModel
	 * @param goodsModel
	 * @param itemModel
	 * @return
	 */
	private RelaySmsReturn gotobps(List<OrderSubModel> orderSubModels, OrderMainModel orderMainModel, GoodsModel goodsModel,
			ItemModel itemModel) {
		RelaySmsReturn relaySmsReturn = new RelaySmsReturn();
		List<Map<String, Object>> orderResultMaps = Lists.newArrayList();
		List<TblOrderExtend1Model> tblOrderExtend1Models = new ArrayList<>();
		try {
			for (OrderSubModel orderSubModel : orderSubModels) {
				Map<String, Object> orderResultMap = Maps.newHashMap();

				TblOrderExtend1Model orderExtend1Model = new TblOrderExtend1Model();
				orderExtend1Model.setOrderId(orderSubModel.getOrderId());
				orderExtend1Model.setExtend1("1");
				orderExtend1Model.setExtend2(DateHelper.getyyyyMMddHHmmss(new Date()));// 记录向bps发起请求的时间
				tblOrderExtend1Models.add(orderExtend1Model);

				/** 如果现金部分为0，并且是走新流程，则不调用BPS的接口，直接处理为支付成功 --大机补充需求start */
				StagingRequestResult stagingRequestResult = null;
				BigDecimal comResult = orderSubModel.getTotalMoney() == null ? new BigDecimal("0") : orderSubModel.getTotalMoney();
				if (BigDecimal.ZERO.compareTo(comResult) == 0) {// 如果现金部分为0，并且是走新流程
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
					stagingRequest.setCreator(orderMainModel.getCreateOper());

					stagingRequest.setBookDesc(orderMainModel.getCsgPhone1());
					stagingRequest.setReceiveMode("02");
					stagingRequest.setAddr(Strings.nullToEmpty(orderMainModel.getCsgProvince() + orderMainModel.getCsgCity()
							+ orderMainModel.getCsgBorough() + orderMainModel.getCsgAddress()));// 省+市+区+详细地址
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
					Response<TblVendorRatioModel> vendorRatioResponse = vendorService.findRatioByVendorId(
							orderSubModel.getVendorId(), orderSubModel.getStagesNum());
					TblVendorRatioModel vendorRatio = vendorRatioResponse.getResult();
					Response<VendorInfoModel> vendorResponse = vendorService.findVendorById(orderSubModel
							.getVendorId());
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
					if (orderSubModel.getVoucherNo() != null && !"".equals(orderSubModel.getVoucherNo())) {
						favorableType = "01";
						deductAmt = orderSubModel.getVoucherPrice();
					}
					if (orderSubModel.getBonusTotalvalue() != null
							&& orderSubModel.getBonusTotalvalue().longValue() != 0) {
						favorableType = "02";
						deductAmt = orderSubModel.getUitdrtamt();
					}
					if ((orderSubModel.getVoucherNo() != null && !"".equals(orderSubModel.getVoucherNo()))
							&& (orderSubModel.getBonusTotalvalue() != null && orderSubModel.getBonusTotalvalue()
									.longValue() != 0)) {
						favorableType = "03";
						deductAmt = orderSubModel.getVoucherPrice().add(orderSubModel.getUitdrtamt());
					}
					if ((orderSubModel.getVoucherNo() == null || "".equals(orderSubModel.getVoucherNo()))
							&& (orderSubModel.getBonusTotalvalue() == null || orderSubModel.getBonusTotalvalue()
									.longValue() == 0)) {
						favorableType = "00";
					}
					stagingRequest.setFavorableType(favorableType);// 优惠类型
					stagingRequest.setDeductAmt(deductAmt);// 抵扣金额
					// 调用接口BP0005 OPS受理
					stagingRequestResult = stagingRequestService.getStagingRequest(stagingRequest);
				}
				orderResultMap.put("returnGateWayEnvolopeVo", stagingRequestResult);
				orderResultMap.put("tblOrder", orderSubModel);
				orderResultMaps.add(orderResultMap);
			}
			relaySmsReturn.setReturnCode("0000");
			relaySmsReturn.setReturnDes("正常");
		} catch (Exception e) {// 如果连bps报异常，订单状态不做修改，等待状态回查
			log.error("调用ops分期申请接口失败:", e);
			relaySmsReturn.setReturnCode("0027");
			relaySmsReturn.setReturnDes("数据库操作异常");
		}
		// 根据BPS返回信息处理分期订单
		try {
			orderChannelService.dealFQorderBpswithTX(orderMainModel, orderResultMaps, tblOrderExtend1Models);
		} catch (Exception e) {
			log.error("根据BPS返回信息处理分期订单出错: ", e);
			relaySmsReturn.setReturnCode("0027");
			relaySmsReturn.setReturnDes("数据库操作异常");
			return relaySmsReturn;
		}
		return relaySmsReturn;
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
				htcapital = vendorRatio.getHtant() == null ? "" : String.valueOf(vendorRatio.getHtant().setScale(2,
						BigDecimal.ROUND_DOWN));
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
