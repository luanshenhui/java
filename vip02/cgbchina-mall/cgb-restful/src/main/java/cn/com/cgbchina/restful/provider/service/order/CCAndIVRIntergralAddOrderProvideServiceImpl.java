package cn.com.cgbchina.restful.provider.service.order;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.PayReturnCode;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.item.dto.ItemGoodsDetailDto;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.model.TblCfgIntegraltypeModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.CfgIntegraltypeService;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.related.model.TblParametersModel;
import cn.com.cgbchina.related.service.BusinessService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.util.MallReturnCode;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.CCAndIVRIntergalOrderReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.CCAndIVRIntergalOrderVO;
import cn.com.cgbchina.rest.visit.model.payment.CCPointResult;
import cn.com.cgbchina.rest.visit.model.payment.CCPointsPay;
import cn.com.cgbchina.rest.visit.model.payment.CCPointsPayBaseInfo;
import cn.com.cgbchina.rest.visit.model.payment.OrderBaseInfo;
import cn.com.cgbchina.rest.visit.model.payment.PaymentRequeryInfo;
import cn.com.cgbchina.rest.visit.model.payment.PaymentRequeryResult;
import cn.com.cgbchina.rest.visit.model.sms.SendSMSInfo;
import cn.com.cgbchina.rest.visit.model.sms.SendSMSNotifyResult;
import cn.com.cgbchina.rest.visit.model.user.QueryUserInfo;
import cn.com.cgbchina.rest.visit.model.user.UserInfo;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.rest.visit.service.point.PointService;
import cn.com.cgbchina.rest.visit.service.sms.SMSService;
import cn.com.cgbchina.rest.visit.service.user.UserService;
import cn.com.cgbchina.trade.dto.OrderCCAndIVRAddDto;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.OrderVirtualModel;
import cn.com.cgbchina.trade.service.OrderSendForO2OService;
import cn.com.cgbchina.trade.service.OrderService;
import cn.com.cgbchina.trade.service.PriceSystemService;
import cn.com.cgbchina.trade.service.PriorJudgeService;
import cn.com.cgbchina.trade.vo.CustLevelInfo;
import cn.com.cgbchina.user.model.CardPro;
import cn.com.cgbchina.user.model.LocalCardRelateModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.CardProService;
import cn.com.cgbchina.user.service.EspCustNewService;
import cn.com.cgbchina.user.service.LocalCardRelateService;
import cn.com.cgbchina.user.service.VendorService;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL104 CC/IVR积分商城下单 从soap对象生成的vo转为 接口调用的bean
 *
 * @author Lizy
 *
 */
