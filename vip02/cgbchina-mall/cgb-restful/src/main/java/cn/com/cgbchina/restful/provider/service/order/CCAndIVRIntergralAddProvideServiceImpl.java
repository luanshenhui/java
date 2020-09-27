package cn.com.cgbchina.restful.provider.service.order;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.item.dto.ItemGoodsDetailDto;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.CfgIntegraltypeService;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.related.service.BusinessService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.util.MallReturnCode;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.CCAndIVRIntergalOrderReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.CCAndIVRIntergalOrderVO;
import cn.com.cgbchina.rest.visit.model.user.QueryUserInfo;
import cn.com.cgbchina.rest.visit.model.user.UserInfo;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.rest.visit.service.point.PointService;
import cn.com.cgbchina.rest.visit.service.sms.SMSService;
import cn.com.cgbchina.rest.visit.service.user.UserService;
import cn.com.cgbchina.trade.dto.OrderCommitInfoDto;
import cn.com.cgbchina.trade.dto.OrderCommitSubmitDto;
import cn.com.cgbchina.trade.service.OrderJFMainService;
import cn.com.cgbchina.trade.service.OrderSendForO2OService;
import cn.com.cgbchina.trade.service.OrderService;
import cn.com.cgbchina.trade.service.PriceSystemService;
import cn.com.cgbchina.trade.service.PriorJudgeService;
import cn.com.cgbchina.trade.vo.CustLevelInfo;
import cn.com.cgbchina.user.model.CardPro;
import cn.com.cgbchina.user.service.CardProService;
import cn.com.cgbchina.user.service.EspCustNewService;
import cn.com.cgbchina.user.service.LocalCardRelateService;
import cn.com.cgbchina.user.service.VendorService;

@Slf4j
public class CCAndIVRIntergralAddProvideServiceImpl
		implements
		SoapProvideService<CCAndIVRIntergalOrderVO, CCAndIVRIntergalOrderReturnVO> {
	@Resource
	PriceSystemService priceSystemService;

	@Resource
	GoodsPayWayService goodsPayWayService;

	@Resource
	VendorService vendorService;

	@Resource
	ItemService itemService;

	@Resource
	BusinessService businessService;

	@Resource
	LocalCardRelateService localCardRelateService;

	@Resource
	CfgIntegraltypeService cfgIntegraltypeService;

	@Resource
	PriorJudgeService priorJudgeService;

	@Resource
	EspCustNewService espCustNewService;

	@Resource
	SMSService smsService;

	@Resource
	MallPromotionService mallPromotionService;

	@Resource
	OrderService orderService;

	@Resource
	PointService pointService;

	@Resource
	CardProService cardProService;

	@Resource
	PaymentService paymentService;

	@Resource
	UserService userService;

	@Resource
	OrderSendForO2OService orderSendForO2OService;

	@Resource
	private IdGenarator idGenarator;

	@Value("#{app.merchId}")
	private String orderMerchentId;

	@Value("#{app.birthdayLimit}")
	private String birthdayLimit;

	// 粤通卡
	@Value("${yuTongKaGoods}")
	private String yuTongKaGoods;

	@Resource
	private OrderJFMainService orderJFMainService;
	@Override
	public CCAndIVRIntergalOrderReturnVO process(
			SoapModel<CCAndIVRIntergalOrderVO> model,
			CCAndIVRIntergalOrderVO content) {
		log.debug("[MAL104流水] CCAndIVRIntergralAddOrderProvideServiceImpl.process start.......");
		CCAndIVRIntergalOrderReturnVO result = new CCAndIVRIntergalOrderReturnVO();
		String senderSN = model.getSenderSN();
		log.debug("【MAL104】流水：收到下单请求报文，流水号: senderSN={}", senderSN);
		// 客户姓名
		String custName = content.getCustName();
		log.debug("【MAL104】流水：" + senderSN + "，客户姓名(custName):"
				+ StringUtil.maskString(custName));

		// 收货人姓名
		String deliveryName = content.getDeliveryName();
		log.debug("【MAL104】流水：" + senderSN + "，收货人姓名(deliveryName):"
				+ StringUtil.maskString(deliveryName));

		// 收货人手机
		String deliveryMobile = content.getDeliveryMobile();
		log.debug("【MAL104】流水：" + senderSN + "，收货人手机(deliveryMobile):"
				+ StringUtil.maskString(deliveryMobile, "R", 1, 4));

		// 收货人固话
		String deliveryPhone = content.getDeliveryPhone();
		log.debug("【MAL104】流水：" + senderSN + "，收货人固话(deliveryPhone):"
				+ StringUtil.maskString(deliveryPhone, "R", 1, 4));

		// 送货地址
		String deliveryAddr = content.getDeliveryAddr();
		log.debug("【MAL104】流水：" + senderSN + "，送货地址(deliveryAddr):"
				+ StringUtil.maskString(deliveryAddr));

		// 受理号
		String acceptedNo = content.getAcceptedNo();
		log.debug("【MAL104】流水：" + senderSN + "，受理号(acceptedNo):" + acceptedNo);

		// 下单方式
		String orderType = content.getOrderType();
		log.debug("【MAL104】流水：" + senderSN + "，下单方式(orderType):" + orderType);

		// 卡号
		String cardNo = content.getCardNo();
		log.debug("【MAL104】流水：" + senderSN + "，卡号(cardNo):" + cardNo);

		// 积分类型
		String intergralType = content.getIntergralType();
		log.debug("【MAL104】流水：" + senderSN + "，积分类型(intergralType):"
				+ intergralType);
		// 积分值
		String intergralNo = content.getIntergralNo();
		log.debug("【MAL104】流水：" + senderSN + "，积分值(intergralNo):" + intergralNo);
		// 现金
		String goodsPrice = content.getGoodsPrice();
		log.debug("【MAL104】流水：" + senderSN + "，现金(goodsPrice):" + goodsPrice);

		// 信用卡有效期
		String validDate = content.getValidDate();
		log.debug("【MAL104】流水：" + senderSN + "，信用卡有效期(validDate):" + validDate);

		// 商品编码
		String goodsId = content.getGoodsId();
		log.debug("【MAL104】流水：" + senderSN + "，商品编码(goodsId):" + goodsId);
		// 支付编码
		String paywayId = content.getPaywayId();
		log.debug("【MAL104】流水：" + senderSN + "，支付编码(paywayId):" + paywayId);
		// 兑换数量
		String goodsN = content.getGoodsNo();
		log.debug("【MAL104】流水：" + senderSN + "，兑换数量(goodsNo):" + goodsN);
		// 证件号码
		String contIdCard = content.getContIdCard();
		log.debug("【MAL104】流水：" + senderSN + "，证件号码(contIdCard):"
				+ StringUtil.maskString(contIdCard));

		// 会员号
		String virtual_member_id = content.getVirtualMemberId();
		log.debug("【MAL104】流水：" + senderSN + "，会员号(virtual_member_id):"
				+ virtual_member_id);

		// 会员姓名
		String virtual_member_nm = content.getVirtualMemberNm();
		log.debug("【MAL104】流水：" + senderSN + "，会员姓名(virtual_member_nm):"
				+ virtual_member_nm);

		// 航空类型
		String virtual_aviation_type = content.getvAviationType();
		log.debug("【MAL104】流水：" + senderSN + "，航空类型(v_aviation_type):"
				+ virtual_aviation_type);

		// 交易描述
		String tradeDesc = content.getTradeDesc();
		log.debug("【MAL104】流水：" + senderSN + "，交易描述(tradeDesc):" + tradeDesc);

		// 强制兑换
		String force_buy = content.getForceBuy();
		log.debug("【MAL104】流水：" + senderSN + "，强制兑换(force_buy):" + force_buy);

		// 卡板代码
		String format_id = content.getFormatId();
		log.debug("【MAL104】流水：" + senderSN + "，卡板代码(format_id):" + format_id);

		String entry_card = content.getEntryCard();
		log.debug("【MAL104】流水：" + senderSN + "，兑换卡号(entry_card):" + entry_card);
		// 备注1-保单号
		String desc1 = content.getDesc1();
		log.debug("【MAL104】流水：" + senderSN + "，备注1<保单号>(desc1):" + desc1);
		// 备注2 附属卡证件号
		String desc2 = content.getDesc2();
		log.debug("【MAL104】流水：" + senderSN + "，备注2(desc2):" + desc2);
		// 备注3 附属卡姓名
		String desc3 = content.getDesc3();
		log.debug("【MAL104】流水：" + senderSN + "，备注3(desc3):" + desc3);
		// 邮编
		String deliveryPost = content.getDeliveryPost();
		log.debug("【MAL104】流水：" + senderSN + "，邮编(deliveryPost):"
				+ deliveryPost);
		String ordermainDesc = content.getOrdermainDesc();
		log.debug("【MAL104】流水：" + senderSN + "，客户留言(ordermain_desc):"
				+ ordermainDesc);

		// 大机改造start
		String tradeChannel = content.getTradeChannel();
		log.debug("【MAL104】流水：" + senderSN + "，交易渠道(tradeChannel):"
				+ tradeChannel);

		String tradeSource = content.getTradeSource();
		log.debug("【MAL104】流水：" + senderSN + "，交易来源(tradeSource):"
				+ tradeSource);

		String bizSight = content.getBizSight();
		log.debug("【MAL104】流水：" + senderSN + "，业务场景(bizSight):" + bizSight);

		String sorceSenderNo = content.getSorceSenderNo();
		log.debug("【MAL104】流水：" + senderSN + "，源发起方流水(sorceSenderNo):"
				+ sorceSenderNo);

		String operatorId = content.getOperatorId();
		log.debug("【MAL104】流水：" + senderSN + "，操作员代码(operatorId):" + operatorId);

		// **************************************南航白金卡vip优先发货客户等级********************************
		String custType;
		CustLevelInfo custInfo = priceSystemService
				.getCustLevelInfo(contIdCard);// 根据证件号码到南航白金卡数据来源查询客户信息
		// FIXME:mark by ldk 这个不要了，因为新商城不从积分系统取了
		custType = custInfo.getCustType();
		log.debug("Nod返回的客户优先发货级别为：" + custType);
		// **************************************南航白金卡vip优先发货客户等级********************************
		// 商品编码
		String[] goodsIdArrayOri = goodsId.split("\\|");
		// 支付编码
		String[] paywayIdArrayOri = paywayId.split("\\|");
		// 兑换数量
		String[] goodsNoArrayOri = goodsN.split("\\|");
		
		
		/**
		 * ====================获取用户 start==================
		 */
		String createOper = null;
		// 调用个人网银接口查出客户号
		if (contIdCard != null && !"".equals(contIdCard.trim())) {
			boolean flg = true;
			try {
				// 调用个人网银接口
				QueryUserInfo userInfo = new QueryUserInfo();
				userInfo.setCertNo(contIdCard.trim());
				UserInfo cousrtomInfo = userService.getCousrtomInfo(userInfo);
				if (cousrtomInfo != null
						&& "0000".equals(cousrtomInfo.getRetCode())) {// 如果个人网银返回正确
					createOper = cousrtomInfo.getCustomerId();
					flg=false;
				} else {
					log.info("【MAL104】流水：" + senderSN + "调用个人网银接口eBOT04,未找到用户");
				}
			} catch (Exception e) {// 如果连接异常
				log.debug("【MAL104】流水：" + senderSN + "调用个人网银接口eBOT04失败");
				log.error("【MAL104】流水 调用个人网银接口eBOT04失败 exception{}",
						Throwables.getStackTraceAsString(e));
			} finally {
				if (flg) {
					return errReturn("000050");
				}
			}
		}
		/**
		 * ====================获取用户 end==================
		 */

		/**
		 * ====================校验下单信息 start==============
		 */
			
		/**
		 * ====================校验下单信息 end=================
		 */
		return null;
	}
	
	private CCAndIVRIntergalOrderReturnVO errReturn(String errCode) {
		CCAndIVRIntergalOrderReturnVO result = new CCAndIVRIntergalOrderReturnVO();
		result.setChannelSN("CCAG");
		result.setSuccessCode("00");
		result.setReturnCode(errCode);
		result.setReturnDes(MallReturnCode.getReturnDes(errCode));
		return result;
	}
	
	private Response<OrderCommitSubmitDto> structureSubmitDto(CCAndIVRIntergalOrderVO request,UserInfo userInfo){
		//---------创建返回对象
		Response<OrderCommitSubmitDto> result=new Response<>();
		OrderCommitSubmitDto submitDto=new OrderCommitSubmitDto();
		
		//---------获取商品信息
		//TODO:没有check商品能查出来的数量和输入的数量是否一样
		List<ItemGoodsDetailDto>  items=null;
		String[] goodsIdArray = request.getGoodsId().split("\\|");
		Response<List<ItemGoodsDetailDto>> itemsResponse = itemService.findByIds(Arrays.asList(goodsIdArray));
		if(!itemsResponse.isSuccess()&&(items=itemsResponse.getResult()).size()>0){
			result.setError("000011");
			return result;
		}
		
		//----------获取支付方式信息
		String[] paywayIdArray = request.getGoodsId().split("\\|");
		Response<List<TblGoodsPaywayModel>> payWayResponse = goodsPayWayService
				.findByGoodsPayWayIdList(Arrays.asList(paywayIdArray));
		if(!payWayResponse.isSuccess()){
			result.setError("000008");
			return result;
		}
		List<TblGoodsPaywayModel> pays=payWayResponse.getResult();
		
		//----------包装主订单信息
		submitDto.setBusiType(Contants.BUSINESS_TYPE_JF);
		//因为要不是都是
		//TODO：调查一下的，是不是要不都是实物、要不都是o2o的
		submitDto.setGoodsType(items.get(0).getGoodsType());
		submitDto.setAddressId(null);
		submitDto.setBpCustGrp(null);
		submitDto.setCardNo(request.getCardNo());
		if(Contants.GOODS_TYPE_ID_01.equals(submitDto.getGoodsType())){
			Map<String, Object> cardQueryMap = Maps.newHashMap();
			cardQueryMap.put("formatId", request.getFormatId());
			Response<List<CardPro>> cardResponse = cardProService.findByParams(cardQueryMap);
			if (!cardResponse.isSuccess()) {
				result.setError("000011");
				return result;
			}
			CardPro cardPro = null;
			if (cardResponse.getResult() != null && cardResponse.getResult().size() > 0) {
				cardPro = cardResponse.getResult().get(0);
			}
			String cardType = cardPro != null ? cardPro.getCardproNm() : "";
			submitDto.setCardType(cardType);
		}
		submitDto.setCardFormat(request.getFormatId());
		submitDto.setPayType(Contants.CART_PAY_TYPE_1);
		submitDto.setUserName(request.getDeliveryName());
		submitDto.setPhoneNo(request.getDeliveryMobile());
		submitDto.setMiaoFlag("0");
		String channel="";
		if(request.getIvrFlag()=="0"){
			channel=Contants.ORDER_SOURCE_ID_CC;
		}else{
			channel=Contants.ORDER_SOURCE_ID_IVR;
		}
		submitDto.setOrderId(idGenarator.orderMainId(channel));
		submitDto.setVirtualMemberId(request.getVirtualMemberId());
		submitDto.setVirtualMemberNm(request.getVirtualMemberNm());
		submitDto.setVirtualAviationType(request.getvAviationType());
		submitDto.setEntryCard(request.getEntryCard());
		submitDto.setAttachIdentityCard(request.getDesc2());
		submitDto.setAttachName(request.getDesc3());
		//TODO:这个不知道对不对，感觉不对
		if("1".equals(request.getOrderType())){
			submitDto.setMergeFlag("1");
		}else{
			submitDto.setMergeFlag("0");
		}
		submitDto.setSerialno(idGenarator.orderSerialNo());
		submitDto.setPrepaidMob(request.getDeliveryMobile());
		
		//-----------包装子订单信息
		ArrayList<OrderCommitInfoDto> subOrderList = new ArrayList<OrderCommitInfoDto>();
		submitDto.setOrderCommitInfoList(subOrderList);
		String[] goodsNoArray = request.getGoodsNo().split("\\|");
		String[] goodsPriceArray=request.getGoodsPrice().split("\\|");
		for(int i=0;i<items.size();i++){
			ItemGoodsDetailDto item=items.get(i);
			TblGoodsPaywayModel pay=pays.get(i);
			OrderCommitInfoDto subOrder=new OrderCommitInfoDto();
			subOrder.setCode(item.getCode());
			subOrder.setMid(item.getMid());
			subOrder.setPayWayId(String.valueOf(pay.getGoodsPaywayId()));
			subOrder.setOriPrice(pay.getGoodsPrice());
			subOrder.setPrice(pay.getGoodsPrice());
			subOrder.setItemCount(Integer.valueOf(goodsNoArray[i]));
			subOrder.setInstalments("1");
			//TODO:没写完 吐了。。。放在这不弄了。。。。
		}
		return null;
	}
}