@Service
@TradeCode(value = "MAL104")
@Slf4j
public class CCAndIVRIntergralAddOrderProvideServiceImpl
		implements SoapProvideService<CCAndIVRIntergalOrderVO, CCAndIVRIntergalOrderReturnVO> {

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

	@Override
	public CCAndIVRIntergalOrderReturnVO process(SoapModel<CCAndIVRIntergalOrderVO> model,
			CCAndIVRIntergalOrderVO content) {
		log.debug("[MAL104流水] CCAndIVRIntergralAddOrderProvideServiceImpl.process start.......");
		CCAndIVRIntergalOrderReturnVO result = new CCAndIVRIntergalOrderReturnVO();

		String custName;
		String deliveryName;
		String deliveryMobile;
		String deliveryPhone;
		String deliveryAddr;
		String acceptedNo = content.getAcceptedNo();
		String orderType;
		String ivrFlag;
		String cardNo;
		String intergralType;
		String intergralNo;
		String goodsPrice;
		String validDate;
		String goodsId;
		String paywayId;
		String goodsN;
		String contIdCard;
		String virtual_member_id;
		String virtual_member_nm;
		String virtual_aviation_type;
		String tradeCode = "";
		String tradeDesc;
		String force_buy;
		String format_id;
		String entry_card;
		String desc1;
		String desc2;
		String desc3;
		String ordermainDesc;
		String[] goodsIdArrayOri;
		String[] paywayIdArrayOri;
		String[] goodsNoArrayOri;
		OrderMainModel orderMain;
		String tradeSeqNo;
		String merId;
		// CC端：1表示指定下单,2：表示由积分系统自动扣减
		// 企业网银端:'0'表示合并，'1'表示不合并
		String isMerger;
		String[] cardNoArray;
		String[] goodsPriceArray;
		String[] intergralTypeArray;
		String[] intergralNoArray;
		String[] validDateArray;
		long smsTotalBonus = 0;
		double smsTotalPrice = 0;
		String successCode = "01";// 成功失败标志
		String returnCode = "000000";// 响应码
		String ReturnDes = "正常";// 响应码
		String errCode = "";// 错误原因码
		String deliveryPost;// 邮编
		String[] goodsIdArray;// 单品编码列表
		String[] goodsNoArray;

		Map<String, TblGoodsPaywayModel> paywayMap = new HashMap<>();

		Map<String, ItemGoodsDetailDto> itemMap = new HashMap<>();
		Map<String, TblCfgIntegraltypeModel> integraltypeMap = new HashMap<>();

		Map<String, String> bigMachineMap = Maps.newHashMap();
		// 按原流水号返回
		String senderSN = model.getSenderSN();
		log.debug("【MAL104】流水：收到下单请求报文，流水号: senderSN={}", senderSN);

		String orderMainId;
		String createOper = "System";
		List<String> birthList = null;
		try {
			// IVR标识
			ivrFlag = content.getIvrFlag();
			log.debug("【MAL104】流水：" + senderSN + "，IVR标识(ivrFlag):" + ivrFlag);
			String judgment = judgmentQT(ivrFlag);// 验证启停控制
			log.debug("【MAL104】流水：" + senderSN + "，验证启停控制后字段:" + judgment);
			if (!("CC".equals(judgment) || "IVR".equals(judgment))) {// 如果不通过启动支付验证
				// 返回失败报文
				result.setReturnCode(judgment);
				result.setReturnDes(MallReturnCode.getReturnDes(judgment));
				result.setChannelSN("CCAG");
				result.setOrderMainId("");
				result.setSuccessCode("00");
				return result;
			}

			// 客户姓名
			custName = content.getCustName();
			log.debug("【MAL104】流水：" + senderSN + "，客户姓名(custName):" + StringUtil.maskString(custName));

			// 收货人姓名
			deliveryName = content.getDeliveryName();
			log.debug("【MAL104】流水：" + senderSN + "，收货人姓名(deliveryName):" + StringUtil.maskString(deliveryName));

			// 收货人手机
			deliveryMobile = content.getDeliveryMobile();
			log.debug("【MAL104】流水：" + senderSN + "，收货人手机(deliveryMobile):"
					+ StringUtil.maskString(deliveryMobile, "R", 1, 4));

			// 收货人固话
			deliveryPhone = content.getDeliveryPhone();
			log.debug("【MAL104】流水：" + senderSN + "，收货人固话(deliveryPhone):"
					+ StringUtil.maskString(deliveryPhone, "R", 1, 4));

			// 送货地址
			deliveryAddr = content.getDeliveryAddr();
			log.debug("【MAL104】流水：" + senderSN + "，送货地址(deliveryAddr):" + StringUtil.maskString(deliveryAddr));

			// 受理号
			acceptedNo = content.getAcceptedNo();
			log.debug("【MAL104】流水：" + senderSN + "，受理号(acceptedNo):" + acceptedNo);

			// 下单方式
			orderType = content.getOrderType();
			log.debug("【MAL104】流水：" + senderSN + "，下单方式(orderType):" + orderType);

			// 卡号
			cardNo = content.getCardNo();
			log.debug("【MAL104】流水：" + senderSN + "，卡号(cardNo):" + cardNo);

			// 积分类型
			intergralType = content.getIntergralType();
			log.debug("【MAL104】流水：" + senderSN + "，积分类型(intergralType):" + intergralType);
			// 积分值
			intergralNo = content.getIntergralNo();
			log.debug("【MAL104】流水：" + senderSN + "，积分值(intergralNo):" + intergralNo);
			// 现金
			goodsPrice = content.getGoodsPrice();
			log.debug("【MAL104】流水：" + senderSN + "，现金(goodsPrice):" + goodsPrice);

			// 信用卡有效期
			validDate = content.getValidDate();
			log.debug("【MAL104】流水：" + senderSN + "，信用卡有效期(validDate):" + validDate);

			// 商品编码
			goodsId = content.getGoodsId();
			log.debug("【MAL104】流水：" + senderSN + "，商品编码(goodsId):" + goodsId);
			// 支付编码
			paywayId = content.getPaywayId();
			log.debug("【MAL104】流水：" + senderSN + "，支付编码(paywayId):" + paywayId);
			// 兑换数量
			goodsN = content.getGoodsNo();
			log.debug("【MAL104】流水：" + senderSN + "，兑换数量(goodsNo):" + goodsN);
			// 证件号码
			contIdCard = content.getContIdCard();
			log.debug("【MAL104】流水：" + senderSN + "，证件号码(contIdCard):" + StringUtil.maskString(contIdCard));

			// 会员号
			virtual_member_id = content.getVirtualMemberId();
			log.debug("【MAL104】流水：" + senderSN + "，会员号(virtual_member_id):" + virtual_member_id);

			// 会员姓名
			virtual_member_nm = content.getVirtualMemberNm();
			log.debug("【MAL104】流水：" + senderSN + "，会员姓名(virtual_member_nm):" + virtual_member_nm);

			// 航空类型
			virtual_aviation_type = content.getvAviationType();
			log.debug("【MAL104】流水：" + senderSN + "，航空类型(v_aviation_type):" + virtual_aviation_type);

			// 交易描述
			tradeDesc = content.getTradeDesc();
			log.debug("【MAL104】流水：" + senderSN + "，交易描述(tradeDesc):" + tradeDesc);

			// 强制兑换
			force_buy = content.getForceBuy();
			log.debug("【MAL104】流水：" + senderSN + "，强制兑换(force_buy):" + force_buy);

			// 卡板代码
			format_id = content.getFormatId();
			log.debug("【MAL104】流水：" + senderSN + "，卡板代码(format_id):" + format_id);

			entry_card = content.getEntryCard();
			log.debug("【MAL104】流水：" + senderSN + "，兑换卡号(entry_card):" + entry_card);
			// 备注1-保单号
			desc1 = content.getDesc1();
			log.debug("【MAL104】流水：" + senderSN + "，备注1<保单号>(desc1):" + desc1);
			// 备注2 附属卡证件号
			desc2 = content.getDesc2();
			log.debug("【MAL104】流水：" + senderSN + "，备注2(desc2):" + desc2);
			// 备注3 附属卡姓名
			desc3 = content.getDesc3();
			log.debug("【MAL104】流水：" + senderSN + "，备注3(desc3):" + desc3);
			// 邮编
			deliveryPost = content.getDeliveryPost();
			log.debug("【MAL104】流水：" + senderSN + "，邮编(deliveryPost):" + deliveryPost);
			ordermainDesc = content.getOrdermainDesc();
			log.debug("【MAL104】流水：" + senderSN + "，客户留言(ordermain_desc):" + ordermainDesc);

			// 大机改造start
			String tradeChannel = content.getTradeChannel();
			log.debug("【MAL104】流水：" + senderSN + "，交易渠道(tradeChannel):" + tradeChannel);

			String tradeSource = content.getTradeSource();
			log.debug("【MAL104】流水：" + senderSN + "，交易来源(tradeSource):" + tradeSource);

			String bizSight = content.getBizSight();
			log.debug("【MAL104】流水：" + senderSN + "，业务场景(bizSight):" + bizSight);

			String sorceSenderNo = content.getSorceSenderNo();
			log.debug("【MAL104】流水：" + senderSN + "，源发起方流水(sorceSenderNo):" + sorceSenderNo);

			String operatorId = content.getOperatorId();
			log.debug("【MAL104】流水：" + senderSN + "，操作员代码(operatorId):" + operatorId);
			bigMachineMap.put("tradeChannel", tradeChannel == null ? "" : tradeChannel);
			bigMachineMap.put("tradeSource", tradeSource == null ? "" : tradeSource);
			bigMachineMap.put("bizSight", bizSight == null ? "" : bizSight);
			bigMachineMap.put("sorceSenderNo", sorceSenderNo == null ? "" : sorceSenderNo);
			bigMachineMap.put("operatorId", operatorId == null ? "" : operatorId);

			// **************************************南航白金卡vip优先发货客户等级********************************
			String custType;
			CustLevelInfo custInfo = priceSystemService.getCustLevelInfo(contIdCard);// 根据证件号码到南航白金卡数据来源查询客户信息
			// FIXME:mark by ldk 这个不要了，因为新商城不从积分系统取了
			custType = custInfo.getCustType();
			log.debug("Nod返回的客户优先发货级别为：" + custType);
			// **************************************南航白金卡vip优先发货客户等级********************************

			/**
			 * ================================开始执行=====================================
			 */
			// 商品编码
			goodsIdArrayOri = goodsId.split("\\|");
			// 支付编码
			paywayIdArrayOri = paywayId.split("\\|");
			// 兑换数量
			goodsNoArrayOri = goodsN.split("\\|");

			// 判断商品信息循环数量不对
			if (goodsIdArrayOri.length != paywayIdArrayOri.length
					|| paywayIdArrayOri.length != goodsNoArrayOri.length) {
				result.setChannelSN("CCAG");
				result.setSuccessCode("01");
				result.setReturnCode("000008");
				result.setReturnDes("报文参数错误");
				return result;
			}

			List<Integer> notNullIndexList = Lists.newArrayList();
			for (int oriIndex = 0; oriIndex < goodsIdArrayOri.length; oriIndex++) {
				if (goodsIdArrayOri[oriIndex].trim().length() > 0) {
					notNullIndexList.add(oriIndex);
				}
			}
			goodsIdArray = new String[notNullIndexList.size()];
			String[] paywayIdArray = new String[notNullIndexList.size()];
			goodsNoArray = new String[notNullIndexList.size()];
			for (int i = 0; i < notNullIndexList.size(); i++) {
				int notNullIndex = notNullIndexList.get(i);
				goodsIdArray[i] = goodsIdArrayOri[notNullIndex].trim();
				paywayIdArray[i] = paywayIdArrayOri[notNullIndex].trim();
				goodsNoArray[i] = goodsNoArrayOri[notNullIndex].trim();
			}
			// 校验报文内容
			result = checkReceiveOrderParam(result, custName, deliveryName, deliveryMobile, deliveryPhone, deliveryAddr,
					acceptedNo, orderType, ivrFlag, cardNo, intergralType, intergralNo, goodsPrice, goodsIdArray,
					paywayIdArray, goodsNoArray, itemMap, paywayMap, integraltypeMap);// 校验下单参数
			if (result != null) {
				return result;
			}
			result = new CCAndIVRIntergalOrderReturnVO();
			cardNoArray = cardNo.split("\\|");
			goodsPriceArray = goodsPrice.split("\\|");
			intergralTypeArray = intergralType.split("\\|");
			intergralNoArray = intergralNo.split("\\|");
			validDateArray = validDate.split("\\|");
			Set goodsIdSet = itemMap.keySet();
			String[] vendorIdArray = new String[goodsIdSet.size()];
			Iterator goodsIdIterator = goodsIdSet.iterator();
			int vendorIdArrayIndex = 0;
			while (goodsIdIterator.hasNext()) {
				vendorIdArray[vendorIdArrayIndex++] = itemMap.get(goodsIdIterator.next().toString()).getVendorId();
			}

			Response<List<VendorInfoModel>> vendorResponse = vendorService
					.findByVendorIds(Arrays.asList(vendorIdArray));
			if (!vendorResponse.isSuccess() || vendorResponse.getResult() == null) {
				return errReturn("000011");
			}

			List<VendorInfoModel> vendorList = vendorResponse.getResult();
			Map<String, VendorInfoModel> vendorMap = convertVendorListToMap(vendorList);
			// 存在现金值的卡的位置
			int moneyCardIndex = 0;
			for (int index = 0; index < goodsPriceArray.length; index++) {
				if (Double.parseDouble(goodsPriceArray[index]) > 0) {
					moneyCardIndex = index;
				}
			}
			tradeSeqNo = idGenarator.orderSerialNo();// 获取支付流水号
			if ("1".equals(orderType)) {
				isMerger = "1";
			} else {
				isMerger = "0";
			}
			merId = orderMerchentId;

			// 调用个人网银接口查出客户号
			if (contIdCard != null && !"".equals(contIdCard.trim())) {
				try {
					// 调用个人网银接口
					QueryUserInfo userInfo = new QueryUserInfo();
					userInfo.setCertNo(contIdCard.trim());
					UserInfo cousrtomInfo = userService.getCousrtomInfo(userInfo);
					if (cousrtomInfo != null && "0000".equals(cousrtomInfo.getRetCode())) {// 如果个人网银返回正确
						createOper = cousrtomInfo.getCustomerId();
					}else{
						createOper=contIdCard.trim();
					}
				} catch (Exception e) {// 如果连接异常
					log.debug("【MAL104】流水：" + senderSN + "调用个人网银接口eBOT04失败");
					log.error("【MAL104】流水 调用个人网银接口eBOT04失败 exception{}", Throwables.getStackTraceAsString(e));
					result.setChannelSN("CCAG");
					result.setSuccessCode("01");
					result.setReturnCode("000050");
					result.setReturnDes(MallReturnCode.getReturnDes("000050"));
					return result;
				}
			}
			// 虚拟礼品只能买购买一种，包含CC以及商城渠道
			ItemGoodsDetailDto virtualGoodsInf = null;
			for (String goodsIdStr : goodsIdArray) {
				virtualGoodsInf = itemMap.get(goodsIdStr);
				if (virtualGoodsInf != null && "0001".equals(virtualGoodsInf.getGoodsType())
						&& goodsIdArray.length > 1) {// 包含虚拟礼品并且商品不止一种
					return errReturn("000057");// 返回错误报文
				}
			}

			// 配置文件中配置的生日使用次数
			int birthLimitCount = Integer.parseInt(birthdayLimit);

			if (virtualGoodsInf != null && Contants.GOODS_TYPE_ID_01.equals(virtualGoodsInf.getGoodsType())) {// ********虚拟礼品的订单*********
				log.debug("【MAL104】流水：" + senderSN + "为虚拟礼品的下单");

				String res = priorJudgeService.preJudge(contIdCard, cardNo, format_id, virtualGoodsInf.getCode(),
						force_buy);
				if ("1".equals(res)) {// 卡板不满足
					return errReturn("000062");
				} else if ("2".equals(res)) {// 购买次数已达
					return errReturn("000059");
				} else if ("-1".equals(res)) {// 找不到礼品
					return errReturn("000010");
				} else if ("5".equals(res)) {//在限定时间超过购买次数
					return errReturn("000059");
				} else if ("4".equals(res)) {// 购买次数已达
					return errReturn("000059");
				}  else if ("3".equals(res)) {//系统异常
					return errReturn("000009");
				} 
				log.debug("【MAL104】流水：" + senderSN + ",goodsNoArray[0]:" + goodsNoArray[0]);
				int goodsNum = Integer.parseInt(goodsNoArray[0].trim());
				// 取到goodsXid
				String goodsXid = virtualGoodsInf.getXid();
				int limit = virtualGoodsInf.getVirtualLimit() != null ? virtualGoodsInf.getVirtualLimit() : 0;
				log.debug("goodsXid:" + goodsXid + "limitGoods限购次数:" + limit);
				if (limit > 0 && goodsNum > 1) {// 限购商品一次只能购买一件
					return errReturn("000060");
				}

				if (cardNoArray.length > 1) {// 虚拟礼品不能采用指定多卡支付
					return errReturn("000061");
				}
				// 操作扩展表orderVirtual
				OrderVirtualModel orderVirtual = new OrderVirtualModel();
				// 粤通卡产品校验
				String yuTongKa = yuTongKaGoods;// 粤通卡类礼品
				if (yuTongKa.contains(goodsXid)) {
					orderVirtual.setSerialno(desc1 == null ? "" : desc1.trim());// 附属卡姓名
					log.debug("【MAL104】流水：" + senderSN + "保单号校验成功");
				}

				// 判断卡片等级 start --add by dengbing 20160104,xq2015121701-积分礼品兑换增加卡等级规则判断
				boolean checkcardLevelFlag = priceSystemService.checkCardLevel(virtualGoodsInf.getCode(), contIdCard,
						cardNoArray[0]);// 根据卡号判断 --mod 20160216
				if (!checkcardLevelFlag) {
					log.debug("【MAL104】流水：" + senderSN + " 客户卡片等级不满足礼品维护的卡片等级");
					return errReturn("000101");
				}
				// 判断卡片等级 end

				ItemGoodsDetailDto goodsInf = itemMap.get(goodsIdArray[0]);
				TblGoodsPaywayModel payway = paywayMap.get(paywayIdArray[0]);
				VendorInfoModel vendorInf = vendorMap.get(goodsInf.getVendorId());

				// 增加客户生日月兑换礼品的限制 start --add by dengbing 20160105,xq2015121701-积分礼品兑换增加卡等级规则判断
				if (Contants.MEMBER_LEVEL_BIRTH_CODE.equals(payway.getMemberLevel())
						&& !Strings.isNullOrEmpty(createOper) && !"System".equals(createOper)) {// 支付方式为生日价
					Response<Map<String, Object>> birthCountResponse = espCustNewService
							.getBirthUsedCount(contIdCard.trim(), createOper);
					if (!birthCountResponse.isSuccess()) {
						return errReturn("000011");
					}
					Map<String, Object> map = birthCountResponse.getResult();
					int usedCount = Integer.parseInt(String.valueOf(map.get("usedCount")));
					log.debug("【MAL104】流水：" + senderSN + " 客户生日价剩余兑换次数：" + (birthLimitCount - usedCount) + "，兑换数量："
							+ goodsNum);
					if (birthLimitCount - usedCount <= 0) {
						return errReturn("000102");
					}
					if (birthLimitCount - usedCount - goodsNum < 0) {
						return errReturn("000103");
					}
					birthList = (List<String>) map.get("custIds");
				}
				// 增加客户生日月兑换礼品的限制 end

				// 组装大订单
				orderMain = accTblOrderMain(tradeSeqNo, isMerger, merId, custName, deliveryName, deliveryMobile,
						deliveryPhone, deliveryAddr, acceptedNo, ivrFlag, cardNoArray[0], contIdCard, createOper, desc1,
						desc2, desc3, deliveryPost, ordermainDesc, goodsNoArray, intergralNoArray);
				// // 插入主订单表 tbl_order_main

				// 组装子订单
				int orderCount = 1;// 虚拟礼品暂时只有一个小订单

				OrderSubModel order = accTblOrder(merId, orderMain, orderCount, goodsInf, payway, vendorInf,
						cardNoArray[0], ivrFlag, createOper, goodsNum, integraltypeMap, custName);//
				order.setCustType(custType);
				// 插入子订单表 tbl_order
				smsTotalBonus = order.getBonusTotalvalue() != null ? order.getBonusTotalvalue() : 0;
				smsTotalPrice = order.getTotalMoney() != null ? order.getTotalMoney().doubleValue() : 0;

				OrderDoDetailModel orderDodetail = new OrderDoDetailModel();
				orderDodetail.setOrderId(order.getOrderId());
				orderDodetail.setDoTime(new Date());
				orderDodetail.setDoUserid("Call Center");
				orderDodetail.setUserType("1");
				orderDodetail.setStatusId(order.getCurStatusId());
				orderDodetail.setStatusNm(order.getCurStatusNm());
				orderDodetail.setDoDesc("新建订单");
				orderDodetail.setDelFlag(0);
				orderDodetail.setCreateOper("SYSTEM");
				orderDodetail.setModifyOper("SYSTEM");

				// 插入订单操作历史表

				orderVirtual.setOrderId(order.getOrderId());// 小订单号
				orderVirtual.setGoodsXid(goodsXid);// 礼品编码
				orderVirtual.setGoodsMid(virtualGoodsInf.getMid());
				orderVirtual.setGoodsOid(virtualGoodsInf.getOid());
				orderVirtual.setGoodsBid(virtualGoodsInf.getBid());// 礼品代号
				if (entry_card != null && !"".equals(entry_card)) {// 判断附属卡是否正常
					String retCode = priorJudgeService.judgeEntryCard(virtualGoodsInf.getCode(), entry_card);
					if ("-1".equals(retCode)) {// 此礼品不是附属卡礼品
						return errReturn("000066");
					} else if ("-2".equals(retCode)) {// 输入的附属卡不符合规则
						return errReturn("000067");
					}
					orderVirtual.setEntryCard(entry_card);// 兑换卡（附属卡）
				} else {
					orderVirtual.setEntryCard(cardNoArray[0]);// 为配合报表生成，若入账卡为空则存主卡号
				}
				/* 卡类需要关联另一张表查询 */
				Map<String, Object> cardQueryMap = Maps.newHashMap();
				cardQueryMap.put("formatId", format_id);
				Response<List<CardPro>> cardResponse = cardProService.findByParams(cardQueryMap);
				if (!cardResponse.isSuccess()) {
					return errReturn("000011");
				}

				CardPro cardPro = null;
				if (cardResponse.getResult() != null && cardResponse.getResult().size() > 0) {
					cardPro = cardResponse.getResult().get(0);
				}
				String cardType = cardPro != null ? cardPro.getCardproNm() : "";
				orderVirtual.setVirtualCardType(cardType);// 卡类
				orderVirtual.setGoodsType(virtualGoodsInf.getGoodsType());// 礼品类别（此处为虚拟礼品）
				orderVirtual.setVirtualLimit(virtualGoodsInf.getVirtualLimit());// 限购次数
				orderVirtual.setVirtualSingleMileage(virtualGoodsInf.getVirtualMileage());// 里程
				if (virtualGoodsInf.getVirtualMileage() != null) {
					orderVirtual.setVirtualAllMileage(goodsNum * virtualGoodsInf.getVirtualMileage());
				}
				orderVirtual.setVirtualSinglePrice(virtualGoodsInf.getVirtualPrice());// 兑换金额
				if (virtualGoodsInf.getVirtualPrice() != null) {
					orderVirtual
							.setVirtualAllPrice(new BigDecimal(goodsNum).multiply(virtualGoodsInf.getVirtualPrice()));
				}
				orderVirtual.setVirtualMemberId(virtual_member_id);// 会员id
				orderVirtual.setVirtualMemberNm(virtual_member_nm);// 会员姓名
				orderVirtual.setVirtualAviationType(virtual_aviation_type);// 航空类型
				orderVirtual.setTradedesc(tradeDesc);
				// 留学生意外险

				// 判断是否为留学生意外险
				if (priorJudgeService.isLxsyx(goodsXid)) {
					// 留学生意外险
					orderVirtual.setAttachName(desc3 == null ? "" : desc3.trim());// 附属卡姓名
					orderVirtual.setAttachIdentityCard(desc2 == null ? "" : desc2.trim());// 附属卡证件号
				}
				/* tradeCode是用来给支付平台出对账文件 */
				// 判断是否签帐额产品（虚拟礼品）
				if (priorJudgeService.isQianzhane(goodsXid)) {// 红利卡兑换免签帐额调整交易码
					tradeCode = "8200";

					// 判断是否移动充值卡
				} else if (priorJudgeService.isNianFee(goodsXid)) {// 积分换年费交易码
					tradeCode = "3400";
				}

				orderVirtual.setTradecode(tradeCode);
				// 插入虚拟礼品表

				// 构造下单参数
				OrderCCAndIVRAddDto orderVirtualAddDto = new OrderCCAndIVRAddDto();
				orderVirtualAddDto.setOrderMainModel(orderMain);
				orderVirtualAddDto.setOrderSubModel(order);
				orderVirtualAddDto.setOrderDoDetailModel(orderDodetail);
				orderVirtualAddDto.setOrderVirtualModel(orderVirtual);
				orderVirtualAddDto.setCardNoArray(cardNoArray);
				orderVirtualAddDto.setGoodsPriceArray(goodsPriceArray);
				orderVirtualAddDto.setIntergralTypeArray(intergralTypeArray);
				orderVirtualAddDto.setIntergralNoArray(intergralNoArray);
				orderVirtualAddDto.setOrderType(orderType);
				orderVirtualAddDto.setPayway(payway);
				orderVirtualAddDto.setBirthList(birthList);
				orderVirtualAddDto.setGoodsNum(goodsNum);
				orderVirtualAddDto.setItemMap(itemMap);
				orderVirtualAddDto.setGoodsIdArray(goodsIdArray);
				orderVirtualAddDto.setGoodsNoArray(goodsNoArray);

				// 创建订单
				Response<Boolean> virtualOrderResponse = orderService.createCCAndIVRVirtualOrder(orderVirtualAddDto);
				if (!virtualOrderResponse.isSuccess()) {
					return errReturn(virtualOrderResponse.getError());
				}
			} else {
				log.debug("【MAL104】流水：" + senderSN + "为非虚拟礼品的下单");
				// 组装大订单
				orderMain = accTblOrderMain(tradeSeqNo, isMerger, merId, custName, deliveryName, deliveryMobile,
						deliveryPhone, deliveryAddr, acceptedNo, ivrFlag, cardNoArray[moneyCardIndex], contIdCard,
						createOper, desc1, desc2, desc3, deliveryPost, ordermainDesc, goodsNoArray, intergralNoArray);

				// 构造下单参数
				OrderCCAndIVRAddDto orderRealAddDto = new OrderCCAndIVRAddDto();
				orderRealAddDto.setOrderMainModel(orderMain);
				orderRealAddDto.setCardNoArray(cardNoArray);
				orderRealAddDto.setGoodsPriceArray(goodsPriceArray);
				orderRealAddDto.setIntergralTypeArray(intergralTypeArray);
				orderRealAddDto.setIntergralNoArray(intergralNoArray);
				orderRealAddDto.setOrderType(orderType);
				orderRealAddDto.setGoodsIdArray(goodsIdArray);
				orderRealAddDto.setItemMap(itemMap);
				orderRealAddDto.setPaywayMap(paywayMap);
				orderRealAddDto.setVendorMap(vendorMap);
				orderRealAddDto.setPaywayIdArray(paywayIdArray);
				orderRealAddDto.setGoodsNoArray(goodsNoArray);
				orderRealAddDto.setContIdCard(contIdCard);
				orderRealAddDto.setCreateOper(createOper);
				orderRealAddDto.setMerId(merId);
				orderRealAddDto.setMoneyCardIndex(moneyCardIndex);
				orderRealAddDto.setIvrFlag(ivrFlag);
				orderRealAddDto.setCustType(custType);
				orderRealAddDto.setIntegraltypeMap(integraltypeMap);

				// 创建订单
				Response<Map<String, Object>> realOrderResponse = orderService.createCCAndIVRRealOrder(orderRealAddDto);
				if (!realOrderResponse.isSuccess()) {
					return errReturn(realOrderResponse.getError());
				}

				Map<String, Object> resultMap = realOrderResponse.getResult();
				smsTotalBonus = (long) resultMap.get("smsTotalBonus");
				smsTotalPrice = (double) resultMap.get("smsTotalPrice");
				birthList=(List<String>)resultMap.get("birthList");
			}

			orderMainId = orderMain.getOrdermainId();

			log.debug("【MAL104】流水：" + senderSN + "，CC_IVR下单事务已经提交，订单号为：" + orderMainId);

		} catch (ResponseException re) {
			// 业务异常
			if (StringUtils.isNotEmpty(re.getMessage())) {
				return errReturn(re.getMessage());
			} else {
				return errReturn("000011");
			}
		} catch (Exception e) {
			log.debug("【MAL104】流水：" + senderSN + "，下单有误");
			log.error("【MAL104】流水：" + senderSN + "，Exception:{}", Throwables.getStackTraceAsString(e));
			// 返回失败报文
			result.setChannelSN("CCAG");
			result.setSuccessCode("00");
			result.setReturnCode("000011");
			result.setReturnDes(MallReturnCode.getReturnDes("000011"));
			result.setOrderMainId("");
			return result;
		}
		/* 事务 s1 结束 -------------------------------------------------------------------------------------------- */

		// 支付成功标志
		String retCode = null;
		CCPointResult payResult = null;
		try {
			// 组装支付信息
			CCPointsPay ccPointsPay = assNetBankPaymentDocument(tradeSeqNo, orderMain.getOrdermainId(), merId, isMerger,
					cardNoArray, goodsPriceArray, intergralTypeArray, intergralNoArray, validDateArray,
					orderMain.getCreateTime(), bigMachineMap);

			// 开始发报文到企业网银
			log.info("【MAL104】流水：" + senderSN + "，发送支付请求到企业网银");
			log.info("【MAL104】流水：" + senderSN + "，发送支付报文到企业网银:" + ccPointsPay);
			payResult = paymentService.ccPointsPay(ccPointsPay);// 发送报文
			log.info("【MAL104】流水：" + senderSN + "，企业网银返回报文：" + payResult);
			retCode = payResult.getRetCode();

			log.info("【MAL104】流水：" + senderSN + "，企业网银返回支付结果：" + retCode);

		} catch (Exception e) {
			// 如果调用企业网银接口抛异常，因为返回给CC只需要商城下单（插数据库）成功，所以捕捉异常
			log.debug("【MAL104】流水：" + senderSN + "，add order sucessed,after throws exception");
			log.error("【MAL104】流水：" + senderSN + "，Exception:{}", Throwables.getStackTraceAsString(e));
		}

		/* 事务 s2 开始 -------------------------------------------------------------------------------------------- */

		try {

			Response<OrderMainModel> orderMainResponse = orderService.findOrderMainById(orderMainId);
			if (!orderMainResponse.isSuccess() || orderMainResponse.getResult() == null) {
				return errReturn("000011");
			}
			OrderMainModel uOrderMain = orderMainResponse.getResult();

			String payState;// 订单最终状态 1:支付成功 2:支付失败 3:状态未明
			if ("000000".equals(retCode)) {// 支付成功
				payState = "1";
			} else if (retCode == null || "".equals(retCode) || PayReturnCode.isStateNoSure(retCode)) {
				// 如果支付时状态未明2015_0402_免签账额修复：状态未明
				// 电子支付返回“EBLN2000”，小订单状态需要置为“状态未明” modify by dengbing 20150519
				// 查询支付状态
				PaymentRequeryInfo paymentRequeryInfo = new PaymentRequeryInfo();
				paymentRequeryInfo.setTradeSeqNo(idGenarator.orderSerialNo());// 交易流水号
				paymentRequeryInfo.setOrderAmount("1");// 订单数
				paymentRequeryInfo.setRemark("MAL104");// 备注

				List<OrderBaseInfo> orderBaseInfoList = Lists.newArrayList();
				OrderBaseInfo orderBaseInfo = new OrderBaseInfo();
				orderBaseInfo.setOrderId(orderMain.getOrdermainId());// 订单号
				orderBaseInfo.setMerId(orderMain.getMerId()); // 商户号
				orderBaseInfo.setPayDate(orderMain.getCreateTime()); // 支付日期
				orderBaseInfoList.add(orderBaseInfo);

				paymentRequeryInfo.setOrderBaseInfos(orderBaseInfoList);// 订单基本信息

				// 调用 NSCT002 订单状态回查接口
				String tradeStatus = "";
				try {
					PaymentRequeryResult paymentRequeryResult = paymentService.paymentRequery(paymentRequeryInfo);
					// 1:支付成功 2:支付失败 3:状态未明 9:订单不存在 8:未知错误
					if (paymentRequeryResult.getInfos() != null && paymentRequeryResult.getInfos().size() > 0) {
						tradeStatus = paymentRequeryResult.getInfos().get(0).getTradeStatus();
					}
				} catch (Exception e) {
					log.error("[MAL104]调用NSCT002异常，orderId:" + orderMain.getOrdermainId() + ",tradeSeqNo:"
							+ paymentRequeryInfo.getTradeSeqNo(), e);
					tradeStatus = "19";
				}

				if ("1".equals(tradeStatus)) {
					payState = "1";
				} else if ("8".equals(tradeStatus) || "3".equals(tradeStatus) || "9".equals(tradeStatus)
						|| tradeStatus == null || "".equals(tradeStatus.trim()) || "19".equals(tradeStatus)) {
					// 8未知错误,9订单不存在，3状态未明是返回给CC的状态未明，其他都是支付失败或支付成功,2015_0402_免签账额修复：状态未明 异常发生 返回19 // 返回19
					errCode = retCode;
					payState = "3";
				} else {
					errCode = retCode;
					payState = "2";
				}
			} else if ("PP050001".equals(retCode)) {
				log.debug("【MAL104】流水：" + senderSN + "您兑换的签帐额不满足您当日的欠款，请兑换其他产品！");
				payState = "4";// 欠款不符合
				errCode = retCode;
			} else {// 支付失败
				errCode = retCode;
				payState = "2";
			}

			// 根据 主订单编号 查询 子订单列表
			Response<List<OrderSubModel>> orderResponse = orderService.findByOrderMainId(orderMainId);
			if (!orderResponse.isSuccess() || orderResponse.getResult() == null) {
				return errReturn("000012");
			}
			List<OrderSubModel> orderList = orderResponse.getResult();
			if (payResult != null && payResult.getPayTime() != null && !Strings.isNullOrEmpty(payResult.getPayTime())) {
				Date payTime = DateHelper.string2Date(payResult.getPayTime(), DateHelper.YYYYMMDDHHMMSS);
				for (OrderSubModel orderSub : orderList) {
					orderSub.setOrder_succ_timeStr(payResult.getPayTime());
					orderSub.setOrder_succ_time(payTime);
				}
				orderMain.setPayResultTime(payResult.getPayTime());
			}else{
				Date payTime = orderMain.getCreateTime();
				if (payTime == null){
					payTime = new Date();
				}
				for (OrderSubModel orderSub : orderList) {
					orderSub.setOrder_succ_timeStr(DateHelper.date2string(payTime,DateHelper.YYYYMMDDHHMMSS));
					orderSub.setOrder_succ_time(payTime);
				}
				orderMain.setPayResultTime(DateHelper.date2string(payTime,DateHelper.YYYYMMDDHHMMSS));
			}

			if ("1".equals(payState)) {// 如果支付成功
				// String dbTime = this.getDbTime(s2);
				uOrderMain.setPayResultTime(DateHelper.getyyyyMMddHHmmss(new Date()));
				uOrderMain.setCurStatusId(Contants.SUB_ORDER_STATUS_0308);
				uOrderMain.setCurStatusNm(Contants.SUB_ORDER_PAYMENT_SUCCEED);
				uOrderMain.setModifyTime(new Date());
				uOrderMain.setErrorCode(retCode);
				uOrderMain.setModifyOper("System");
				uOrderMain.setErrorCode(retCode);
				uOrderMain.setTotalPrice(new BigDecimal(smsTotalPrice));

				// 更新订单 调用事务
				Response response = orderService.updateCCAndIVRTureOrder(uOrderMain, orderList);
				if (!response.isSuccess()) {
					throw new Exception(response.getError());
				}
				// FIXME:mark by ldk 库存在创建订单时候就扣减了，这个时候高并发不就没有库存了吗
				// dealGoodsNum(goodsIdArray, itemMap, goodsNoArray);// 减库存
				// 发送通知短信
				sendSMSMessage(smsTotalBonus, smsTotalPrice, uOrderMain.getContMobPhone());
				try {
					// 查询是否有订单需要推送
					Response<List<OrderSubModel>> orderSubResponse = orderService.findByOrderMainId(orderMainId);

					List<OrderSubModel> orderSubList = orderSubResponse.getResult();
					List<String> vendorIdList = Lists.newArrayList();
					for (OrderSubModel orderSub : orderSubList) {
						vendorIdList.add(orderSub.getVendorId());
					}
					Response<Long> countResponse = vendorService.findNeedActionCount(vendorIdList);

					if (countResponse.getResult() > 0) {
						log.debug("大订单号中有需要实时推送：" + orderMainId);
						for (OrderSubModel orderSubModel : orderSubList) {
							orderSendForO2OService.orderSendForO2O(orderMainId, orderSubModel.getOrderId());
						}
					}
				} catch (Exception e) {
					log.error("多线程调o2o系统失败：Exception:{}", Throwables.getStackTraceAsString(e));
				}
			} else {
				if ("3".equals(payState)) {// 如果状态未明
					uOrderMain.setCurStatusId(Contants.SUB_ORDER_STATUS_0316);
					uOrderMain.setCurStatusNm(Contants.SUB_ORDER_UNCLEAR);
					successCode = "01";
					returnCode = "000012";
					ReturnDes = MallReturnCode.getReturnDes(returnCode);
					// FIXME:mark by ldk 库存在创建订单时候就扣减了，这个时候高并发不就没有库存了吗
					// dealGoodsNum(goodsIdArray, itemMap, goodsNoArray);// 减库存
				} else {// 如果支付失败
					uOrderMain.setCurStatusId(Contants.SUB_ORDER_STATUS_0307);
					uOrderMain.setCurStatusNm(Contants.SUB_ORDER_PAYMENT_FAILED);
					successCode = "01";
					returnCode = "000011";
					ReturnDes = MallReturnCode.getReturnDes(returnCode);
					if ("4".equals(payState)) {
						returnCode = "000069";
						ReturnDes = MallReturnCode.getReturnDes(returnCode);
					}
				}
				uOrderMain.setErrorCode(retCode);
				uOrderMain.setModifyTime(new Date());
				uOrderMain.setModifyOper("企业网银");

				// 更新订单 调用事务
				orderService.updateCCAndIVRFalseOrder(uOrderMain, orderList, payState, senderSN, birthList, retCode,
						payResult.getRetErrMsg());

			}
			// 提交事务
			if (Contants.SUB_ORDER_STATUS_0308.equals(uOrderMain.getCurStatusId())) {// 支付成功
				try {
					// 查询是否有订单需要推送
					Response<List<OrderSubModel>> orderSubResponse = orderService.findByOrderMainId(orderMainId);
					List<OrderSubModel> orderSubList = orderSubResponse.getResult();
					List<String> vendorIdList = Lists.newArrayList();
					for (OrderSubModel orderSub : orderSubList) {
						vendorIdList.add(orderSub.getVendorId());
					}
					Response<Long> countResponse = vendorService.findNeedActionCount(vendorIdList);
					// 查询订单是否实时推送
					if (countResponse.getResult() > 0) {
						log.debug("大订单号中有需要实时推送：" + orderMainId);
						for (OrderSubModel orderSubModel : orderSubList) {
							orderSendForO2OService.orderSendForO2O(orderMainId, orderSubModel.getOrderId());
						}
					}
				} catch (Exception e) {
					log.error("多线程调o2o系统失败：Exception:{}", Throwables.getStackTraceAsString(e));
				}
			}
			log.debug("【MAL104】流水：" + senderSN + "，下单支付完成后续流程事务提交完成，订单号:" + uOrderMain.getOrdermainId());
		} catch (Exception e) {
			// 如果调用企业网银接口抛异常，因为返回给CC只需要商城下单（插数据库）成功，所以捕捉异常
			log.error("【MAL104】流水：" + senderSN + "，Exception :{}", Throwables.getStackTraceAsString(e));
			successCode = "01";
			returnCode = "000012";
			ReturnDes = MallReturnCode.getReturnDes(returnCode);
			log.debug("【MAL104】流水：" + senderSN + "，下单成功，但后续流程出现异常,事务回滚，异常订单：" + orderMain.getOrdermainId());
		}
		/* 事务 s2 结束 -------------------------------------------------------------------------------------------- */

		// 返回成功报文
		result.setChannelSN("CCAG");
		result.setSuccessCode(successCode);
		result.setReturnCode(returnCode);
		result.setReturnDes(ReturnDes);
		result.setErrCode(errCode);
		result.setOrderMainId(orderMain.getOrdermainId());
		return result;
	}

	/**
	 * 判断是否能支付 000008:参数错误 000016:支付方式不存在 000024:CC渠道不允许支付 000025:IVR渠道不允许支付 CC:CC渠道能支付 IVR:IVR渠道能支付
	 *
	 * @param ivrFlag 渠道
	 * @return 判断结果
	 */
	public String judgmentQT(String ivrFlag) {
		log.info("支付方式:" + ivrFlag);
		if (ivrFlag != null && "0".equals(ivrFlag.trim())) {// CC
			log.info("is cc");
			Response<List<TblParametersModel>> response = businessService.findJudgeQT("JF", "01");
			List<TblParametersModel> list = response.getResult();

			if (list != null && list.size() > 0) {
				TblParametersModel tblParameters = list.get(0);
				String openCloseFlag = String.valueOf(tblParameters.getOpenCloseFlag());
				if (openCloseFlag != null && "1".equals(openCloseFlag)) {// 如果停止支付
					return "000024";
				} else {
					return "CC";
				}
			} else {
				return "CC";
			}
		} else if (ivrFlag != null && "1".equals(ivrFlag.trim())) {// IVR
			log.info("is ivr");
			Response<List<TblParametersModel>> response = businessService.findJudgeQT("JF", "01");
			List<TblParametersModel> list = response.getResult();
			if (list != null && list.size() > 0) {
				TblParametersModel tblParameters = list.get(0);
				String openCloseFlag = String.valueOf(tblParameters.getOpenCloseFlag());
				if (openCloseFlag != null && "1".equals(openCloseFlag)) {// 如果停止支付
					return "000025";
				} else {
					return "IVR";
				}
			} else {
				return "IVR";
			}
		} else {// 参数错误
			return "000008";
		}

	}

	/**
	 *
	 * <p>
	 * Description:遍历卡等级，取得最优客户等级 ，返回客户优先发货等级
	 * </p>
	 *
	 * @param cardLevelList 积分系统返回的卡信息
	 * @param formatId 卡板
	 * @return 客户最优等级
	 */
	private String getCustLevel(List<String> cardLevelList, String formatId) {
		log.info("getCustLevel遍历卡等级，取得最优客户等级 ，返回客户优先发货等级");
		// 遍历卡数组，取得最优客户等级
		// 如果还是没有取到相应的数据，则默认返回等级A,金普卡
		String cust_type = Contants.CUST_LEVEL_CODE_A;
		String custType = Contants.CUST_LEVEL_CODE_A;
		// 先查询卡板信息
		Response<LocalCardRelateModel> cardResponse = localCardRelateService.findByFormatId(formatId);
		if (!cardResponse.isSuccess()) {
			return cust_type;
		}
		LocalCardRelateModel localCardRelate = cardResponse.getResult();
		for (String custLevel : cardLevelList) {
			if (Contants.LEVEL_CODE_44.equals(custLevel)) {// 顶级卡
				custType = Contants.CUST_LEVEL_CODE_C;
			} else if (Contants.LEVEL_CODE_33.equals(custLevel)) {// 白金卡

				if (localCardRelate != null && "2".equals(localCardRelate.getProCode())) {
					custType = Contants.CUST_LEVEL_CODE_C;// 增值白金
				} else {
					custType = Contants.CUST_LEVEL_CODE_B;// 尊越/臻享白金+钛金卡
				}
			} else if (Contants.LEVEL_CODE_22.equals(custLevel)) {// 钛金卡
				custType = Contants.CUST_LEVEL_CODE_B;// 尊越/臻享白金+钛金卡
			}
			cust_type = cust_type.compareTo(custType) > 0 ? cust_type : custType;// 最终获得客户卡的最优客户级别
		}
		log.info("getCustLevel查询南航白金卡取得最优客户等级为:" + cust_type);
		return cust_type;
	}

	/**
	 * 校验下单参数<br>
	 * 处理逻辑<br>
	 * 1.校验参数是否为空<br>
	 * 2.根据参数的礼品ID和支付方式ID取得对应的礼品信息和支付方式，用于后面的校验<br>
	 * 3.计算礼品总数是否超过99个，和根据第2步得到值礼品信息和支付方式，计算应付的总金额和总积分<br>
	 * 4.报文传入的总金额和总积分与第3步计算好的应付的总金额和总积分
	 *
	 * @param custName 客户姓名
	 * @param deliveryName 收货人姓名
	 * @param deliveryMobile 收货人手机
	 * @param deliveryPhone 收货人固话
	 * @param deliveryAddr 送货地址
	 * @param acceptedNo 受理号
	 * @param orderType 下单方式
	 * @param ivrFlag IVR标识
	 * @param cardNo 卡号
	 * @param intergralType 积分类型
	 * @param intergralNo 积分值
	 * @param goodsPrice 现金
	 * @param goodsIdArray 商品编码
	 * @param paywayIdArray 支付编码
	 * @param goodsNoArray 兑换数量
	 * @return 校验是否通过
	 */
	private CCAndIVRIntergalOrderReturnVO checkReceiveOrderParam(CCAndIVRIntergalOrderReturnVO result, String custName,
			String deliveryName, String deliveryMobile, String deliveryPhone, String deliveryAddr, String acceptedNo,
			String orderType, String ivrFlag, String cardNo, String intergralType, String intergralNo,
			String goodsPrice, String[] goodsIdArray, String[] paywayIdArray, String[] goodsNoArray,
			Map<String, ItemGoodsDetailDto> itemMap, Map<String, TblGoodsPaywayModel> paywayMap,
			Map<String, TblCfgIntegraltypeModel> integraltypeMap) {
		result.setChannelSN("CCAG");
		result.setSuccessCode("00");

		// 注释①
		if (StringUtil.checkNull(custName) || StringUtil.checkNull(deliveryName) || StringUtil.checkNull(deliveryMobile)
				|| StringUtil.checkNull(deliveryAddr) || StringUtil.checkNull(acceptedNo)
				|| StringUtil.checkNull(orderType) || StringUtil.checkNull(ivrFlag) || StringUtil.checkNull(cardNo)
				|| StringUtil.checkNull(intergralType) || StringUtil.checkNull(intergralNo)
				|| StringUtil.checkNull(goodsPrice)) {
			result.setReturnCode("000008");
			result.setReturnDes(MallReturnCode.REQUEST_PARAMETERERROR_DES);
			return result;
		}

		if (custName.length() > 30 || deliveryName.length() > 30 || deliveryMobile.length() > 20
				|| deliveryPhone.length() > 30 || deliveryAddr.length() > 200 || acceptedNo.length() > 20
				|| orderType.length() > 1 || ivrFlag.length() > 1 || cardNo.length() > 1050
				|| intergralType.length() > 200 || intergralNo.length() > 500 || goodsPrice.length() > 650
				|| custName.length() > 1050 || custName.length() > 150) {
			result.setReturnCode("000008");
			result.setReturnDes(MallReturnCode.REQUEST_PARAMETERERROR_DES);
			return result;
		}

		if (!("1".equals(orderType.trim()) || "2".equals(orderType.trim()))) {// 检验orderType
			result.setReturnCode("000008");
			result.setReturnDes(MallReturnCode.REQUEST_PARAMETERERROR_DES);
			return result;
		}

		if (goodsIdArray.length != paywayIdArray.length || paywayIdArray.length != goodsNoArray.length) {
			result.setReturnCode("000008");
			result.setReturnDes(MallReturnCode.REQUEST_PARAMETERERROR_DES);
			return result;
		}

		for (String goodsIdTemp : goodsIdArray) {
			if (StringUtil.checkNull(goodsIdTemp)) {
				result.setReturnCode("000008");
				result.setReturnDes(MallReturnCode.REQUEST_PARAMETERERROR_DES);
				return result;
			}
		}
		for (String payWayId : paywayIdArray) {
			if (StringUtil.checkNull(payWayId)) {
				result.setReturnCode("000008");
				result.setReturnDes(MallReturnCode.REQUEST_PARAMETERERROR_DES);
				return result;
			}
		}
		// 注释①完

		// 初始化积分类型map
		initIntegraltypeMap(integraltypeMap);

		// 注释②
		// 校验支付方式
		Response<List<TblGoodsPaywayModel>> payWayResponse = goodsPayWayService
				.findByGoodsPayWayIdList(Arrays.asList(paywayIdArray));
		if (!payWayResponse.isSuccess()) {
			result.setReturnCode("000008");
			result.setReturnDes(MallReturnCode.REQUEST_PARAMETERERROR_DES);
			return result;
		}
		List<TblGoodsPaywayModel> paywayList = payWayResponse.getResult();
		if (paywayList != null && paywayList.size() > 0)
			for (TblGoodsPaywayModel payway : paywayList) {
				paywayMap.put(payway.getGoodsPaywayId(), payway);
			}
		// Response<List<ItemGoodsDetailDto>> itemResponse = itemService.findByIds(Arrays.asList(goodsIdArray));
		Response<List<ItemGoodsDetailDto>> itemResponse = itemService.findByXids(Arrays.asList(goodsIdArray));
		if (!itemResponse.isSuccess()) {
			return errReturn("000011");
		}
		List<ItemGoodsDetailDto> goodsList = itemResponse.getResult();

		if (goodsList != null && goodsList.size() > 0)
			for (ItemGoodsDetailDto goodsInf : goodsList) {
				itemMap.put(goodsInf.getXid(), goodsInf);// xwl 20161010
			}

		int totalGoodsCount = 0;
		double totalMoney = 0;
		Map<String, Long> totalBonusMap = Maps.newHashMap();

		Map<String, Integer> tempGoodsCountMap = Maps.newHashMap();

		// 商品总数量，不超过99个，并且计算支付方式价格和积分的总值,积分总值，按积分类型存放在Map中
		for (int goodsNoArrayCount = 0; goodsNoArrayCount < goodsNoArray.length; goodsNoArrayCount++) {
			try {
				String goodsNo = goodsNoArray[goodsNoArrayCount].trim();
				int thisCount;
				if (goodsNo.length() > 0) {
					thisCount = Integer.parseInt(goodsNo);
				} else {
					thisCount = 0;
				}

				TblGoodsPaywayModel payway = paywayMap.get(paywayIdArray[goodsNoArrayCount]);
				// 如果没有该支付方式，返回错误信息
				if (payway == null) {
					// 000016 传入支付方式不存在
					result.setReturnCode("000016");
					result.setReturnDes(MallReturnCode.getReturnDes("000016"));
					return result;
				}
				ItemGoodsDetailDto goodsInf = itemMap.get(goodsIdArray[goodsNoArrayCount]);
				// 如果没有该礼品信息，返回错误信息
				if (goodsInf == null) {
					// 000010 找不到礼品
					result.setReturnCode("000010");
					result.setReturnDes(MallReturnCode.getReturnDes("000010"));
					return result;
				}
				// 判断上架状态
				if (Contants.CHANNEL_IVR_CODE.equals(ivrFlag)
						&& !Contants.CHANNEL_IVR_02.equals(goodsInf.getChannelIvr())) {// ivr 渠道不在上架状态
					result.setReturnCode("000070");
					result.setReturnDes("礼品:" + goodsInf.getGoodsName() + "不在上架状态");
					return result;
				}

				if (Contants.CHANNEL_CC_CODE.equals(ivrFlag)
						&& !Contants.CHANNEL_CC_02.equals(goodsInf.getChannelCc())) {// CC 渠道不在上架状态
					result.setReturnCode("000070");
					result.setReturnDes("礼品:" + goodsInf.getGoodsName() + "不在上架状态");
					return result;
				}

				Integer tempGoodsCount = tempGoodsCountMap.get(goodsIdArray[goodsNoArrayCount]);
				if (tempGoodsCount == null) {
					tempGoodsCount = 0;
				}
				tempGoodsCount = tempGoodsCount + thisCount;
				// FIXME:mark by ldk 虚拟礼品也一样，判断库存。库存别忘了9999时候是无限大
				/*
				 * if ("0001".equals(goodsInf.getGoodsType())) {// 如果是虚拟礼品不做库存判断 if (thisCount > 100000) {//
				 * 虚拟礼品一次购买不超过100000个 result.setReturnCode("000058");
				 * result.setReturnDes(MallReturnCode.getReturnDes("000058")); return result; } } else {
				 */
				totalGoodsCount = totalGoodsCount + thisCount;
				long existsCount = goodsInf.getStock();
				if (existsCount < 9999 && existsCount - tempGoodsCount < 0) {// 根据实际库存数量下单
					// 000022 超过警戒值
					result.setReturnCode("000022");
					result.setReturnDes(MallReturnCode.getReturnDes("000022"));
					return result;
				}
				// }

				tempGoodsCountMap.put(goodsIdArray[goodsNoArrayCount], tempGoodsCount);

				totalMoney = totalMoney + new BigDecimal(thisCount).multiply(payway.getGoodsPrice()).doubleValue();

				String goodsIntegralType = goodsInf.getPointsType();
				if (goodsIntegralType != null) {
					goodsIntegralType = goodsIntegralType.trim();
				}
				Long totalBonus = totalBonusMap.get(goodsIntegralType);
				if (totalBonus == null)
					totalBonus = 0l;
				totalBonusMap.put(goodsIntegralType, totalBonus + thisCount * payway.getGoodsPoint());
			} catch (Exception e) {
				log.error("【MAL104】流水：校验下单信息异常：", e);
				// 000010 找不到礼品
				result.setReturnCode("000008");
				result.setReturnDes(MallReturnCode.getReturnDes("000008"));
				return result;
			}
		}
		// 商品总数量超出99个时返回失败报文
		if (totalGoodsCount > 99) {
			// 000017 订单商品数量总数不能超过99个
			result.setReturnCode("000017");
			result.setReturnDes(MallReturnCode.getReturnDes("000017"));
			return result;
		}

		// 计算支付支付编码的总价格和总积分值是否和报文传的值相同
		String[] envMoneyArray = goodsPrice.split("\\|");
		String[] bonusArray = intergralNo.split("\\|");
		String[] bonusTypeArray = intergralType.split("\\|");
		if (envMoneyArray.length != bonusArray.length || bonusArray.length != bonusTypeArray.length) {
			result.setReturnCode("000008");
			result.setReturnDes(MallReturnCode.getReturnDes("000008"));
			return result;
		}
		// 报文总金额
		double totalEnvMoney = 0;
		for (String envMoney : envMoneyArray) {
			try {
				totalEnvMoney += StringUtil.ccEnvelopeStringToDouble(envMoney);
			} catch (Exception e) {
				// 报文数据非12位数字
				// 000018 金额转换异常
				result.setReturnCode("000018");
				result.setReturnDes(MallReturnCode.getReturnDes("000018"));
				return result;
			}
		}
		// 报文总积分
		Map<String, Long> envBonusMap = Maps.newHashMap();
		for (int envBonusIndex = 0; envBonusIndex < bonusArray.length; envBonusIndex++) {
			String bonusType = bonusTypeArray[envBonusIndex].trim();
			if (bonusType.length() > 0) {
				Long bonus = envBonusMap.get(bonusType);
				if (bonus == null)
					bonus = 0l;
				try {
					bonus = bonus + Long.parseLong(bonusArray[envBonusIndex].trim());
					envBonusMap.put(bonusType, bonus);
				} catch (Exception e) {
					// 报文数据非数字
					// 000019 积分转换异常
					result.setReturnCode("000019");
					result.setReturnDes(MallReturnCode.getReturnDes("000019"));
					return result;
				}
			}

		}
		// 比较总金额
		if (totalMoney != totalEnvMoney) {
			// 000020 订单金额不匹配
			result.setReturnCode("000020");
			result.setReturnDes(MallReturnCode.getReturnDes("000020"));
			return result;
		}
		// 比较积分
		Set<String> bonusTypeSet = totalBonusMap.keySet();
		Set envBonusTypeSet = envBonusMap.keySet();
		if (bonusTypeSet.size() != envBonusTypeSet.size()) {
			// 000021 订单积分不匹配
			result.setReturnCode("000021");
			result.setReturnDes(MallReturnCode.getReturnDes("000021"));
			return result;
		}

		for (String bonusType : bonusTypeSet) {
			if (bonusType != null) {
				bonusType = bonusType.trim();
			}
			Long bonus = totalBonusMap.get(bonusType);
			Long envBonus = envBonusMap.get(bonusType);
			if (envBonus == null || envBonus.intValue() != bonus.intValue()) {
				// 000021 订单积分不匹配
				result.setReturnCode("000021");
				result.setReturnDes(MallReturnCode.getReturnDes("000021"));
				return result;
			}
		}

		// 检验地址时候符合 省份|城市|详细地址 这种格式
		String[] st = deliveryAddr.split("\\|");
		if (st.length != 3) {// 如果格式不对
			result.setReturnCode("000023");
			result.setReturnDes(MallReturnCode.getReturnDes("000023"));
			return result;
		}

		return null;
	}

	/**
	 * 将List转换成以支付编码未Key，TblGoodsPayway为Value的Map
	 *
	 * @param paywayList 支付方式列表
	 * @return Map
	 */
	private Map<String, TblGoodsPaywayModel> convertPaywayListToMap(List<TblGoodsPaywayModel> paywayList) {
		Map<String, TblGoodsPaywayModel> map = Maps.newHashMap();
		if (paywayList != null && paywayList.size() > 0)
			for (TblGoodsPaywayModel payway : paywayList) {
				map.put(payway.getGoodsPaywayId(), payway);
			}
		return map;
	}

	/**
	 * 返回错误报文
	 * 
	 * @param errCode 错误码
	 * @return 错误返回对象
	 */
	private CCAndIVRIntergalOrderReturnVO errReturn(String errCode) {
		CCAndIVRIntergalOrderReturnVO result = new CCAndIVRIntergalOrderReturnVO();
		result.setChannelSN("CCAG");
		result.setSuccessCode("00");
		result.setReturnCode(errCode);
		result.setReturnDes(MallReturnCode.getReturnDes(errCode));
		return result;
	}

	/**
	 * 将List转换成以支付编码未Key，VendorInfoModel为Value的Map
	 *
	 * @param vendorList 供应商列表
	 * @return Map
	 */
	private Map<String, VendorInfoModel> convertVendorListToMap(List<VendorInfoModel> vendorList) {
		Map<String, VendorInfoModel> map = Maps.newHashMap();
		if (vendorList != null && vendorList.size() > 0)
			for (VendorInfoModel vendorInf : vendorList) {
				map.put(vendorInf.getVendorId(), vendorInf);
			}
		return map;
	}

	/**
	 * 将List转换成以支付编码未Key，TblGoodsInf为Value的Map
	 *
	 * @param goodsList 商品列表
	 * @return Map
	 */
	private Map<String, ItemGoodsDetailDto> convertGoodsListToMap(List<ItemGoodsDetailDto> goodsList) {
		Map<String, ItemGoodsDetailDto> map = Maps.newHashMap();
		if (goodsList != null && goodsList.size() > 0)
			for (ItemGoodsDetailDto goodsInf : goodsList) {
				map.put(goodsInf.getCode(), goodsInf);
			}
		return map;
	}

	/**
	 * 减库存
	 * 
	 * @param goodsIdArray 商品id列表（新系统用单品id）
	 * @param itemMap 商品单品列表
	 * @param goodsNoArray 单品数量列表
	 */
	private void dealGoodsNum(String[] goodsIdArray, Map<String, ItemGoodsDetailDto> itemMap, String[] goodsNoArray)
			throws Exception {
		for (int goodsIndex = 0; goodsIndex < goodsIdArray.length; goodsIndex++) {
			String itemCode = goodsIdArray[goodsIndex];
			ItemGoodsDetailDto goodsInf = itemMap.get(itemCode);
			if (goodsInf.getStock() < 9999) {// 如果商品库存小于9999，才减库存
				Long goodsNum = 0l;
				try {
					goodsNum = Long.parseLong(goodsNoArray[goodsIndex].trim());
				} catch (Exception e) {
					e.printStackTrace();
					log.error("【MAL104】Exception:{}", e);
				}
				// 商品数量减少
				Long remainLog = goodsInf.getStock() - goodsNum;
				goodsInf.setStock(remainLog);
				// 更新单品表库存
				itemService.update(goodsInf);
				// 重新放入MAP，下次取到的礼品是本次已经数量减去1的礼品信息记录
				itemMap.put(itemCode, goodsInf);
			}
		}
	}

	private OrderSubModel accTblOrder(String merId, OrderMainModel orderMain, int operSeq, ItemGoodsDetailDto goodsInf,
			TblGoodsPaywayModel payway, VendorInfoModel vendorInf, String cardno, String ivrFlag, String createOper,
			int goodsNum, Map<String, TblCfgIntegraltypeModel> integraltypeMap, String custName) {
		OrderSubModel order = new OrderSubModel();
		String orderId = orderMain.getOrdermainId() + (operSeq < 10 ? ("0" + operSeq) : operSeq);
		order.setDelFlag("0");// 未删除
		order.setRemindeFlag(0);// 未提醒
		order.setItemSmallPic(goodsInf.getImage1());// 商品图片
		order.setO2oExpireFlag(0);// O2O未操作过
		order.setFenefit(new BigDecimal("0.00"));// 优惠差额
		order.setOrderId(orderId);// ORDER_ID 子订单号
		order.setReferenceNo("");// REFERENCE_NO 参考号码
		order.setOperSeq(operSeq);// OPER_SEQ 业务订单同步序号
		order.setOrderIdHost("");// ORDER_ID_HOST 主机订单号
		order.setOrdertypeId("JF");// ORDERTYPE_ID 业务类型代码
		order.setOrdertypeNm("积分");// ORDERTYPE_NM 业务类型名称
		order.setPaywayCode(payway.getPaywayCode());// PAYWAY_CODE 支付方式代码
		order.setPaywayNm("积分");// PAYWAY_NM 支付方式名称
		order.setOrdermainId(orderMain.getOrdermainId());// ORDERMAIN_ID 主订单号
		order.setCardno(cardno);// CARDNO 卡号
		order.setCardnoBenefit("");// CARDNO_BENEFIT 受益卡号
		order.setValidateCode("");// VALIDATE_CODE 验证码
		order.setVerifyFlag("");// VERIFY_FLAG 下单验证标记
		order.setVendorId(vendorInf.getVendorId());// VENDOR_ID 供应商代码
		order.setVendorSnm(vendorInf.getSimpleName());// VENDOR_SNM 供应商名称简写
		order.setMiaoshaActionFlag(0);
		if ("0".equals(ivrFlag)) {
			order.setSourceId("01");// SOURCE_ID 订购渠道（下单渠道）
			order.setSourceNm("CALL CENTER");// SOURCE_NM 渠道名称
		} else {
			order.setSourceId("02");// SOURCE_ID 订购渠道（下单渠道）
			order.setSourceNm("IVR");// SOURCE_NM 渠道名称
		}
		order.setMemberName(custName);
		order.setGoodsId(goodsInf.getCode());// 单品编码
		order.setGoodsCode(goodsInf.getGoodsCode());
		order.setGoodsPaywayId(payway.getGoodsPaywayId());// GOODS_PAYWAY_ID
		// 商品支付编码

		/**
		 * 20150617 hwh 修改:ivr买虚拟商品数量问题（CC自建，IVR也能买虚拟礼品）
		 * if(ivrFlag!=null&&"0".equals(ivrFlag)&&"0001".equals(goodsInf.getGoodsType())){//针对虚拟礼品，
		 */
		if (Contants.GOODS_TYPE_ID_01.equals(goodsInf.getGoodsType())) {// 针对虚拟礼品
			order.setGoodsType(Contants.GOODS_TYPE_ID_01);
			order.setGoodsTypeName(Contants.GOODS_TYPE_NM_01);
			order.setGoodsNum(goodsNum);// 订单中商品数目可能不为1
			order.setSingleBonus(payway.getGoodsPoint());// 针对CC虚拟礼品的订单，该字段存入总的积分值
			order.setBonusTotalvalue(goodsNum * payway.getGoodsPoint());// BONUS_TOTALVALUE
			// 积分总数
			/********** 需要确认是否需要乘以商品数量 **********/
			order.setCalMoney(new BigDecimal(goodsNum).multiply(payway.getCalMoney()));// CAL_MONEY 清算总金额
			order.setOrigMoney(new BigDecimal(goodsNum).multiply(payway.getGoodsPrice()));// ORIG_MONEY 原始现金总金额
			order.setTotalMoney(new BigDecimal(goodsNum).multiply(payway.getGoodsPrice()));// TOTAL_MONEY 现金总金额
		} else {// 非虚拟礼品
			order.setGoodsType(Contants.GOODS_TYPE_ID_00);
			order.setGoodsTypeName(Contants.GOODS_TYPE_NM_00);
			order.setGoodsNum(1);// GOODS_NUM 商品数量,一个子订单只有一件商品
			order.setSingleBonus(payway.getGoodsPoint());// 积分
			order.setBonusTotalvalue(payway.getGoodsPoint());// BONUS_TOTALVALUE
			// 积分总数
			order.setCalMoney(payway.getCalMoney());// CAL_MONEY 清算总金额
			order.setOrigMoney(payway.getGoodsPrice());// ORIG_MONEY 原始现金总金额
			order.setTotalMoney(payway.getGoodsPrice());// TOTAL_MONEY 现金总金额
		}
		order.setGoodsNm(goodsInf.getGoodsName());// GOODS_NM 商品名称
		order.setMachCode(goodsInf.getMachCode());// MACH_COD 商品条行码
		order.setCurrType("156");// CURR_TYPE 商品币种
		order.setExchangeRate(new BigDecimal(0));// EXCHANGE_RATE 对人民币的汇率值
		order.setTypeId(goodsInf.getGoodsType());// TYPE_ID 商品类别ID
		order.setLevelNm("");// LEVEL_NM 商品类别名称
		order.setGoodsBrand(goodsInf.getGoodsBrandName());// GOODS_BRAND 品牌
		order.setGoodsModel("");// GOODS_MODEL 型号
		order.setGoodsColor("");// GOODS_COLOR 商品颜色
		order.setGoodsPresent("");// GOODS_PRESENT 赠品
		order.setGoodsPresentDesc("");// GOODS_PRESENT_DESC
		// 赠品说明
		order.setSpecFlag("");// SPEC_FLAG 是否特选商品
		order.setSpecDesc("");// SPEC_DESC 特别备注信息
		order.setGoodsRange("");// GOODS_RANGE 送货范围
		order.setGoodsLocal("");// GOODS_LOCAL 是否现场兑换
		order.setGoodssendFlag("0");// GOODSSEND_FLAG 发货标记
		order.setGoodsaskforFlag("0");// GOODSASKFOR_FLAG 请款标记
		order.setGoodsBill("");// GOODS_BILL 商品账单描述
		order.setGoodsDesc("");// GOODS_DESC 商品备注
		order.setGoodsResv1("");// GOODS_RESV1 商品保留字段一
		order.setSpecShopnoType("");// SPEC_SHOPNO_TYPE 特店类型
		// order.setPayType("");// PAY_TYPE 佣金代码
		order.setPayTypeNm("");// PAY_TYPE_NM 佣金代码名称
		order.setIncCode("");// INC_CODE 手续费率代码
		order.setIncCodeNm("");// INC_CODE_NM 手续费率名称
		order.setStagesNum(0);// STAGES_NUM 现金[或积分]分期数
		order.setCommissionType("");// COMMISSION_TYPE 佣金计算类别
		order.setCommissionRate(new BigDecimal(0));// COMMISSION_RATE 佣金区间佣金率(不包含%)
		order.setCommission(new BigDecimal(0));// COMMISSION 佣金金额【与币种一致】
		order.setBankNbr("");// BANK_NBR 银行号
		order.setSpecShopno("");// SPEC_SHOPNO 特店号
		order.setBonusBankNbr("");// BONUS_BANK_NBR 积分银行号
		order.setBonusSpecShopno("");// BONUS_SPEC_SHOPNO 积分特店号
		order.setPayCode("");// PAY_CODE 缴款方案代码
		order.setProdCode("");// PROD_CODE 分期产品代码
		order.setPlanCode("");// PLAN_CODE 分期计划代码
		order.setStagesDesc("");// STAGES_DESC 分期描述
		order.setMcc(vendorInf.getMcc());// MCC mcc号
		order.setIncWay("");// INC_WAY 手续费获取方式
		order.setIncTakeWay("");// INC_TAKE_WAY 手续费计算方式
		order.setIncType("");// INC_TYPE 手续费类别
		order.setIncRate(new BigDecimal(0));// INC_RATE 手续费率(不包含%)
		order.setIncMoney(new BigDecimal(0));// INC_MONEY 手续费总金额
		order.setIncDesc("");// INC_DESC 手续费描述
		order.setUitopsfee("");// UITOPSFEE 手续费收取方式
		order.setUitfeeflg(0);// UITFEEFLG 手续费减免期数
		order.setUitfeedam(new BigDecimal(0));// UITFEEDAM 手续费减免金额
		order.setUitopsdate("");// UITOPSDATE 分期开始日期
		order.setUitdrtuit(0);// UITDRTUIT 本金减免期数
		order.setUitdrtamt(new BigDecimal(0));// UITDRTAMT 本金减免金额
		order.setIncBackway("");// INC_BACKWAY 手续费退回方式
		order.setIncBackPrice(new BigDecimal(0));// INC_BACK_PRICE 手续费退回指定金额
		order.setIncTakePrice(new BigDecimal(0));// INC_TAKE_PRICE 退单时收取指定金额手续费

		if ("0".equals(payway.getIsAction())) {// 非活动
			order.setActType("0");// ACT_TYPE 活动类型
		} else {
			// 查询单品活动类型 ADD BY geshuo
			// CC，短信，搭销默认商城渠道00
			// 查询商品活动信息 type传1，代表只取得正在进行的活动
			Response<MallPromotionResultDto> promResponse = mallPromotionService.findPromByItemCodes("1",
					goodsInf.getCode(), "00");

			if (promResponse.isSuccess() && promResponse.getResult() != null) {
				MallPromotionResultDto promotionResultDto = promResponse.getResult();
				if (promotionResultDto.getPromItemResultList() != null
						&& promotionResultDto.getPromItemResultList().size() > 0) {
					promotionResultDto.getPromType();
					order.setActType(String.valueOf(promotionResultDto.getPromType()));// 取得活动类型
				}
			}
		}
		order.setVoucherId("");// VOUCHER_ID 优惠券代码
		order.setVoucherNm("");// VOUCHER_NM 优惠券名称
		order.setVoucherPrice(new BigDecimal(0));// VOUCHER_PRICE 优惠金额
		order.setCreditFlag("0");// CREDIT_FLAG 授权额度不足处理方式
		order.setCashAuthType("");// CASH_AUTH_TYPE 现金授权类型
		order.setAccreditDate("");// ACCREDIT_DATE 授权日期
		order.setAccreditTime("");// ACCREDIT_TIME 授权时间
		order.setAuthCode("");// AUTH_CODE 授权码
		order.setRtnCode("");// RTN_CODE 主机授权回应代码
		order.setRtnDesc("");// RTN_DESC 主机授权回应代码说明
		order.setTxnMsg1Desc("");// TXN_MSG1_DESC 通讯消息说明1
		order.setTxnMsg2Desc("");// TXN_MSG2_DESC 通讯消息说明2
		order.setHostAccCode("");// HOST_ACC_CODE 主机入账回应代码
		order.setHostAccDesc("");// HOST_ACC_DESC 主机入账回应代码说明
		order.setBonusTrnDate("");// BONUS_TRN_DATE 支付日期
		order.setBonusTrnTime("");// BONUS_TRN_TIME 支付时间
		order.setBonusTraceNo("");// BONUS_TRACE_NO 系统跟踪号
		order.setBonusAuthType("");// BONUS_AUTH_TYPE 积分授权类型
		order.setBonusAccreditDate("");// BONUS_ACCREDIT_DATE BONUS授权日期
		order.setBonusAccreditTime("");// BONUS_ACCREDIT_TIME BONUS授权时间
		order.setBonusAuthCode("");// BONUS_AUTH_CODE BONUS授权码
		order.setBonusRtnCode("");// BONUS_RTN_CODE BONUS主机授权回应代码
		order.setBonusRtnDesc("");// BONUS_RTN_DESC BONUS主机授权回应代码说明
		order.setBonusTxnMsgDesc("");// BONUS_TXN_MSG_DESC BONUS通讯消息说明
		order.setCalWay("1");// CAL_WAY 退货方式
		order.setLockedFlag("0");// LOCKED_FLAG 订单锁标记
		order.setVendorOperFlag("0");// VENDOR_OPER_FLAG 供应商操作标记
		order.setMsgContent("");// MSG_CONTENT 上行短信内容
		order.setOrderDesc("");// ORDER_DESC 订单表备注
		order.setTmpStatusId("0000");// TMP_STATUS_ID 临时状态代码
		order.setCurStatusId(Contants.SUB_ORDER_STATUS_0301);// CUR_STATUS_ID
		// 当前状态代码
		order.setCurStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);// CUR_STATUS_NM
		// 当前状态名称
		order.setCreateOper(createOper);// CREATE_OPER 创建操作员ID
		order.setModifyOper(createOper);// MODIFY_OPER 修改操作员ID
		order.setCreateTime(orderMain.getCreateTime());// CREATE_TIME 创建时间 xiewl 20161021 16:47
		order.setCommDate(DateHelper.getyyyyMMdd());// COMM_DATE 业务日期
		order.setCommTime(DateHelper.getHHmmss());// COMM_TIME 业务时间
		order.setModifyTime(new Date());// MODIFY_TIME 修改时间
		order.setVersionNum(0);// VERSION_NUM 记录更新控制版本号
		order.setExt1("");// EXT_1 扩展属性一
		order.setExt2("");// EXT_2 分期为BIU的分期代码
		order.setExt3("");// EXT_3 扩展属性三
		order.setReserved1("");// RESERVED1 保留字段
		order.setRuleId("");// RULE_ID 规则ID
		order.setRuleNm("");// RULE_NM 规则名称
		order.setLimitCode("");// LIMIT_CODE 规则限制代码
		order.setVoucherNo("");// VOUCHER_NO 优惠券编码
		order.setActId("");// ACT_ID ACT_ID
		order.setCustType("");// CUST_TYPE CUST_TYPE
		order.setAccreditType("");// ACCREDIT_TYPE ACCREDIT_TYPE
		order.setAcctNo("");// ACCT_NO ACCT_NO
		order.setAppFlag("");// APP_FLAG APP_FLAG
		order.setCashTraceNo1("");// CASH_TRACE_NO_1 CASH_TRACE_NO_1
		order.setCashTraceNo2("");// CASH_TRACE_NO_2 CASH_TRACE_NO_2
		order.setBankNbr2("");// BANK_NBR_2 BANK_NBR_2
		order.setSpecShopno2("");// SPEC_SHOPNO_2 SPEC_SHOPNO_2
		order.setAccreditDate2("");// ACCREDIT_DATE_2 ACCREDIT_DATE_2
		order.setAccreditTime2("");// ACCREDIT_TIME_2 ACCREDIT_TIME_2
		order.setAuthCode2("");// AUTH_CODE_2 AUTH_CODE_2
		order.setActCategory("");// ACT_CATEGORY ACT_CATEGORY
		order.setActName("");// ACT_NAME ACT_NAME
		order.setUserAsscNbr("");//
		order.setVendorPhone("");//
		order.setDfacct("");//
		order.setDfname("");//
		order.setDfhnbr("");//
		order.setDfhname("");//
		order.setCvv2("");//
		order.setLogisticsSynFlag("");//
		// order.setOrder_succ_time(orderMain.getCreateTime());//
		order.setSinglePrice(payway.getGoodsPrice());// 单价

		String integralId = goodsInf.getPointsType();// 积分类型id
		order.setBonusType(integralId);// 积分类型

		TblCfgIntegraltypeModel tblCfgIntegraltype = integraltypeMap.get(integralId);

		// 查询积分类型
		order.setBonusTypeNm(tblCfgIntegraltype != null ? tblCfgIntegraltype.getIntegraltypeNm() : "");// 积分类型名称
		order.setBalanceStatus("");//
		order.setBatchNo("");//

		order.setEUpdateStatus("0");// 更新状态
		order.setMemberLevel(payway.getMemberLevel());// 会员等级
		order.setIntegraltypeId(goodsInf.getPointsType());// 积分类型
		order.setMerId(merId);// 商户号

		return order;
	}

	/**
	 * 发送短信
	 * 
	 * @param totalBonus 积分
	 * @param totalPrice 价格
	 * @param mobilePhone 电话号码
	 * @return 发送结果
	 */
	private boolean sendSMSMessage(long totalBonus, double totalPrice, String mobilePhone) {
		try {
			SendSMSInfo sendSMSInfo = new SendSMSInfo();
			sendSMSInfo.setSmsId("FH");
			if (totalPrice > 0) {
				sendSMSInfo.setTemplateId("072FH00001");
				// 尊敬的客户：您广发卡积分换领需求已受理，将在您的帐户内扣除[TOP]积分及换购额[TOS]元，请您留意。
			} else {
				sendSMSInfo.setTemplateId("072FH00002");
				// 尊敬的客户：您广发卡积分换领需求已受理，将在您的帐户内扣除[TOP]积分，请您留意。
			}

			sendSMSInfo.setSerial(getSerial());
			sendSMSInfo.setChannelCode("072");
			sendSMSInfo.setSendBranch("010000");
			sendSMSInfo.setMobile(mobilePhone);
			sendSMSInfo.setIdCode("");
			sendSMSInfo.setIdType("");

			sendSMSInfo.setTop(totalBonus + "");
			if (totalPrice > 0) {
				sendSMSInfo.setTos(totalPrice + "");
			}
			SendSMSNotifyResult sendSMSNotifyResult = smsService.sendSMS(sendSMSInfo);
			log.debug("短信发送结果:{}", sendSMSNotifyResult.getRetCode());

		} catch (Exception e) {
			log.error("sendSMSMessage Exception:{}", Throwables.getStackTraceAsString(e));
			return false;
		}
		return true;
	}

	/**
	 * 返回流水号 格式YYYYMMDDHHMMSSXXXXXX
	 *
	 * @return 序列号 wushiyi
	 */
	private String getSerial() {
		java.util.Date dateTime = new java.util.Date();
		String p_Serial = DateHelper.date2string(dateTime, DateHelper.YYYYMMDDHHMMSS);
		String A_Serial = "00";
		return p_Serial + A_Serial;
	}

	private OrderMainModel accTblOrderMain(String tradeSeqNo, String isMerger, String merId, String custName,
			String deliveryName, String deliveryMobile, String deliveryPhone, String deliveryAddr, String acceptedNo,
			String ivrFlag, String cardNoWithMoney, String contIdCard, String createOper, String desc1, String desc2,
			String desc3, String deliveryPost, String ordermainDesc, String[] goodsNoArray, String[] intergralNoArray) {
		// 客户姓名
		// 收货人姓名
		// 收货人手机
		// 收货人固话
		// 送货地址
		// 受理号
		// 下单方式 orderType
		// IVR标识 ivrFlag
		// 卡号 cardNo
		// 积分类型 intergralType
		// 积分值 intergralNo
		// 现金 goodsPrice
		// 循环体标识 goodsLoopTag
		// 循环体记录数 goodsLoopCount
		// 商品编码 goodsId
		// 支付编码 paywayId
		// 兑换数量 goodsNo
		String[] st = deliveryAddr.split("\\|");
		String csgProvince = st[0];// 省
		String csgCity = st[1];// 市
		String contAddress = st[2];// 详细地址

		OrderMainModel orderMain = new OrderMainModel();
		String orderMainId;
		if ("0".equals(ivrFlag)) {
			orderMainId = idGenarator.orderMainId("01");// 01：CC
		} else {
			orderMainId = idGenarator.orderMainId("02");// 02：IVR
		}
		orderMain.setOrdermainId(orderMainId);

		orderMain.setDelFlag(0); // 未删除
		orderMain.setIsInvoice("0");// 不开发票
		orderMain.setReferenceNo("");// REFERENCE_NO 参考号码
		orderMain.setOrdertypeId(Contants.BUSINESS_TYPE_JF);// ORDERTYPE_ID 业务类型id
		orderMain.setOrdertypeNm(Contants.BUSINESS_TYPE_NM_JF);// ORDERTYPE_NM 业务类型名称
		orderMain.setCardno(cardNoWithMoney);// CARDNO 卡号
		orderMain.setPermLimit(new BigDecimal(0));// PERM_LIMIT 永久额度（默认0）
		orderMain.setCashLimit(new BigDecimal(0));// CASH_LIMIT 取现额度（默认0）
		orderMain.setStagesLimit(new BigDecimal(0));// STAGES_LIMIT 分期额度（默认0）
		orderMain.setCardUserid("");// CARD_USERID 持卡人代码（）
		orderMain.setContIdType("");// CONT_ID_TYPE 订货人证件类型
		orderMain.setContIdcard(contIdCard);// CONT_IDCARD 订货人证件号码
		orderMain.setContNm(custName);// CONT_NM 订货人姓名
		orderMain.setContNmPy("");// CONT_NM_PY 订货人姓名拼音
		orderMain.setContPostcode(deliveryPost);// CONT_POSTCODE 订货人邮政编码
		orderMain.setCsgProvince(csgProvince);// CSG_PROVINCE 省
		orderMain.setCsgCity(csgCity);// CSG_CITY 市
		orderMain.setContAddress(contAddress);// CONT_ADDRESS 订货人详细地址
		orderMain.setContMobPhone(deliveryMobile);// CONT_MOB_PHONE 订货人手机
		orderMain.setContHphone(deliveryPhone);// CONT_HPHONE 订货人家里电话
		orderMain.setCsgName(deliveryName);// CSG_NAME 收货人姓名
		orderMain.setCsgIdType("");// CSG_ID_TYPE 收货人证件类型
		orderMain.setCsgIdcard("");// CSG_IDCARD 收货人证件号码
		orderMain.setCsgPostcode(deliveryPost);// CSG_POSTCODE 收货人邮政编码
		orderMain.setCsgAddress(contAddress);// CSG_ADDRESS 收货人详细地址
		orderMain.setCsgPhone1(deliveryMobile);// CSG_PHONE1 收货人电话一

		orderMain.setCsgPhone2(deliveryPhone);// CSG_PHONE2 收货人电话二
		orderMain.setExpDate("");// EXP_DATE 有效期
		orderMain.setForeAccdate("");// FORE_ACCDATE 最近一期账单日
		orderMain.setCardtypeId("");// CARDTYPE_ID 所属卡类型
		orderMain.setPdtNbr("");// PDT_NBR 卡类
		orderMain.setFormatId("");// FORMAT_ID 卡板
		if ("0".equals(ivrFlag)) {
			orderMain.setSourceId("01");// SOURCE_ID 订购渠道（下单渠道）
			orderMain.setSourceNm("CALL CENTER");// SOURCE_NM 渠道名称
		} else {
			orderMain.setSourceId("02");// SOURCE_ID 订购渠道（下单渠道）
			orderMain.setSourceNm("IVR");// SOURCE_NM 渠道名称
		}

		orderMain.setSource2Id("");// SOURCE2_ID 业务渠道代码
		orderMain.setSource2Nm("");// SOURCE2_NM 业务渠道名称
		int count = 0;
		for (String str : goodsNoArray) {
			count += Integer.valueOf(str);
		}
		orderMain.setTotalNum(count);// TOTAL_NUM 商品总数量
		orderMain.setTotalPrice(new BigDecimal(0));// TOTAL_PRICE 商品总价格
		long countBonus = 0;
		for (String str : intergralNoArray) {
			countBonus += Long.valueOf(str);
		}
		orderMain.setTotalBonus(countBonus);// TOTAL_BONUS 商品总积分数量
		orderMain.setTotalIncPrice(new BigDecimal(0));// TOTAL_INC_PRICE
		// 商品总手续费价格（无用）
		orderMain.setInvoice("");// INVOICE 发票抬头
		orderMain.setOrdermainDesc(ordermainDesc);// ORDERMAIN_DESC 订单主表备注
		orderMain.setStateCode("");// STATE_CODE 当前原因代码
		orderMain.setStateNm("");// STATE_NM 当前原因名称
		orderMain.setLockedFlag("0");// LOCKED_FLAG
		// 订单锁标记（锁住订单，订单成功后解锁，解锁才能退货）
		orderMain.setCurStatusId(Contants.SUB_ORDER_STATUS_0301);// CUR_STATUS_ID
		// 当前状态代码
		orderMain.setCurStatusNm(Contants.SUB_ORDER_WITHOUT_PAYMENT);// CUR_STATUS_NM
		// 当前状态名称
		orderMain.setCreateOper(createOper);// CREATE_OPER 创建操作员ID（渠道用户ID）
		orderMain.setModifyOper(createOper);// MODIFY_OPER 修改操作员ID
		Date d = DateTime.now().toDate();
		orderMain.setCreateTime(d);// CREATE_TIME 创建时间
		orderMain.setCommDate(DateHelper.getyyyyMMdd(d));// COMM_DATE 业务日期
		orderMain.setCommTime(DateHelper.getHHmmss(d));// COMM_TIME 业务时间
		orderMain.setModifyTime(d);// MODIFY_TIME 修改时间
		orderMain.setReserved1("");// RESERVED1 保留字段
		orderMain.setCustFlag("");// CUST_FLAG 客户标志
		orderMain.setVipFlag("");// VIP_FLAG VIP标志
		orderMain.setAcctAddFlag("0");// ACCT_ADD_FLAG 收货地址是否是帐单地址
		orderMain.setCustSex("");// CUST_SEX CUST_SEX
		orderMain.setPsFlag("");// PS_FLAG PS_FLAG
		orderMain.setCustEmail("");// CUST_EMAIL CUST_EMAIL
		orderMain.setCustBirthday("");// CUST_BIRTHDAY CUST_BIRTHDAY
		orderMain.setBpCustGrp("");// BP_CUST_GRP BP_CUST_GRP
		orderMain.setExpDate2("");// EXP_DATE_2 EXP_DATE_2
		orderMain.setVersionNum(0);// VERSION_NUM VERSION_NUM
		orderMain.setOrgCode("");//
		orderMain.setOrgNm("");//
		orderMain.setOrgLevel("");//
		orderMain.setCsgBorough("");//
		orderMain.setAcceptedNo(acceptedNo);//

		orderMain.setEUpdateStatus("0");// 更新状态
		orderMain.setIsmerge(isMerger);// 是否合并
		orderMain.setIntegraltypeId("");// 积分类型
		orderMain.setDefraytype("");// 消费类型
		orderMain.setMerId(merId);// 商户号

		orderMain.setErrorCode("");// 返回码
		orderMain.setCheckStatus("0");

		orderMain.setSerialNo(tradeSeqNo);// 流水号
		orderMain.setDesc1(desc1);// 备注1
		orderMain.setDesc2(desc2);// 备注2
		orderMain.setDesc3(desc3);// 备注1

		return orderMain;
	}

	/**
	 * 读取积分类型以积分类型Id为key，积分对象为Value，用于记录订单表时，保存积分类型中文名
	 *
	 */
	private void initIntegraltypeMap(Map<String, TblCfgIntegraltypeModel> integraltypeMap) {

		Map<String, Object> paramMap = Maps.newHashMap();
		paramMap.put("curStatus", 0);
		// 查询积分类型
		Response<List<TblCfgIntegraltypeModel>> integralResponse = cfgIntegraltypeService.findByParams(paramMap);
		if (!integralResponse.isSuccess() || integralResponse.getResult() == null) {
			return;
		}
		List<TblCfgIntegraltypeModel> list = integralResponse.getResult();
		if (list.size() > 0) {
			for (TblCfgIntegraltypeModel integraltype : list) {
				integraltypeMap.put(integraltype.getIntegraltypeId(), integraltype);
			}
		}
	}

	/**
	 * 组装网银支付报文，为了方便处理，将订单卡号映射表，在这里插入
	 *
	 * @param tradeSeqNo 交易流水号
	 * @param orderId 订单id
	 * @param merId 供应商
	 * @param isMerger 是否合并支付
	 * @param cardNoArray 卡号
	 * @param goodsPriceArray 价格
	 * @param intergralTypeArray 积分类型
	 * @param intergralNoArray 积分
	 * @param validDateArray 有效期
	 * @return 报文结果
	 */
	private CCPointsPay assNetBankPaymentDocument(String tradeSeqNo, String orderId, String merId, String isMerger,
			String[] cardNoArray, String[] goodsPriceArray, String[] intergralTypeArray, String[] intergralNoArray,
			String[] validDateArray, Date createDate, Map bigMachineMap) {

		CCPointsPay cCPointsPay = new CCPointsPay();

		String amtCard = "";// 支付卡号，每次交易只可以有一张卡用于现金支付
		String amount = "";// 支付金额，每次交易只可以有一张卡用于现金支付
		String validDate = "";// 支付卡有效期，每次交易只可以有一张卡用于现金支付
		List<String[]> bonusList = Lists.newArrayList();
		for (int index = 0; index < cardNoArray.length; index++) {
			String tempCardNo = cardNoArray[index].trim();
			String tempAmount = goodsPriceArray[index].trim();
			String tempValidDate = validDateArray[index].trim();
			String tempIntergralType = intergralTypeArray[index].trim();
			long tempIntergralNo = 0;
			String tempIntergralNoStr = intergralNoArray[index].trim();
			if (tempIntergralNoStr.length() > 0) {
				try {
					tempIntergralNo = Long.parseLong(tempIntergralNoStr);
				} catch (Exception e) {
					log.error("【MAL104】转换积分类型为Long类型时发生异常，转换数据：" + tempIntergralNoStr);
				}
			}

			try {
				if (tempAmount.length() == 12 && StringUtil.ccEnvelopeStringToDouble(tempAmount) > 0) {// 应用网关约定现金是不带小数点的12位字符串
					amount = StringUtil.ccEnvelopeStringToDouble(tempAmount) + "";
					amtCard = tempCardNo;
					validDate = tempValidDate;
				}
			} catch (Exception e) {
				e.printStackTrace();
				log.error("【MAL104】Exception", e);
			}
			if (tempIntergralNo > 0) {// 存在积分
				bonusList.add(new String[] { tempCardNo, tempIntergralType, tempIntergralNo + "", tempValidDate });
			}
		}

		cCPointsPay.setTradeChannel("EBS");// 3|交易渠道|Y
		cCPointsPay.setTradeCode("");
		cCPointsPay.setBizSight("00");// 2|业务场景|Y
		cCPointsPay.setSorceSenderNo(bigMachineMap.get("sorceSenderNo") + "");// 25|源发起方流水|Y
		cCPointsPay.setOperatorId("");// 12|操作员代码|N
		cCPointsPay.setTradeSource("#SC");// 3|交易来源|Y
		cCPointsPay.setTradeSeqNo(tradeSeqNo);// 20|交易流水号|Y
		cCPointsPay.setOrderId(orderId);// 30|订单号|Y
		cCPointsPay.setAccountNo(amtCard);// 20|卡号|N
		cCPointsPay.setAmount(amount.trim().equals("") ? "0" : amount);// 12|支付金额|##########.##|Y
		cCPointsPay.setCurType("CNY");// 3|交易币种|Y
		cCPointsPay.setCvv2("");// 5|CVV2|N
		cCPointsPay.setValidDate(validDate);// 10|有效期|YYMM|N
		cCPointsPay.setMerId(merId);// 20|商城商户号|Y
		cCPointsPay.setTradeStatus("0");// 1|交易状态|Y
		cCPointsPay.setIsMerger(isMerger);// 1|是否合并支付|Y
		cCPointsPay.setTradeDate(DateHelper.date2string(createDate, "yyyyMMdd"));
		cCPointsPay.setTradeTime(DateHelper.date2string(createDate, "HHmmss"));
		cCPointsPay.setRemark("");// 200|备注|N
		cCPointsPay.setChannelID("CCAG");// 4|最前端发起标识:如CCAG，网银，商城，短信，收单(原始发起方CCAG\MALL)|Y

		ItemGoodsDetailDto goodsInf;
		OrderVirtualModel tblOrderVirtual;
		Response<List<OrderSubModel>> orderSubResponse = orderService.findByOrderMainId(orderId);// 根据主订单号获取小订单信息
		List<OrderSubModel> oList = orderSubResponse.getResult();
		if (oList != null && oList.size() > 0) {
			for (OrderSubModel order : oList) {
				if (order != null) {
					List<String> itemIdList = Lists.newArrayList();
					itemIdList.add(order.getGoodsId());

					Response<List<ItemGoodsDetailDto>> itemResponse = itemService.findByIds(itemIdList);

					if (!itemResponse.isSuccess() || itemResponse.getResult() == null
							|| itemResponse.getResult().size() == 0) {
						log.error(itemResponse.getError());
					}

					goodsInf = itemResponse.getResult().get(0);
					if ("0001".equals(goodsInf.getGoodsType())) {// 虚拟礼品只存在一个大订单一个小订单
						Response<List<OrderVirtualModel>> virtualModelResponse = orderService
								.findVirtualByOrderId(order.getOrderId());
						if (!virtualModelResponse.isSuccess() || virtualModelResponse.getResult() == null
								|| virtualModelResponse.getResult().size() == 0) {
							log.error(itemResponse.getError());
						}

						tblOrderVirtual = virtualModelResponse.getResult().get(0);
						cCPointsPay.setTradeCode(tblOrderVirtual.getTradecode());// 2|交易类型|Y 红利卡兑换免签帐额8200 红利卡兑换免签帐额调整
						// 8100 积分换年费交易码为 年费调整3400
						cCPointsPay.setEntryCard(tblOrderVirtual.getEntryCard());// 2|兑换卡号|Y
						cCPointsPay.setVirtualPrice(String.valueOf(tblOrderVirtual.getVirtualAllPrice()));// 2|兑换金额|Y
						cCPointsPay.setTradeDesc(tblOrderVirtual.getTradedesc());// 2|交易描述|Y

					}
				}
			}
		}

		cCPointsPay.setFracCardCount(bonusList.size() + "");// 2|积分卡数量|Y
		List<CCPointsPayBaseInfo> cclist = Lists.newArrayList();
		for (String[] bonusArray : bonusList) {
			CCPointsPayBaseInfo cCPointsPayBaseInfo = new CCPointsPayBaseInfo();
			cCPointsPayBaseInfo.setFracCardNo(bonusArray[0]);// 20
			cCPointsPayBaseInfo.setFracAmount(bonusArray[2]);// 15
			cCPointsPayBaseInfo.setFracType(bonusArray[1]);// 3|积分类型
			cCPointsPayBaseInfo.setFracValidDate(bonusArray[3]);// 4|积分信用卡有效期|YYMM|N
			cclist.add(cCPointsPayBaseInfo);
		}
		cCPointsPay.setCcPointsPayBaseInfos(cclist);
		// cCPointsPay.setTerminalCode("02");// 终端编号 01-广发商城，02-积分商城（积分系统界面优化增加）

		return cCPointsPay;
	}

}