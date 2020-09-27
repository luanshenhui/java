package cn.com.cgbchina.restful.provider.service.payment;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.*;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.related.model.TblCfgProCodeModel;
import cn.com.cgbchina.related.model.TblParametersModel;
import cn.com.cgbchina.related.service.BusinessService;
import cn.com.cgbchina.related.service.CfgProCodeService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.payment.OrderIdAndOrderStauts;
import cn.com.cgbchina.rest.provider.model.payment.WXPay;
import cn.com.cgbchina.rest.provider.model.payment.WXPayReturn;
import cn.com.cgbchina.rest.provider.model.payment.WeChatVo;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.payment.WXPayReturnVO;
import cn.com.cgbchina.rest.provider.vo.payment.WXPayVO;
import cn.com.cgbchina.rest.visit.model.payment.*;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import cn.com.cgbchina.rest.visit.service.payment.StagingRequestService;
import cn.com.cgbchina.trade.model.*;
import cn.com.cgbchina.trade.service.*;
import cn.com.cgbchina.trade.vo.GateWayEnvolopeVo;
import cn.com.cgbchina.user.model.TblVendorRatioModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.UserInfoService;
import cn.com.cgbchina.user.service.VendorService;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * MAL503 微信发起支付接口
 * 
 * @author Lizy
 */
@Service
@TradeCode(value = "MAL503")
@Slf4j
public class WXPayProvideServiceImpl implements SoapProvideService<WXPayVO, WXPayReturnVO> {
	@Resource
	TblOrderMainService tblOrderMainService;
	@Resource
	OrderService orderService;
	@Resource
	OrderSendForO2OService orderSendForO2OService;
	@Resource
	PayService payService;
	@Resource
	CfgProCodeService cfgProCodeService;
	@Resource
	ItemService itemService;
	@Resource
	GoodsPayWayService goodsPayWayService;
	@Resource
	VendorService vendorService;
	@Resource
	UserInfoService userInfoService;
	@Resource
	GoodsService goodsService;
	@Resource
	StagingRequestService stagingRequestService;
	@Resource
	OrderOutSystemService orderOutSystemService;
	@Resource
	IdGenarator idGenarator;
	@Resource
	BusinessService businessService;
	@Resource
	PaymentService paymentService;

	@Value("#{app.merchId}")
	private String merchId;

	private long gwSeq = 1000;

	@Override
	public WXPayReturnVO process(SoapModel<WXPayVO> model, WXPayVO content) {
		WXPay wxPay = BeanUtils.copy(content, WXPay.class);
		WXPayReturn wxPayReturn = new WXPayReturn();
		// photoMallUtil = new PhotoMallUtil();
		/********* 支付起停控制begin *********/
		if (!this.isQT("YG", Contants.PARAMETERS_YG_05)) {
			return commonErrorMsg("000076", "该渠道不允许支付");
		}
		/********* 支付起停控制end *********/
		// Y必填 N可空
		WeChatVo weChatVo = new WeChatVo();// 报文内容vo
		weChatVo.setTradeChannel(StringUtils.dealNull(wxPay.getTradeChannel()));// Y 交易渠道 行内最前端系统
		weChatVo.setTradeSource(StringUtils.dealNull(wxPay.getTradeSource()));// Y 交易来源 行内最前端系统
		weChatVo.setBizSight(StringUtils.dealNull(wxPay.getBizSight()));// Y 业务场景 常规业务：00
		weChatVo.setSorceSenderNo(StringUtils.dealNull(wxPay.getSorceSenderNo()));// Y 源发起方流水
		weChatVo.setOperatorId(StringUtils.dealNull(wxPay.getOperatorId()));// N 源发起方流水
		log.debug("交易渠道:{},交易来源:{},业务场景:{},源发起方流水:{},源发起方流水:", weChatVo.getTradeChannel(), weChatVo.getTradeSource(),
				weChatVo.getBizSight(), weChatVo.getSorceSenderNo(), weChatVo.getOperatorId());
		weChatVo.setChannelSN(StringUtils.dealNull(wxPay.getChannelSN()));// Y 渠道
																			// 微信广发银行：WX；微信信用卡中心：WS；易信广发银行：YX；易信信用卡中心：YS
		weChatVo.setOrderMainId(StringUtils.dealNull(wxPay.getOrderMainId()));// Y 大订单号
		weChatVo.setCardNo(StringUtils.dealNull(wxPay.getCardNo()));// Y 卡号
		weChatVo.setValidDate(StringUtils.dealNull(wxPay.getValidDate()));// Y 卡有效期
		weChatVo.setOrdermainDesc(StringUtils.dealNull(wxPay.getOrdermainDesc()));// N 备注
		weChatVo.setIs_money(StringUtils.dealNull(wxPay.getIsMoney()));// Y 是否积分+现金支付 0:是 1:否
		weChatVo.setIs_merge(StringUtils.dealNull(wxPay.getIsMerge()));// Y 是否合并支付 0:合并 1:非合并（默认）

		log.debug("channelSN:{},orderMainId:{},validateDate:{},is_money:{},is_merge:", weChatVo.getChannelSN(),
				weChatVo.getOrderMainId(), weChatVo.getValidDate(), weChatVo.getIs_money(), weChatVo.getIs_merge());
		// WX 广发微信，WS广发信用卡微信
		if (Contants.CHANNEL_SN_WX.equals(weChatVo.getChannelSN())
				|| Contants.CHANNEL_SN_WS.equals(weChatVo.getChannelSN())) {
			try {
				Response<OrderMainModel> orderMainModelResponse = tblOrderMainService
						.findByOrderMainId(weChatVo.getOrderMainId());
				OrderMainModel orderMainModel = null;
				if (orderMainModelResponse.isSuccess()) {
					orderMainModel = orderMainModelResponse.getResult();
				}
				if (null == orderMainModel) {
					log.info("【MAL503】找不到订单:{}", weChatVo.getOrderMainId());
					return commonErrorMsg("000013", "找不到订单");
				}
				String source_id = orderMainModel.getSourceId();
				String ordertypeId = orderMainModel.getOrdertypeId();
				String channel_sn = "";
				// 05 广发银行（微信）
				if (Contants.SOURCE_ID_WECHAT.equalsIgnoreCase(source_id)) {
					channel_sn = Contants.CHANNEL_SN_WX;
				}
				// 06 广发信用卡（微信）
				else if (Contants.SOURCE_ID_WECHAT_A.equalsIgnoreCase(source_id)) {
					channel_sn = Contants.CHANNEL_SN_WS;
				}
				// 分期商城不需要需要判断渠道和卡号
				if ("JF".equals(ordertypeId) && (!channel_sn.equals(weChatVo.getChannelSN())
						|| !weChatVo.getCardNo().equals(orderMainModel.getCardno()))) {
					log.info("【MAL503】“请求渠道与订单渠道”或“卡号”不一致,channel_sn:{},channel:{},卡号相同：{}", channel_sn,
							weChatVo.getChannelSN(), (weChatVo.getCardNo().equals(orderMainModel.getCardno())));
					return commonErrorMsg("000013", "找不到订单");
				}
				// 订单当前状态
				String cur_status_id = orderMainModel.getCurStatusId();
				log.debug("订单当前状态:{}", cur_status_id);
				// 状态 非待支付0301，直接返回
				if (!Contants.SUB_ORDER_STATUS_0301.equals(cur_status_id)) {
					log.debug("【MAL503】支付成功/失败");
					if ("FQ".equals(ordertypeId)) {
						wxPayReturn.setReturnCode("000050");
						wxPayReturn.setReturnDes("支付结果已存在，不能进行重复支付");
					} else {
						wxPayReturn.setReturnCode("000000");
						wxPayReturn.setReturnDes("正常");
					}
					wxPayReturn.setOrderMainId(orderMainModel.getOrdermainId());
					wxPayReturn.setAmountMoney(String.valueOf(orderMainModel.getTotalPrice()));
					wxPayReturn.setAmountPoint(String.valueOf(orderMainModel.getTotalBonus()));
					wxPayReturn.setCurStatusId(orderMainModel.getCurStatusId());
					return BeanUtils.copy(wxPayReturn, WXPayReturnVO.class);
				}
				// 检查有没有小订单
				Response<List<OrderSubModel>> orderSubModelListResponse = orderService
						.findByOrderMainId(orderMainModel.getOrdermainId());
				List<OrderSubModel> orderSubModelList = null;
				if (orderSubModelListResponse.isSuccess()) {
					orderSubModelList = orderSubModelListResponse.getResult();
				}
				OrderSubModel order = null;
				if (null != orderSubModelList && orderSubModelList.size() > 0) {
					order = orderSubModelList.get(0);
				}
				if (null == order) {
					log.info("【MAL503】找不到小订单");
					return commonErrorMsg("000013", "找不到订单");
				}
				// 释放
				// if (!"FQ".equals(ordertypeId)) {
				// orderSubModelList = null;
				// }
				order = null;
				/********************** 广发微信商城需求改造begin ***********************/
				if ("JF".equals(ordertypeId)) {
					// 增加试运行判断 增加发起方流水 和 试运行标识
					dealJFOrder(orderMainModel, weChatVo.getValidDate(), wxPayReturn, wxPay.getSorceSenderNo());
				} else if ("FQ".equals(ordertypeId)) {
					// 增加发起方流水 和 试运行标识
					dealFQOrder(orderMainModel, orderSubModelList, wxPay.getSorceSenderNo(), weChatVo, wxPayReturn);
					// 业务与商城供应商平台对接 通过vendor_role = '3' 来判断是否为O2O商品,进行推送处理
					// 分期订单处理完成后，进行O2O的推送处理
					// dealO2OOrderService.dealO2OOrdersAfterPaySucc(StringUtils.dealNull(wxPay.getOrderMainId()));
					DealO2OOrderAfterPaySucc(orderSubModelList);
					// 检查有没有小订单
					// Response<List<OrderSubModel>> orderSubModelListResponse1=
					// orderService.findByOrderMainId(orderMainModel.getOrdermainId());
					// List<OrderSubModel> orderSubModelList1 = null;
					// if (orderSubModelListResponse1.isSuccess()) {
					// orderSubModelList1 = orderSubModelListResponse1.getResult();
					// }
					// if (orderSubModelList != null && orderSubModelList.size() > 0){
					// List<OrderIdAndOrderStauts> orders = Lists.newArrayList();
					// for(OrderSubModel orderSubModel : orderSubModelList) {
					// OrderIdAndOrderStauts ods = new OrderIdAndOrderStauts();
					// ods.setOrderStatusId(orderSubModel.getCurStatusId());
					// ods.setOrderId(orderSubModel.getOrderId());
					// orders.add(ods);
					// }
					// wxPayReturn.setOrders(orders);
					// }
				} else {// 如果查出的orderTypeId不是JF和FQ
					wxPayReturn.setReturnCode("000029");
					wxPayReturn.setReturnDes("订单类型错误");
				}
				String sourceid=null;
				if("WS".equals(wxPay.getChannelSN())){
					sourceid=Contants.CHANNEL_CREDIT_WX_CODE;
				}else if ("WX".equals(wxPay.getChannelSN())){
					sourceid=Contants.CHANNEL_MALL_WX_CODE;
				}
				orderDealService.createOrderSourceId(sourceid,orderMainModel.getOrdermainId());
				return BeanUtils.copy(wxPayReturn, WXPayReturnVO.class);
			} catch (Exception e) {
				log.error("【MAL503】微信下单错误");
				return commonErrorMsg("000009", "系统繁忙，请稍后再试");
			}
		} else {
			log.info("【MAL503】渠道：{}下单暂不支持", weChatVo.getChannelSN());
			return commonErrorMsg("000008", "报文参数错误");
		}
	}
	@Autowired
	private OrderDealService orderDealService;
	/**
	 * 支付成功后，进行O2O订单推送处理
	 *
	 * @param orderList
	 * @throws Exception
	 */
	private ExecutorService threadPool = Executors.newCachedThreadPool();

	private void DealO2OOrderAfterPaySucc(final List<OrderSubModel> orderList) throws Exception {
		log.debug("OrderDeal,完成支付后根据小订单列表进行O2O推送.....");
		try {
			threadPool.execute(new Runnable() {

				@Override
				public void run() {
					if (orderList == null || orderList.size() <= 0) {
						log.info("小订单列表为空不推送 ");
						return;
					}
					boolean isSendFlag = false;
					VendorInfoModel vendorMap = null;
					for (int i = 0; i < orderList.size(); i++) {
						OrderSubModel orderInfo = orderList.get(i);
						String orderMainId = orderInfo.getOrdermainId();
						log.info("大订单 {} 小订单：{} 订单状态：{}", orderMainId, orderInfo.getOrderId(),
								orderInfo.getCurStatusId());
						if (Contants.ORDER_STATUS_CODE_HAS_ORDERS.equals(orderInfo.getCurStatusId())) {
							if (vendorMap == null) {
								vendorMap = queryVendorInf(orderInfo.getVendorId());
							} else {
								if (!orderInfo.getVendorId().equals(vendorMap.getVendorId())) {
									vendorMap = queryVendorInf(orderInfo.getVendorId());
								}
							}
							if (vendorMap == null) {
								log.info("orderId={},合作商为空不推送", orderInfo.getOrderId());
								continue;
							}
							log.debug(" 合作商角色:{} 推送类型（00实时，01批量）:{}", vendorMap.getVendorRole(),
									vendorMap.getActionFlag());
							if ("3".equals(vendorMap.getVendorRole()) && "00".equals(vendorMap.getActionFlag())
									&& !isSendFlag && "02".equals(orderInfo.getGoodsType())) { // ACTION_FLAG=’00’表示实时推送
								log.debug("大订单 {} 实时推送O2O商品的订单 {}", orderMainId, orderInfo.getOrderId());
								orderSendForO2OService.orderSendForO2O(orderMainId, orderInfo.getOrderId());
							}
							if ("3".equals(vendorMap.getVendorRole()) && "01".equals(vendorMap.getActionFlag())
									&& "02".equals(orderInfo.getGoodsType())) {// ACTION_FLAG =’01’表示批量推送
								log.info("大订单 {} 批量推送O2O商品的订单 {}", orderMainId, orderInfo.getOrderId());
								// 这里没有进行任务是否存在的判断，因为支付一般都是第一次插入数据
								log.info("保存到推送队列订单信息：mainOrderId= {},suborderno:{}", orderMainId,
										orderInfo.getOrderId());
								OrderOutSystemModel orderOutSystemModel = new OrderOutSystemModel();
								orderOutSystemModel.setOrderId(orderInfo.getOrderId());
								orderOutSystemModel.setOrderMainId(orderMainId);
								orderOutSystemModel.setTimes(0);
								orderOutSystemModel.setTuisongFlag("0");
								orderOutSystemModel.setTuisongFlag("0");
								orderOutSystemModel.setSystemRole("00");// O2O
								orderOutSystemModel.setCreateOper("来自第三方");
								orderOutSystemService.insertOrderOutSystem(orderOutSystemModel);
							}
						} else {
							log.info("大订单: {} 小订单:{} 订单状态:{} 不推送", orderMainId, orderInfo.getOrderId(),
									orderInfo.getCurStatusId());
						}
					}
				}
			});
		} catch (Exception e) {
			log.error("推送异常:{}", e.getMessage());
		}
	}

	/**
	 * 查询供应商信息表
	 *
	 * @param vendorId
	 * @return
	 */
	private VendorInfoModel queryVendorInf(String vendorId) {
		Response<VendorInfoModel> vendorInfoModel = vendorService.findVendorById(vendorId);
		if (!vendorInfoModel.isSuccess()) {
			throw new RuntimeException(vendorInfoModel.getError());
		}
		return vendorInfoModel.getResult();
	}

	/**
	 * 积分订单发起支付 发起方流水sourceSenderSN
	 */
	private void dealJFOrder(OrderMainModel orderMainModel, String vaildDate, WXPayReturn envolopeVo,
			String sourceSenderSN) {
		Map<String, String> retMap = Maps.newHashMap(); // 电子支付返回码以及说明map
		String retCode = "";// 电子支付返回码
		String retErrMsg = ""; // 电子支付返回码说明，可空
		try {
			/*********************** 支付begin ***********************/
			// 发起源流水sourceSenderSN
			retMap = this.doPay(orderMainModel, vaildDate, sourceSenderSN);
			/*********************** 支付end *************************/
		} catch (Exception e) {
			log.error("【MAL503】调用电子支付接口异常，订单置为状态未明");
			retMap = Maps.newHashMap();
			retMap.put("retCode", "");// 状态未明；
			retMap.put("retErrMsg", "");
		}
		try {
			String payTimeStr = retMap.get("payTime");
			Date payTime = orderMainModel.getCreateTime(); //兼容旧版
			if (!Strings.isNullOrEmpty(payTimeStr)){ //新版支付时间
				payTime = DateHelper.string2Date(payTimeStr,DateHelper.YYYYMMDDHHMMSS);
			}
			// 更新支付状态、是否需要回滚库存需要做事务控制
			if (retMap != null && !retMap.isEmpty()) {
				retCode = retMap.get("retCode");
				retErrMsg = retMap.get("retErrMsg");
				this.updateVirtualOrders(orderMainModel, "微信支付", retCode,payTime);
			}
		} catch (Exception e) {
			log.error("【MAL503】保存订单出错:{}", orderMainModel.getOrdermainId());
		}
		// 根据返回结果判断得出订单状态
		String curStatusId = "";
		if ("000000".equals(retCode)) {// 支付成功
			curStatusId = Contants.SUB_ORDER_STATUS_0308;
		} else if (PayReturnCode.isStateNoSure(retCode) || retCode == null || "".equals(retCode)) {// 如果支付时状态未明
			// 电子支付返回“EBLN2000”，小订单状态需要置为“状态未明”
			curStatusId = Contants.SUB_ORDER_STATUS_0316;
		} else {// 支付失败
			curStatusId = Contants.SUB_ORDER_STATUS_0307;
		}
		// 组装报文返回
		if ("".equals(retCode))
			retCode = "000000";// 如果支付或者更新数据出现异常默认返回000000，以保证非空
		envolopeVo.setReturnCode(retCode);
		if ((null == retErrMsg || "".equals(retErrMsg)) && !"000000".equals(retCode)) {
			// retErrMsg = ReturnCodeProperties.getProperties(retCode);
			retErrMsg = "微信发起支付失败";
		}
		envolopeVo.setReturnDes(retErrMsg);
		// Response<OrderMainModel> orderMainModelResponse =
		// tblOrderMainService.findByOrderMainId(orderMainModel.getOrdermainId());
		// OrderMainModel retMain = null;
		// if (orderMainModelResponse.isSuccess()) {
		// retMain = orderMainModelResponse.getResult();
		// }
		envolopeVo.setOrderMainId(orderMainModel.getOrdermainId());
		envolopeVo.setAmountMoney(orderMainModel.getTotalPrice().toString());
		envolopeVo.setAmountPoint(orderMainModel.getTotalBonus().toString());
		envolopeVo.setCurStatusId(curStatusId);
	}

	/**
	 * 分期订单发起支付
	 */
	private WXPayReturn dealFQOrder(OrderMainModel orderMainModel, List<OrderSubModel> orderList, String senderSN,
			WeChatVo weChatVo, WXPayReturn envolopeVo) {
		try {
			Date tradeDate = new Date();
			OrderSubModel orderSubModel = orderList.get(0);
			if (null == orderSubModel) {
				log.info("【MAL503】找不到小订单");
				envolopeVo.setReturnCode("000013");
				envolopeVo.setReturnDes("找不到订单");
				return envolopeVo;
			}

			// 微信继续支付，如果是其他渠道下单的订单，渠道更改为微信渠道、创建时间更改为支付支付时间 start
			if (orderList.size() == 1 && !"50".equals(orderSubModel.getActType())) {// 荷兰式订单不修改
				String sourceId = "";
				String sourceName = "";
				if (Contants.CHANNEL_SN_WX.equals(weChatVo.getChannelSN())
						&& !Contants.SOURCE_ID_WECHAT.equals(orderSubModel.getSourceId())) {
					// 渠道不同，修改渠道和创建时间
					log.info("【MAL503】流水：{}:微信继续支付,订单渠道={}修改订单渠道为微信", senderSN, orderSubModel.getSourceId(),
							Contants.SOURCE_ID_WECHAT);
					sourceId = Contants.SOURCE_ID_WECHAT;
				} else if (Contants.CHANNEL_SN_WS.equals(weChatVo.getChannelSN())
						&& !Contants.SOURCE_ID_WECHAT_A.equals(orderSubModel.getSourceId())) {
					// 渠道不同，修改渠道和创建时间
					log.info("【MAL503】流水：{}:微信继续支付，订单渠道={}修改订单渠道为微信", senderSN, orderSubModel.getSourceId(),
							Contants.SOURCE_ID_WECHAT_A);
					sourceId = Contants.SOURCE_ID_WECHAT_A;
				} else if (!DateHelper.getyyyyMMdd()
						.equals(DateHelper.date2string(orderSubModel.getCreateTime(), DateHelper.YYYYMMDD))) {
					// 渠道相同，订单创建时间和支付时间不是同一天，修改创建时间
					log.info("【MAL503】流水：{}:支付渠道相同，订单创建时间和支付时间不是同一天，修改创建时间", senderSN);
					sourceId = orderSubModel.getSourceId();
					sourceName = orderSubModel.getSourceNm();
				}
				if (!StringUtils.isEmpty(sourceId)) {
					try {
						// if (SourceUtil.sourceYG == null) {
						// conn = SpringUtil.getConnect();
						// SourceUtil.InitYGSourceName(conn);
						// }
						// if (Tools.isEmpty(sourceName)) {
						// sourceName = SourceUtil.GetSourceName(sourceId, "YG");
						// }
						Map<String, Object> sourceQueryMap = Maps.newHashMap();// 查询参数
						sourceQueryMap.put("ordertype_id", "YG");// 业务类型
						sourceQueryMap.put("proType", "QD");// 参数类型
						sourceQueryMap.put("proCode", sourceId);

						// 查询订单渠道
						Response<List<TblCfgProCodeModel>> sourceResponse = cfgProCodeService
								.findProCodeByParams(sourceQueryMap);
						List<TblCfgProCodeModel> sourceList = null;
						if (sourceResponse.isSuccess()) {
							sourceList = sourceResponse.getResult();
						}
						if (sourceList != null && sourceList.size() != 0) {
							sourceName = sourceList.get(0).getProNm();// 取得渠道名称
						}
						// bug-305197 fixed by ldk
						payService.updateWXOrderSourcewithTX(orderSubModel.getOrdermainId(), orderSubModel.getOrderId(),
								sourceId, sourceName, tradeDate);
						orderMainModel.setCreateTime(tradeDate);
						orderSubModel.setCreateTime(tradeDate);
					} catch (Exception e) {
						log.error("【MAL503】流水：{}, 出错：{}", senderSN, e);
						envolopeVo.setReturnCode("000009");
						envolopeVo.setReturnDes("系统异常");
						return envolopeVo;
					}
				}
			}
			// 微信继续支付，如果是其他渠道下单的订单，渠道更改为微信渠道、创建时间更改为支付支付时间 end

			String orderTypeId = "FQ";
			String orderMainId = orderMainModel.getOrdermainId();// 大订单号
			// 这个List可能放Map，可能放Model
			List ordersTemp = Lists.newArrayList();// 临时的一个子订单集合
			List<Map<String, String>> successList = Lists.newArrayList();// 优惠券、积分支付成功的List
			List<Map<String, String>> failueList = Lists.newArrayList();// 优惠券、积分支付失败的List

			String cardType = getCardType(weChatVo.getCardNo());
			boolean isNoSure = false;

			boolean isPrivilege = isPrivilege(orderList);// 使用优惠券或积分
			log.debug("【MAL503】流水：{} 是否使用优惠券或积分：{}", senderSN, isPrivilege);
			// 有积分或者优惠券时才去申请电子支付接口
			String payTime = null;// 电子支付返回时间
			if (isPrivilege) {
				String tradeSeqNo = idGenarator.orderSerialNo();
				String orders = "";
				// List list = tblOrderDao.getTblOrderList(orderId);
				for (int i = 0; i < orderList.size(); i++) {
					OrderSubModel order = orderList.get(i);
					BigDecimal uitdrtamt = order.getUitdrtamt() == null ? BigDecimal.ZERO : order.getUitdrtamt();
					if (i == 0) {// 第一个小订单
						orders = order.getOrderIdHost() + "|" + order.getMerId() + "|" + order.getOrderId() + "|"
								+ order.getTotalMoney() + "|" + order.getVoucherNo() + "|" + order.getIntegraltypeId()
								+ "|" + order.getBonusTotalvalue() + "|" + uitdrtamt;
					} else {
						orders = orders + "|" + order.getOrderIdHost() + "|" + order.getMerId() + "|"
								+ order.getOrderId() + "|" + order.getTotalMoney() + "|" + order.getVoucherNo() + "|"
								+ order.getIntegraltypeId() + "|" + order.getBonusTotalvalue() + "|" + uitdrtamt;
					}
				}

				ChannelPayInfo channelPayInfo = new ChannelPayInfo();
				channelPayInfo.setTradeSeqNo(orderMainModel.getSerialNo());
				channelPayInfo.setMerId(orderMainModel.getMerId());
				channelPayInfo.setOrderId(orderMainModel.getOrdermainId());
				channelPayInfo.setAccountNo(orderMainModel.getCardno());
				channelPayInfo.setCertType(orderMainModel.getContIdType());
				channelPayInfo.setCertNo(orderMainModel.getContIdcard());
				channelPayInfo.setCurType("CNY");
				channelPayInfo.setCvv2("");
				if ("0".equals(weChatVo.getValidDate())) {
					channelPayInfo.setValidDate("0000");// validDate 微信默认送0
				} else {
					channelPayInfo.setValidDate(weChatVo.getValidDate());// validDate
				}
				channelPayInfo.setIsMerger("0");
				channelPayInfo.setChannelID(Contants.CHANNEL_SN_WX);
				channelPayInfo.setTradeDate(DateHelper.date2string(orderMainModel.getCreateTime(), "yyyyMMdd"));
				channelPayInfo.setTradeTime(DateHelper.date2string(orderMainModel.getCreateTime(), "HHmmss"));
				channelPayInfo.setOrders(orders);
				channelPayInfo.setRemark("");
				channelPayInfo.setTerminalCode(Contants.TERMINAL_CODE_YG);// 终端编号 01-广发商城，02-积分商城（积分系统界面优化增加）
				String retCode = "";
				String retOrders = "";
				try {
					ChannelPayResult channelPayResult = paymentService.channelPay(channelPayInfo);
					retCode = channelPayResult.getRetCode();
					retOrders = channelPayResult.getOrders();
					payTime = channelPayResult.getPayTime();
					if(Strings.isNullOrEmpty(payTime)){//xiewl 20161217
						//channelPayInfo的tradedate
						payTime = channelPayInfo.getTradeDate()+channelPayInfo.getTradeTime();
					}
					log.info("【MAL115】流水：" + senderSN + "，发送支付请求到电子支付");
					log.info("【MAL115】流水：" + senderSN + "电子支付返回结果：" + retCode + "具体小订单结果：" + retOrders);
					if (!"000000".equals(retCode)) {// 如果电子支付返回的不是000000，则所有小订单均是支付失败或者状态未明
						log.debug("所有小订单均支付失败或者状态未明！");
						for (int j = 0; j < orderList.size(); j++) {
							OrderSubModel order = orderList.get(j);
							Map<String, String> om = Maps.newHashMap();
							om.put("orderId", order.getOrderId());
							om.put("payTime", payTime);
							om.put("ERRCODE", retCode);
							failueList.add(om);
						}
					} else {
						log.info("大订单号[" + orderMainModel.getOrdermainId() + "]电子支付返回时间：{}", payTime);
						List<Map<String, String>> rList = paraOrders(retOrders);
						for (int i = 0; i < rList.size(); i++) {
							Map<String, String> rMap = rList.get(i);
							if ("01".equals(rMap.get("result"))) {// 优惠券支付成功
								successList.add(rMap);
							} else {
								failueList.add(rMap);
								log.info("【MAL503】流水：{}去电子支付积分、优惠券支付失败的订单：{}", senderSN, rMap.get("orderId"));
							}
						}
						if (successList != null && successList.size() > 0) {
							ordersTemp = successList;
						}
					}

				} catch (Exception e) {
					log.error("处理电子支付支付积分、优惠券信息异常");
					for (int i = 0; i < orderList.size(); i++) {// 电子支付返回异常时将所有的订单置为支付失败
						OrderSubModel excepOrder = orderList.get(i);
						Map<String, String> excepMap = Maps.newHashMap();
						excepMap.put("orderId", excepOrder.getOrderId());
						failueList.add(excepMap);
					}
				}
				if (failueList != null && failueList.size() > 0) {// 支付失败、异常的订单直接置为支付失败,状态未明订单直接置为状态未明
					if (PayReturnCode.isStateNoSure(retCode)) {// 支付返回状态未明,小订单状态置为“状态未明”
						isNoSure = true;
						payService.dealNoSureOrderswithTX(failueList, weChatVo.getCardNo(), cardType, retCode,
								"微信广发分期支付");
					} else {
						payService.dealWXFailOrderswithTX(failueList, orderMainId, weChatVo.getCardNo());
					}
				}
			} else {// 纯现金支付不需要调电子支付接口
				ordersTemp = orderList;
			}

			// 调BPS分期接口
			/******************************* 调BPS分期接口start *************************************/
			List<Map<String, Object>> tempList = Lists.newArrayList();
			// 调BPS分期接口条件：1.使用优惠券或者积分调电子支付接口返回成功、2.纯现金支付没有调电子支付接口
			if (ordersTemp != null && ordersTemp.size() > 0) {
				log.info("子订单数目：{}", ordersTemp.size());
				for (int i = 0; i < ordersTemp.size(); i++) {
					String order_id = "";
					OrderSubModel tblOrder = null;
					if (isPrivilege) {
						Map<String, String> tblOrderMap = (Map) ordersTemp.get(i);
						order_id = StringUtils.dealNull(tblOrderMap.get("orderId"));
						Response<OrderSubModel> orderSubModelResponse = orderService.selectOrderSub(order_id);
						if (orderSubModelResponse.isSuccess() && orderSubModelResponse.getResult() != null) {
							tblOrder = orderSubModelResponse.getResult();
						}
					} else {
						tblOrder = (OrderSubModel) ordersTemp.get(i);
						order_id = tblOrder.getOrderId();
					}
					log.debug("【MAL503】流水：{}调用之前状态:{}", senderSN, tblOrder.getCurStatusId());
					String goods_id = tblOrder.getGoodsId();

					if (tblOrder.getBonusTotalvalue() != null && tblOrder.getBonusTotalvalue() != 0) {
						if (Strings.isNullOrEmpty(payTime)) {
							log.warn("子订单[" + orderSubModel.getOrderId() + "]支付成功且使用积分，但电子支付返回支付时间为：{}", payTime);
							tblOrder.setOrder_succ_time(tblOrder.getCreateTime());
							tblOrder.setOrder_succ_timeStr(DateHelper.date2string(tblOrder.getCreateTime(),DateHelper.YYYYMMDDHHMMSS));
						} else {
							// 设置order_succ_time
							tblOrder.setOrder_succ_time(DateHelper.string2Date(payTime, DateHelper.YYYYMMDDHHMMSS));
							tblOrder.setOrder_succ_timeStr(DateHelper.date2string(tblOrder.getOrder_succ_time(),DateHelper.YYYY_MM_DD_HH_MM_SS));
						}
					}

					String bpserrorCode = null;
					String bpsapproveResult = null;
					String extend1 = null;// 是否有发送过给bps 0或空:没有 1:有
					Map<String, Object> _map = Maps.newHashMap();
					_map.put("error_code", "");
					_map.put("tblOrder", tblOrder);
					_map.put("cardNo", weChatVo.getCardNo());// cardNo
					_map.put("cardType", cardType);// 卡类型
					Response<TblOrderExtend1Model> orderExtend1ModelResponse = orderService.selectOrderExtend(order_id);
					TblOrderExtend1Model tblOrderExtend1 = null;
					if (orderExtend1ModelResponse.isSuccess()) {
						tblOrderExtend1 = orderExtend1ModelResponse.getResult();
					}
					_map.put("tblOrderExtend1", tblOrderExtend1);
					try {
						if ("FQ".equals(orderTypeId)) {// 分期订单申请bps接口调用
							if (tblOrderExtend1 != null) {// 如果扩展表中存在该订单数据
								bpserrorCode = tblOrderExtend1.getErrorcode();// bps错误码
								extend1 = tblOrderExtend1.getExtend1();// 是否发送过给bps标识
							}
							if ("1".equals(extend1)) {// 并且该条订单发送过给bps
								log.info("【MAL503】流水：{}:不用调用bps接口" + "，订单号：{}", senderSN, order_id);
								envolopeVo.setReturnCode("000050");
								envolopeVo.setReturnDes("支付结果已存在，不能进行重复支付");
								return envolopeVo;
							} else {
								/** 如果现金部分为0，并且是走新流程，则不调用BPS的接口，直接处理为支付成功 --大机补充需求 mod by dengbing start */
								BigDecimal comResult = tblOrder.getTotalMoney() == null ? new BigDecimal("0") : tblOrder.getTotalMoney();
								if (BigDecimal.ZERO.compareTo(comResult) == 0) {// 如果现金部分为0，并且是走新流程
									TblOrderExtend1Model tempTblOrderExtend1 = new TblOrderExtend1Model();
									tempTblOrderExtend1.setOrderId(tblOrder.getOrderId());
									tempTblOrderExtend1.setExtend1("1");
									tempTblOrderExtend1.setExtend2(DateHelper.getCurrentTime());// 向bps发起ops分期申请的请求时间
									orderService.insertOrderExtend(tempTblOrderExtend1);
									_map.put("tblOrderExtend1", tempTblOrderExtend1);
									GateWayEnvolopeVo returnGateWayEnvolopeVo = returnBPSVO();
									_map.put("returnGateWayEnvolopeVo", returnGateWayEnvolopeVo);
									/** 如果现金部分为0，并且是走新流程，则不调用BPS的接口，直接处理为支付成功 --大机补充需求 mod by dengbing end */
								} else {// 如果现金部分不为0或者走旧流程 ，调用BPS的接口
									log.info("【MAL503】流水：{}:分期订单调用bps接口" + "，订单号：{}", senderSN, order_id);
									Response<ItemModel> itemModelResponse = itemService.findByItemcode(goods_id);
									ItemModel itemModel = null;
									if (itemModelResponse.isSuccess()) {
										itemModel = itemModelResponse.getResult();
									}
									Response<GoodsModel> goodsModelResponse = goodsService
											.findById(itemModel.getGoodsCode());
									GoodsModel goodsModel = null;
									if (goodsModelResponse.isSuccess()) {
										goodsModel = goodsModelResponse.getResult();
									}

									Response<TblGoodsPaywayModel> tblGoodsPaywayModelResponse = goodsPayWayService
											.findGoodsPayWayInfo(tblOrder.getGoodsPaywayId());
									TblGoodsPaywayModel tblGoodsPaywayModel = null;
									if (tblGoodsPaywayModelResponse.isSuccess()) {
										tblGoodsPaywayModel = tblGoodsPaywayModelResponse.getResult();
									}
									GateWayEnvolopeVo sendGateWayEnvolopeVo = new GateWayEnvolopeVo();
									sendGateWayEnvolopeVo.setMessageEntityValue("SRCCASEID", order_id);
									sendGateWayEnvolopeVo.setMessageEntityValue("INTERFACETYPE", "0");
									sendGateWayEnvolopeVo.setMessageEntityValue("CARDNBR", weChatVo.getCardNo());// cardNo
									sendGateWayEnvolopeVo.setMessageEntityValue("IDNBR",
											orderMainModel.getContIdcard());
									sendGateWayEnvolopeVo.setMessageEntityValue("CHANNEL", "070");
									sendGateWayEnvolopeVo.setMessageEntityValue("PROJECT", "");
									sendGateWayEnvolopeVo.setMessageEntityValue("REQUESTTYPE", "2");
									sendGateWayEnvolopeVo.setMessageEntityValue("CASETYPE", "0500");
									sendGateWayEnvolopeVo.setMessageEntityValue("SUBCASETYPE", "0501");
									String createOper = "";
									if (StringUtils.isEmpty(orderMainModel.getCreateOper())) {
										createOper = orderMainModel.getContIdcard();
									} else {
										createOper = orderMainModel.getCreateOper();
									}
									sendGateWayEnvolopeVo.setMessageEntityValue("CREATOR", createOper);

									sendGateWayEnvolopeVo.setMessageEntityValue("BOOKDESC",
											orderMainModel.getCsgPhone1());
									sendGateWayEnvolopeVo.setMessageEntityValue("RECEIVEMODE", "02");
									sendGateWayEnvolopeVo.setMessageEntityValue("ADDR",
											orderMainModel.getCsgProvince() + orderMainModel.getCsgCity()
													+ orderMainModel.getCsgBorough() + orderMainModel.getCsgAddress());// 省+市+区+详细地址
									sendGateWayEnvolopeVo.setMessageEntityValue("POSTCODE",
											orderMainModel.getCsgPostcode());
									sendGateWayEnvolopeVo.setMessageEntityValue("DRAWER", orderMainModel.getInvoice());
									sendGateWayEnvolopeVo.setMessageEntityValue("SENDCODE", "D");

									sendGateWayEnvolopeVo.setMessageEntityValue("REGULATOR", "1");
									sendGateWayEnvolopeVo.setMessageEntityValue("SMSNOTICE", "1");
									sendGateWayEnvolopeVo.setMessageEntityValue("SMSPHONE", "");
									sendGateWayEnvolopeVo.setMessageEntityValue("CONTACTNBR1",
											orderMainModel.getCsgPhone1());
									sendGateWayEnvolopeVo.setMessageEntityValue("CONTACTNBR2",
											orderMainModel.getCsgPhone2());
									sendGateWayEnvolopeVo.setMessageEntityValue("SBOOKID",
											orderMainModel.getOrdermainId());
									sendGateWayEnvolopeVo.setMessageEntityValue("BBOOKID", "");
									sendGateWayEnvolopeVo.setMessageEntityValue("RESERVATION", "0");
									sendGateWayEnvolopeVo.setMessageEntityValue("RESERVETIME", "");
									sendGateWayEnvolopeVo.setMessageEntityValue("CERTTYPE",
											CardUtil.getbpsFromPerBankCardType(orderMainModel.getContIdType()));
									sendGateWayEnvolopeVo.setMessageEntityValue("URGENTLVL", "0200");
									sendGateWayEnvolopeVo.setMessageEntityValue("MICHELLEID", "");
									sendGateWayEnvolopeVo.setMessageEntityValue("OLDBANKID", "");
									sendGateWayEnvolopeVo.setMessageEntityValue("PRODUCTCODE", itemModel.getMid());// 分期编码
									sendGateWayEnvolopeVo.setMessageEntityValue("PRODUCTNAME", tblOrder.getGoodsNm());
									sendGateWayEnvolopeVo.setMessageEntityValue("PRICE", tblGoodsPaywayModel != null
											? tblGoodsPaywayModel.getGoodsPrice().toString() : "0");// 商品总价
									sendGateWayEnvolopeVo.setMessageEntityValue("COLOR", tblOrder.getGoodsColor());
									sendGateWayEnvolopeVo.setMessageEntityValue("AMOUNT", "1");
									sendGateWayEnvolopeVo.setMessageEntityValue("SUMAMT",
											tblOrder.getTotalMoney() != null ? tblOrder.getTotalMoney().toString()
													: "0");
									sendGateWayEnvolopeVo.setMessageEntityValue("SUBORDERID", tblOrder.getOrderId());
									sendGateWayEnvolopeVo.setMessageEntityValue("FIRSTPAYMENT", "0");
									sendGateWayEnvolopeVo.setMessageEntityValue("BILLS",
											tblOrder.getStagesNum() != null ? tblOrder.getStagesNum().toString() : "0");
									sendGateWayEnvolopeVo.setMessageEntityValue("PERPERIODAMT",
											tblOrder.getIncTakePrice() != null ? tblOrder.getIncTakePrice().toString()
													: "0");// 检查
									sendGateWayEnvolopeVo.setMessageEntityValue("SUPPLIERCODE", tblOrder.getVendorId());
									Response<TblVendorRatioModel> vendorRatioModelResponse = vendorService
											.findRatioByVendorId(tblOrder.getVendorId(), tblOrder.getStagesNum());
									TblVendorRatioModel tblVendorRatioModel = null;
									if (vendorRatioModelResponse.isSuccess()) {
										tblVendorRatioModel = vendorRatioModelResponse.getResult();
									}
									Response<VendorInfoModel> vendorInfoModelResponse = vendorService
											.findVendorById(tblOrder.getVendorId());
									VendorInfoModel vendorInfoModel = null;
									if (vendorInfoModelResponse.isSuccess()) {
										vendorInfoModel = vendorInfoModelResponse.getResult();
									}
									vendorRatioMessage(sendGateWayEnvolopeVo, tblVendorRatioModel, vendorInfoModel,
											String.valueOf(tblOrder.getTotalMoney()));
									sendGateWayEnvolopeVo.setMessageEntityValue("SUPPLIERDESC", "");
									sendGateWayEnvolopeVo.setMessageEntityValue("RECOMMENDCARDNBR", "");
									sendGateWayEnvolopeVo.setMessageEntityValue("RECOMMENDNAME", "");
									sendGateWayEnvolopeVo.setMessageEntityValue("RECOMMENDCERTTYPE", "");
									sendGateWayEnvolopeVo.setMessageEntityValue("RECOMMENDID", "");
									sendGateWayEnvolopeVo.setMessageEntityValue("PREVCASEID", "");
									sendGateWayEnvolopeVo.setMessageEntityValue("CUSTNAME", orderMainModel.getContNm());
									sendGateWayEnvolopeVo.setMessageEntityValue("INCOMINGTEL", "");
									sendGateWayEnvolopeVo.setMessageEntityValue("PRESENTNAME",
											goodsModel != null ? goodsModel.getGiftDesc() : "");
									sendGateWayEnvolopeVo.setMessageEntityValue("ORDERMEMO", "正常订单");
									sendGateWayEnvolopeVo.setMessageEntityValue("FORCETRANSFER", "");
									sendGateWayEnvolopeVo.setMessageEntityValue("SUPPLIERNAME",
											tblOrder.getVendorSnm());
									sendGateWayEnvolopeVo.setMessageEntityValue("MEMO", "");
									sendGateWayEnvolopeVo.setMessageEntityValue("RECEIVENAME",
											orderMainModel.getCsgName());
									sendGateWayEnvolopeVo.setMessageEntityValue("MERCHANTCODE", "");// 特店号暂时约定传空

									/****************** 使用优惠券或积分情况start *************************/
									String ACCEPTAMT = tblOrder.getTotalMoney().toString();// 申请分期金额(抵扣后的产品金额)
									sendGateWayEnvolopeVo.setMessageEntityValue("ACCEPTAMT",
											ACCEPTAMT != "" ? ACCEPTAMT : "0");
									String FAVORABLETYPE = "";// 优惠类型
									String DEDUCTAMT = "0";// 抵扣金额
									if (tblOrder.getVoucherNo() != null && !"".equals(tblOrder.getVoucherNo())) {
										FAVORABLETYPE = "01";
										DEDUCTAMT = tblOrder.getVoucherPrice().toString();
									}
									if (tblOrder.getBonusTotalvalue() != null
											&& tblOrder.getBonusTotalvalue().longValue() != 0) {
										FAVORABLETYPE = "02";
										DEDUCTAMT = tblOrder.getUitdrtamt().toString();
									}
									if ((tblOrder.getVoucherNo() != null && !"".equals(tblOrder.getVoucherNo()))
											&& (tblOrder.getBonusTotalvalue() != null
													&& tblOrder.getBonusTotalvalue().longValue() != 0)) {
										FAVORABLETYPE = "03";
										// 金额的计算需要转化成BigDecimal计算
										DEDUCTAMT = this.dataAdd(String.valueOf(tblOrder.getVoucherPrice()),
												String.valueOf(tblOrder.getUitdrtamt()));
									}
									if ((tblOrder.getVoucherNo() == null || "".equals(tblOrder.getVoucherNo()))
											&& (tblOrder.getBonusTotalvalue() == null
													|| tblOrder.getBonusTotalvalue().longValue() == 0)) {
										FAVORABLETYPE = "00";
									}
									sendGateWayEnvolopeVo.setMessageEntityValue("FAVORABLETYPE", FAVORABLETYPE);// 优惠类型
									sendGateWayEnvolopeVo.setMessageEntityValue("DEDUCTAMT", DEDUCTAMT);// 抵扣金额
									sendGateWayEnvolopeVo.setReceiverIdFlag("");// 方在VO中，以便后续判断接收方标识
									/****************** 使用优惠券或积分情况end *************************/
									TblOrderExtend1Model tempTblOrderExtend1 = new TblOrderExtend1Model();
									tempTblOrderExtend1.setOrderId(tblOrder.getOrderId());
									tempTblOrderExtend1.setExtend1("1");
									tempTblOrderExtend1.setExtend2(DateHelper.getCurrentTime());// 向bps发起ops分期申请的请求时间
									orderService.insertOrderExtend(tempTblOrderExtend1);
									_map.put("tblOrderExtend1", tempTblOrderExtend1);
									// GateWayEnvolopeVo returnGateWayEnvolopeVo = (GateWayEnvolopeVo)
									// nTBP0005.sendEnvolope(sendGateWayEnvolopeVo);
									StagingRequest req = vo2req(sendGateWayEnvolopeVo);
									StagingRequestResult returnREQ = stagingRequestService.getStagingRequest(req);
									GateWayEnvolopeVo returnGateWayEnvolopeVo = sendGateWayEnvolopeVo;
									returnGateWayEnvolopeVo.setMessageEntityValue("ERRORCODE",
											returnREQ.getErrorCode());// Bps返回的错误码
									returnGateWayEnvolopeVo.setMessageEntityValue("APPROVERESULT",
											returnREQ.getApproveResult());// Bps返回的返回码0000-全额 0010-逐期 0100-拒绝 0200-转人工
																			// 0210-异常转人工
									returnGateWayEnvolopeVo.setMessageEntityValue("FOLLOWDIR",
											returnREQ.getFollowDir());// 后续流转方向0-不流转 1-流转
									returnGateWayEnvolopeVo.setMessageEntityValue("CASEID", returnREQ.getCaseId());// BPS工单号
									returnGateWayEnvolopeVo.setMessageEntityValue("SPECIALCUST",
											returnREQ.getSpecialCust());// 是否黑灰名单 0-黑名单 1-灰名单 2-其他
									returnGateWayEnvolopeVo.setMessageEntityValue("RELEASETYPE",
											returnREQ.getReleaseType());// 释放类型
									returnGateWayEnvolopeVo.setMessageEntityValue("REJECTCODE",
											returnREQ.getRejectcode());// 拒绝代码
									returnGateWayEnvolopeVo.setMessageEntityValue("APRTCODE", returnREQ.getAprtcode());// 逐期代码
									returnGateWayEnvolopeVo.setMessageEntityValue("ORDERNBR", returnREQ.getOrdernbr());// 核心订单号、银行订单号:
																														// 默认11个0
									if (returnGateWayEnvolopeVo != null) {
										bpserrorCode = returnGateWayEnvolopeVo.getMessageEntityValue("ERRORCODE");// BPS错误码
										log.info("【MAL503】流水：{}BPS错误码:{}", senderSN, bpserrorCode);
										bpsapproveResult = returnGateWayEnvolopeVo
												.getMessageEntityValue("APPROVERESULT");// BPS返回码
										log.info("【MAL503】流水：{}:BPS返回码:{}", senderSN, bpsapproveResult);
									}
									_map.put("returnGateWayEnvolopeVo", returnGateWayEnvolopeVo);
								}
							}
						}
					} catch (Exception e) {
						log.error("调用ops分期申请接口失败! {}", Throwables.getStackTraceAsString(e));
					}
					tempList.add(_map);// 调用Dao传参数
				}
			}
			/******************************* 调BPS分期接口end *************************************/
			// 更新订单状态
			if (orderTypeId != null && "FQ".equals(orderTypeId.trim())) {// 分期
				log.info("【MAL503】流水：{}, orderTypeId is FQ, tempList大小为：{}", senderSN, tempList.size());
				dealWXFQorderBpswithTX(orderMainId, tempList, weChatVo.getCardNo());
			}

			// 组装返回报文
			envolopeVo.setReturnCode("000000");// 返回码
			envolopeVo.setReturnDes("");// 描述
			Response<OrderMainModel> orderMainModelResponse = tblOrderMainService
					.findByOrderMainId(orderMainModel.getOrdermainId());
			OrderMainModel retMain = null;
			if (orderMainModelResponse.isSuccess()) {
				retMain = orderMainModelResponse.getResult();
			}
			envolopeVo.setOrderMainId(retMain.getOrdermainId());// 大订单号
			envolopeVo.setAmountMoney(retMain.getTotalPrice() != null ? retMain.getTotalPrice().toString() : "");// 总金额
			envolopeVo.setAmountPoint(retMain.getTotalBonus() != null ? retMain.getTotalBonus().toString() : "");// 总积分
			envolopeVo.setCurStatusId(retMain.getCurStatusId());// 大订单当前状态
			List<OrderIdAndOrderStauts> orders = new ArrayList<>();
			OrderIdAndOrderStauts orderIdAndOrderStauts = null;
			for (int i = 0; i < tempList.size(); i++) {
				orderIdAndOrderStauts = new OrderIdAndOrderStauts();
				Map<String, Object> map = tempList.get(i);
				OrderSubModel tblOrder = (OrderSubModel) map.get("tblOrder");
				orderIdAndOrderStauts.setOrderId(tblOrder.getOrderId());
				orderIdAndOrderStauts.setOrderStatusId(tblOrder.getCurStatusId());
				orders.add(orderIdAndOrderStauts);
			}
			log.info("【MAL503】流水：{}, orderTypeId is FQ, failueList：{}", senderSN, failueList.size());
			for (int i = 0; i < failueList.size(); i++) {// 返回电子支付直接验证失败的订单或者电子支付返回状态未明订单
				orderIdAndOrderStauts = new OrderIdAndOrderStauts();
				Map<String, String> failMap = failueList.get(i);
				if (isNoSure) {
					failMap.put("orderStatusId", "0316");
					orderIdAndOrderStauts.setOrderStatusId("0316");
				} else {
					failMap.put("orderStatusId", "0307");
					orderIdAndOrderStauts.setOrderStatusId("0307");
				}
				orders.add(orderIdAndOrderStauts);
			}
			envolopeVo.setOrders(orders);
			return envolopeVo;
		} catch (Exception e) {
			log.error("分期订单发起支付失败 {}", Throwables.getStackTraceAsString(e));
			envolopeVo.setReturnCode("000009");
			envolopeVo.setReturnDes("系统异常");
			return envolopeVo;
		}
	}

	/**
	 * 判断订单是否使用优惠券或者积分抵扣
	 */
	private boolean isPrivilege(List<OrderSubModel> orderList) {
		if (orderList != null && orderList.size() > 0) {
			OrderSubModel order = null;
			for (int i = 0; i < orderList.size(); i++) {
				order = orderList.get(i);
				String privilegeId = order.getVoucherNo();
				Long discountPrivilege = order.getBonusTotalvalue();
				if (!StringUtils.isEmpty((privilegeId)) || (discountPrivilege != null && discountPrivilege > 0)) {
					return true;
				}
			}
		}
		return false;
	}

	/**
	 * 将电子支付优惠券支付结果以List返回
	 *
	 * @param orders
	 * @return
	 * @throws Exception
	 */
	private List<Map<String, String>> paraOrders(String orders) throws Exception {
		if (orders == null || "".equals(orders)) {
			log.info("拼xml报文时子订单为空");
			throw new Exception("orders is null");
		}
		if (orders.endsWith("|")) {// 如果最后一个域为空，则加上结束符#以方便处理
			orders = orders + "#";
		}
		log.debug("需要解析的orders:{}", orders);
		String[] ordersArray = orders.split("\\|");
		log.debug("ordersArray:{}", ordersArray.length);
		List<Map<String, String>> rList = Lists.newArrayList();
		if (ordersArray.length % 6 == 0) {
			for (int i = 0; i < ordersArray.length; i = i + 6) {
				Map<String, String> map = Maps.newHashMap();
				map.put("tradeSeqNo", ordersArray[i]);
				map.put("merId", ordersArray[i + 1]);
				map.put("orderId", ordersArray[i + 2]);
				map.put("result", ordersArray[i + 3]);
				map.put("errcode", ordersArray[i + 4]);
				String errdesc = ordersArray[i + 5];
				if ("#".equals(ordersArray[i + 5])) {
					errdesc = "";
				}
				map.put("errdesc", errdesc);
				rList.add(map);
			}
		}
		return rList;
	}

	/**
	 * 获取帐号类型 C：信用卡 Y：借记卡 W：未明
	 *
	 * @param account
	 * @return
	 */
	private String getCardType(String account) {
		if (account == null || "".equals(account.trim())) {
			return "";
		} else if (account.trim().length() == 16) {// 信用卡
			return "C";
		} else {// 未明
			return "W";
		}
	}

	/**
	 * 公共错误信息
	 *
	 * @param returnCode
	 * @param returnDesc
	 * @return
	 */
	public WXPayReturnVO commonErrorMsg(String returnCode, String returnDesc) {
		WXPayReturn envolopeVo = new WXPayReturn();
		envolopeVo.setReturnCode(returnCode);
		envolopeVo.setReturnDes(returnDesc);
		return BeanUtils.copy(envolopeVo, WXPayReturnVO.class);
	}

	/**
	 * 计算两个值相加的结果
	 *
	 * @param value1
	 * @param value2
	 * @return
	 * @throws Exception
	 */
	public String dataAdd(String value1, String value2) throws Exception {
		String returnVal = "";
		try {
			returnVal = new BigDecimal(value1).add(new BigDecimal(value2)).toString();
			return returnVal;
		} catch (Exception e) {
			throw new Exception("金额转换错误");
		}
	}

	/**
	 * 配合信用卡大机改造BP0005接口新增字段-接口工程公共方法
	 *
	 * @param sendGateWayEnvolopeVo
	 * @param vendorRatio
	 * @param vendor
	 * @param totalMoney
	 */
	private void vendorRatioMessage(GateWayEnvolopeVo sendGateWayEnvolopeVo, TblVendorRatioModel vendorRatio,
			VendorInfoModel vendor, String totalMoney) {
		if (vendorRatio != null) {
			sendGateWayEnvolopeVo.setMessageEntityValue("FIXEDFEEHTFLAG", vendorRatio.getFixedfeehtFlag());
			sendGateWayEnvolopeVo.setMessageEntityValue("FIXEDAMTFEE", vendorRatio.getFixedamtFee() == null ? "0"
					: String.valueOf(vendorRatio.getFixedamtFee().setScale(2, BigDecimal.ROUND_DOWN)));
			sendGateWayEnvolopeVo.setMessageEntityValue("FEERATIO1", vendorRatio.getFeeratio1() == null ? "0"
					: String.valueOf(vendorRatio.getFeeratio1().setScale(5, BigDecimal.ROUND_DOWN)));
			sendGateWayEnvolopeVo.setMessageEntityValue("RATIO1PRECENT", vendorRatio.getRatio1Precent() == null ? "0"
					: String.valueOf(vendorRatio.getRatio1Precent().setScale(2, BigDecimal.ROUND_DOWN)));
			sendGateWayEnvolopeVo.setMessageEntityValue("FEERATIO2", vendorRatio.getFeeratio2() == null ? "0"
					: String.valueOf(vendorRatio.getFeeratio2().setScale(5, BigDecimal.ROUND_DOWN)));
			sendGateWayEnvolopeVo.setMessageEntityValue("RATIO2PRECENT", vendorRatio.getRatio2Precent() == null ? "0"
					: String.valueOf(vendorRatio.getRatio2Precent().setScale(2, BigDecimal.ROUND_DOWN)));
			sendGateWayEnvolopeVo.setMessageEntityValue("FEERATIO2BILL",
					vendorRatio.getFeeratio2Bill() == null ? "0" : String.valueOf(vendorRatio.getFeeratio2Bill()));
			sendGateWayEnvolopeVo.setMessageEntityValue("FEERATIO3", vendorRatio.getFeeratio3() == null ? "0"
					: String.valueOf(vendorRatio.getFeeratio3().setScale(5, BigDecimal.ROUND_DOWN)));
			sendGateWayEnvolopeVo.setMessageEntityValue("RATIO3PRECENT", vendorRatio.getRatio3Precent() == null ? "0"
					: String.valueOf(vendorRatio.getRatio3Precent().setScale(2, BigDecimal.ROUND_DOWN)));
			sendGateWayEnvolopeVo.setMessageEntityValue("FEERATIO3BILL",
					vendorRatio.getFeeratio3Bill() == null ? "0" : String.valueOf(vendorRatio.getFeeratio3Bill()));
			sendGateWayEnvolopeVo.setMessageEntityValue("REDUCERATEFROM",
					vendorRatio.getReducerateFrom() == null ? "0" : String.valueOf(vendorRatio.getReducerateFrom()));
			sendGateWayEnvolopeVo.setMessageEntityValue("REDUCERATETO",
					vendorRatio.getReducerateTo() == null ? "0" : String.valueOf(vendorRatio.getReducerateTo()));
			sendGateWayEnvolopeVo.setMessageEntityValue("REDUCEHANDINGFEE",
					vendorRatio.getReducerate() == null ? "0" : String.valueOf(vendorRatio.getReducerate()));
			sendGateWayEnvolopeVo.setMessageEntityValue("HTFLAG",
					vendorRatio.getHtflag() == null ? "" : vendorRatio.getHtflag());
			// 如果“首尾付本金”(HTCAPITAL)大于现金金额(tblOrder.getTotalMoney())，默认送现金金额，如果小于等于现金金额,就送首尾付本金值--大机补充需求 mod by dengbing
			// start
			String htcapital = "0";
			BigDecimal TotalMoneyDe = null;
			if (!StringUtils.isEmpty(totalMoney)) {
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
			sendGateWayEnvolopeVo.setMessageEntityValue("HTCAPITAL", htcapital);
		}
		if (vendor != null) {
			// 虚拟特店号
			sendGateWayEnvolopeVo.setMessageEntityValue("VIRTUALSTORE", vendor.getVirtualVendorId());
		}
	}

	/**
	 * 现金部分为0，则不调用BPS的接口，直接处理为支付成功
	 */
	private GateWayEnvolopeVo returnBPSVO() {
		GateWayEnvolopeVo returnGateWayEnvolopeVo = new GateWayEnvolopeVo();
		returnGateWayEnvolopeVo.setMessageEntityValue("ERRORCODE", "0000");// Bps返回的错误码
		returnGateWayEnvolopeVo.setMessageEntityValue("APPROVERESULT", "0010");// Bps返回的返回码0000-全额 0010-逐期 0100-拒绝
																				// 0200-转人工 0210-异常转人工
		returnGateWayEnvolopeVo.setMessageEntityValue("FOLLOWDIR", "");// 后续流转方向0-不流转 1-流转
		returnGateWayEnvolopeVo.setMessageEntityValue("CASEID", "");// BPS工单号
		returnGateWayEnvolopeVo.setMessageEntityValue("SPECIALCUST", "");// 是否黑灰名单 0-黑名单 1-灰名单 2-其他
		returnGateWayEnvolopeVo.setMessageEntityValue("RELEASETYPE", "");// 释放类型
		returnGateWayEnvolopeVo.setMessageEntityValue("REJECTCODE", "");// 拒绝代码
		returnGateWayEnvolopeVo.setMessageEntityValue("APRTCODE", "");// 逐期代码
		returnGateWayEnvolopeVo.setMessageEntityValue("ORDERNBR", "00000000000");// 核心订单号、银行订单号: 默认11个0
		return returnGateWayEnvolopeVo;
	}

	private StagingRequest vo2req(GateWayEnvolopeVo sendGateWayEnvolopeVo) {
		StagingRequest req = new StagingRequest();
		req.setSrcCaseId(sendGateWayEnvolopeVo.getMessageEntityValue("SRCCASEID"));
		req.setInterfaceType(sendGateWayEnvolopeVo.getMessageEntityValue("INTERFACETYPE"));
		req.setCaseType(sendGateWayEnvolopeVo.getMessageEntityValue("CASETYPE"));
		req.setSubCaseType(sendGateWayEnvolopeVo.getMessageEntityValue("SUBCASETYPE"));
		req.setChannel(sendGateWayEnvolopeVo.getMessageEntityValue("CHANNEL"));
		req.setProject(sendGateWayEnvolopeVo.getMessageEntityValue("PROJECT"));
		req.setRequestType(sendGateWayEnvolopeVo.getMessageEntityValue("REQUESTTYPE"));
		req.setCreator(sendGateWayEnvolopeVo.getMessageEntityValue("CREATOR"));
		req.setMichelleId(sendGateWayEnvolopeVo.getMessageEntityValue("MICHELLEID"));
		req.setBookDesc(sendGateWayEnvolopeVo.getMessageEntityValue("BOOKDESC"));
		req.setReceiveMode(sendGateWayEnvolopeVo.getMessageEntityValue("RECEIVEMODE"));
		req.setAddr(sendGateWayEnvolopeVo.getMessageEntityValue("ADDR"));
		req.setPostcode(sendGateWayEnvolopeVo.getMessageEntityValue("POSTCODE"));
		req.setDrawer(sendGateWayEnvolopeVo.getMessageEntityValue("DRAWER"));//
		req.setSendCode(sendGateWayEnvolopeVo.getMessageEntityValue("SENDCODE"));
		req.setRegulator(sendGateWayEnvolopeVo.getMessageEntityValue("REGULATOR"));
		req.setSmsnotice(sendGateWayEnvolopeVo.getMessageEntityValue("SMSNOTICE"));
		req.setSmsPhone(sendGateWayEnvolopeVo.getMessageEntityValue("SMSPHONE"));
		req.setContactNbr1(sendGateWayEnvolopeVo.getMessageEntityValue("CONTACTNBR1"));
		req.setContactNbr2(sendGateWayEnvolopeVo.getMessageEntityValue("CONTACTNBR2"));
		req.setSbookid(sendGateWayEnvolopeVo.getMessageEntityValue("SBOOKID"));
		req.setSuborderid(sendGateWayEnvolopeVo.getMessageEntityValue("SUBORDERID"));
		req.setBbookid(sendGateWayEnvolopeVo.getMessageEntityValue("BBOOKID"));
		req.setReservation(sendGateWayEnvolopeVo.getMessageEntityValue("RESERVATION"));
		req.setReserveTime(sendGateWayEnvolopeVo.getMessageEntityValue("RESERVETIME"));
		req.setCardnbr(sendGateWayEnvolopeVo.getMessageEntityValue("CARDNBR"));
		req.setIdNbr(sendGateWayEnvolopeVo.getMessageEntityValue("IDNBR"));
		req.setCerttype(sendGateWayEnvolopeVo.getMessageEntityValue("CERTTYPE"));
		req.setUrgentLvl(sendGateWayEnvolopeVo.getMessageEntityValue("CERTTYPE"));
		req.setOldBankId(sendGateWayEnvolopeVo.getMessageEntityValue("OLDBANKID"));
		req.setProductCode(sendGateWayEnvolopeVo.getMessageEntityValue("PRODUCTCODE"));
		req.setProductName(sendGateWayEnvolopeVo.getMessageEntityValue("PRODUCTNAME"));
		req.setPrice(new BigDecimal(sendGateWayEnvolopeVo.getMessageEntityValue("PRICE")));
		req.setColor(sendGateWayEnvolopeVo.getMessageEntityValue("COLOR"));
		req.setAmount(sendGateWayEnvolopeVo.getMessageEntityValue("AMOUNT"));
		req.setSumAmt(new BigDecimal(sendGateWayEnvolopeVo.getMessageEntityValue("SUMAMT")));
		req.setFirstPayment(new BigDecimal(sendGateWayEnvolopeVo.getMessageEntityValue("FIRSTPAYMENT")));
		req.setBills(sendGateWayEnvolopeVo.getMessageEntityValue("BILLS"));
		req.setPerPeriodAmt(new BigDecimal(sendGateWayEnvolopeVo.getMessageEntityValue("PERPERIODAMT")));
		req.setSupplierCode(sendGateWayEnvolopeVo.getMessageEntityValue("SUPPLIERCODE"));
		req.setSupplierDesc(sendGateWayEnvolopeVo.getMessageEntityValue("SUPPLIERDESC"));
		req.setRecommendCardnbr(sendGateWayEnvolopeVo.getMessageEntityValue("RECOMMENDCARDNBR"));
		req.setRecommendname(sendGateWayEnvolopeVo.getMessageEntityValue("RECOMMENDNAME"));
		req.setRecommendCerttype(sendGateWayEnvolopeVo.getMessageEntityValue("RECOMMENDCERTTYPE"));
		req.setRecommendid(sendGateWayEnvolopeVo.getMessageEntityValue("RECOMMENDID"));
		req.setPrevCaseId(sendGateWayEnvolopeVo.getMessageEntityValue("PREVCASEID"));
		req.setCustName(sendGateWayEnvolopeVo.getMessageEntityValue("CUSTNAME"));
		req.setIncomingTel(sendGateWayEnvolopeVo.getMessageEntityValue("INCOMINGTEL"));
		req.setOrdermemo(sendGateWayEnvolopeVo.getMessageEntityValue("ORDERMEMO"));
		req.setForceTransfer(sendGateWayEnvolopeVo.getMessageEntityValue("FORCETRANSFER"));
		req.setSupplierName(sendGateWayEnvolopeVo.getMessageEntityValue("SUPPLIERNAME"));
		req.setMemo(sendGateWayEnvolopeVo.getMessageEntityValue("MEMO"));
		req.setReceiveName(sendGateWayEnvolopeVo.getMessageEntityValue("RECEIVENAME"));
		req.setMerchantCode(sendGateWayEnvolopeVo.getMessageEntityValue("MERCHANTCODE"));
		req.setAcceptAmt(new BigDecimal(sendGateWayEnvolopeVo.getMessageEntityValue("ACCEPTAMT")));
		req.setFavorableType(sendGateWayEnvolopeVo.getMessageEntityValue("FAVORABLETYPE"));
		req.setDeductAmt(new BigDecimal(sendGateWayEnvolopeVo.getMessageEntityValue("DEDUCTAMT")));
		req.setFixedFeeHTFlag(sendGateWayEnvolopeVo.getMessageEntityValue("FIXEDFEEHTFLAG"));
		req.setFixedAmtFee(new BigDecimal(sendGateWayEnvolopeVo.getMessageEntityValue("FIXEDAMTFEE")));
		req.setFeeRatio1(new BigDecimal(sendGateWayEnvolopeVo.getMessageEntityValue("FEERATIO1")));
		req.setRatio1Precent(new BigDecimal(sendGateWayEnvolopeVo.getMessageEntityValue("RATIO1PRECENT")));
		req.setFeeRatio2(new BigDecimal(sendGateWayEnvolopeVo.getMessageEntityValue("FEERATIO2")));
		req.setRatio2Precent(new BigDecimal(sendGateWayEnvolopeVo.getMessageEntityValue("RATIO2PRECENT")));
		req.setFeeRatio2Bill(new Integer(sendGateWayEnvolopeVo.getMessageEntityValue("FEERATIO2BILL")));
		req.setFeeRatio3(new BigDecimal(sendGateWayEnvolopeVo.getMessageEntityValue("FEERATIO3")));
		req.setRatio3Precent(new BigDecimal(sendGateWayEnvolopeVo.getMessageEntityValue("RATIO3PRECENT")));
		req.setFeeRatio3Bill(new Integer(sendGateWayEnvolopeVo.getMessageEntityValue("FEERATIO3BILL")));
		req.setReducerateFrom(new Integer(sendGateWayEnvolopeVo.getMessageEntityValue("REDUCERATEFROM")));
		req.setReducerateTo(new Integer(sendGateWayEnvolopeVo.getMessageEntityValue("REDUCERATETO")));
		req.setReduceHandingFee(new Integer(sendGateWayEnvolopeVo.getMessageEntityValue("REDUCEHANDINGFEE")));
		req.setHtFlag(sendGateWayEnvolopeVo.getMessageEntityValue("HTFLAG"));
		req.setHtCapital(new BigDecimal(sendGateWayEnvolopeVo.getMessageEntityValue("HTCAPITAL")));
		req.setVirtualStore(sendGateWayEnvolopeVo.getMessageEntityValue("VIRTUALSTORE"));
		return req;
	}

	public String getGateWaySeq() {
		Random ran = new Random();
		int ranInt = ran.nextInt(9999);
		if (ranInt < 10) {
			ranInt = ranInt * 1000;
		} else if (ranInt < 100) {
			ranInt = ranInt * 100;
		} else if (ranInt < 1000) {
			ranInt = ranInt * 10;
		}
		String gatewaySeq = DateHelper.getCurrentTime() + genSeq() + ranInt;
		return gatewaySeq;
	}

	private long genSeq() {
		if (gwSeq >= 9999) {
			gwSeq = 1000;
		}
		gwSeq++;
		return gwSeq;
	}

	/**
	 * 支付起停控制
	 *
	 * @param ordertypeId
	 * @param sourceId
	 * @return
	 */
	private boolean isQT(String ordertypeId, String sourceId) {
		boolean flag = true;
		Response<List<TblParametersModel>> responselistQT = businessService.findJudgeQT(ordertypeId, sourceId);
		if (!responselistQT.isSuccess()) {
			throw new RuntimeException(responselistQT.getError());
		}
		List<TblParametersModel> listQT = responselistQT.getResult();
		if (listQT != null && listQT.size() > 0) {
			TblParametersModel tblParameters = listQT.get(0);
			Integer openCloseFlag = tblParameters.getOpenCloseFlag();
			if (openCloseFlag == 1) {
				flag = false;
			}
		}
		return flag;
	}

	/**
	 * 去电子支付平台支付
	 *
	 * @param orderMain
	 * @return
	 * @throws Exception
	 */
	private Map<String, String> doPay(OrderMainModel orderMain, String validDate, String sourceSenderSN) {
		BigDecimal amountB = null;
		String amount = orderMain.getTotalPrice().toString();
		String accountNo = orderMain.getCardno();
		try {
			amountB = new BigDecimal(amount);
		} catch (Exception e) {
			log.error("价格转换失败：" + e.getMessage(), e);
			throw e;
		}
		if (0 == new BigDecimal("0").compareTo(amountB)) {// 纯积分支付
			amount = "0";
			accountNo = "";
		}
		if ("0.00".equals(amount) || "0".equals(amount)) {// 纯积分支付
			amount = "0";
			accountNo = "";
		}
		CCPointsPay ccPointPay = new CCPointsPay();
		ccPointPay.setTradeChannel(Contants.TRADECHANNEL);// 交易渠道
		ccPointPay.setTradeSource(Contants.TRADESOURCE);// 交易来源
		ccPointPay.setBizSight(Contants.BIZSIGHT);// 业务场景
		ccPointPay.setSorceSenderNo(sourceSenderSN + "");// 源发起方流水
		ccPointPay.setOperatorId("");// 操作员代码
		ccPointPay.setTradeSeqNo(orderMain.getSerialNo());// 20|交易流水号|Y
		ccPointPay.setOrderId(orderMain.getOrdermainId());// 30|订单号|Y
		ccPointPay.setAccountNo(accountNo);// 20|卡号|N
		ccPointPay.setAmount(amount);// 12|支付金额|##########.##|Y
		ccPointPay.setCurType("CNY");// 3|交易币种|Y
		ccPointPay.setCvv2("");// 5|CVV2|N
		ccPointPay.setValidDate(validDate);// 10|有效期|YYMM|N 短信渠道可为空
		ccPointPay.setMerId(orderMain.getMerId());// 20|商城商户号|Y
		ccPointPay.setTradeStatus("0");// 1|交易状态|Y
		ccPointPay.setIsMerger(orderMain.getIsmerge());// 1|是否合并支付|Y
		ccPointPay.setTradeDate(DateHelper.date2string(orderMain.getCreateTime(), "yyyyMMdd"));// 8|交易日期|Y
		ccPointPay.setTradeTime(DateHelper.date2string(orderMain.getCreateTime(), "HHmmss"));// 6|交易时间|Y
		ccPointPay.setRemark("");// 200|备注|N
		ccPointPay.setChannelID("WX");// 渠道标识为“wx”（积分系统界面优化修改）
		ccPointPay.setFracCardCount(1 + "");// 2|积分卡数量|Y
		// ccPointPay.setTerminalCode("02");// 终端编号 01-广发商城，02-积分商城（积分系统界面优化增加）
		CCPointsPayBaseInfo ccPointPayBaseInfo = new CCPointsPayBaseInfo();
		ccPointPayBaseInfo.setFracCardNo(orderMain.getCardno());// 积分信用卡卡号|N
		ccPointPayBaseInfo.setFracAmount(orderMain.getTotalBonus().toString());// 扣除积分数|正整数|N 15
		ccPointPayBaseInfo.setFracType(orderMain.getIntegraltypeId());// 3|积分类型
		ccPointPayBaseInfo.setFracValidDate(validDate);// 4|积分信用卡有效期|YYMM|N
		ArrayList<CCPointsPayBaseInfo> infos = Lists.newArrayList(ccPointPayBaseInfo);
		ccPointPay.setCcPointsPayBaseInfos(infos);
		String retCode = "";
		String retErrMsg = "";
		String payTime = "";
		Map<String, String> map = Maps.newHashMap();
		try {
			CCPointResult baseResult = paymentService.ccPointsPay(ccPointPay);
			retCode = baseResult.getRetCode();
			retErrMsg = baseResult.getRetErrMsg();
			payTime = baseResult.getPayTime();
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
		map.put("retCode", retCode);
		map.put("retErrMsg", retErrMsg);
		map.put("payTime", payTime);
		return map;
	}

	/**
	 * 更新支付状态
	 *
	 * @param orderMain
	 * @param oper_nm
	 * @param retCode
	 */
	private void updateVirtualOrders(OrderMainModel orderMain, String oper_nm, String retCode,Date payTime) {
		String payState = "";// 订单最终状态 1:支付成功 2:支付失败 3:状态未明
		if ("000000".equals(retCode)) {// 支付成功
			payState = "1";
		} else if (PayReturnCode.isStateNoSure(retCode) || retCode == null || "".equals(retCode)) {// 如果支付时状态未明
			// 电子支付返回“EBLN2000”，小订单状态需要置为“状态未明”
			payState = "3";
		} else {// 支付失败
			payState = "2";
		}
		// bug-305197 fixed by ldk
		updateVirtualOrdersWithTX(orderMain.getOrdermainId(), payState, oper_nm, retCode, payTime);
	}

	/**
	 * 更新虚拟礼品状态
	 */
	// bug-305197 fixed by ldk
	private void updateVirtualOrdersWithTX(String orderMainId, String payState, String oper_nm, String retCode,
			Date payTime) {
		log.info("进入更新虚拟订单相关updateVirtualOrdersWithTX");
		Response<List<OrderSubModel>> responseList = orderService.findByOrderMainId(orderMainId); // 根据主订单号查询子订单表数据
		if (!responseList.isSuccess()) {
			throw new RuntimeException(responseList.getError());
		}
		List<OrderSubModel> orders = responseList.getResult();
		// 订单状态ID
		String cur_status_id = "";
		// 订单状态说明
		String cur_status_nm = "";
		if ("1".equals(payState)) {// 支付成功
			cur_status_id = Contants.SUB_ORDER_STATUS_0308;
			cur_status_nm = Contants.SUB_ORDER_PAYMENT_SUCCEED;
		} else if ("3".equals(payState)) {// 状态未明
			cur_status_id = Contants.SUB_ORDER_STATUS_0316;
			cur_status_nm = Contants.SUB_ORDER_UNCLEAR;
		} else {// 支付失败
			cur_status_id = Contants.SUB_ORDER_STATUS_0307;
			cur_status_nm = Contants.SUB_ORDER_PAYMENT_FAILED;
		}
		OrderMainModel updateMainModel = new OrderMainModel();
		updateMainModel.setOrdermainId(orderMainId);
		updateMainModel.setCurStatusId(cur_status_id);
		updateMainModel.setCurStatusNm(cur_status_nm);
		updateMainModel.setPayResultTime(DateHelper.date2string(payTime ,DateHelper.YYYYMMDDHHMMSS));
		updateMainModel
				.setModifyTime(DateHelper.string2Date(DateHelper.getCurrentTime(), DateHelper.YYYY_MM_DD_HH_MM_SS));
		updateMainModel.setModifyOper(oper_nm);
		updateMainModel.setErrorCode(retCode);
		updateMainModel.setPayResultTime(DateHelper.getyyyyMMdd() + DateHelper.getHHmmss());
		tblOrderMainService.updateTblOrderMain(updateMainModel);
		OrderSubModel updateSubModel = new OrderSubModel();
		updateSubModel.setOrdermainId(orderMainId);
		updateSubModel.setCurStatusId(cur_status_id);
		updateSubModel.setCurStatusNm(cur_status_nm);
		updateSubModel
				.setModifyTime(DateHelper.string2Date(DateHelper.getCurrentTime(), DateHelper.YYYY_MM_DD_HH_MM_SS));
		updateSubModel.setModifyOper(oper_nm);
		updateSubModel.setErrorCode(retCode);
		// bug-305197 fixed by ldk
		updateSubModel.setOrder_succ_time(payTime);
		updateSubModel.setOrder_succ_timeStr(DateHelper.date2string(payTime,DateHelper.YYYYMMDDHHMMSS));
		orderService.updateTblOrderSub(updateSubModel);
		if (null != orders && orders.size() > 0) {
			OrderSubModel order = orders.get(0);
			OrderDoDetailModel tblOrderDodetail = new OrderDoDetailModel();
			tblOrderDodetail.setOrderId(order.getOrderId());
			tblOrderDodetail
					.setDoTime(DateHelper.string2Date(DateHelper.getCurrentTime(), DateHelper.YYYY_MM_DD_HH_MM_SS));
			tblOrderDodetail.setDoUserid("电子支付");
			tblOrderDodetail.setDoDesc(retCode);
			tblOrderDodetail.setStatusId(cur_status_id);
			tblOrderDodetail.setStatusNm(cur_status_nm);
			tblOrderDodetail.setUserType("0");
			tblOrderDodetail.setCreateOper("电子支付");
			tblOrderDodetail.setDelFlag(0);

			orderService.insertOrderDoDetail(tblOrderDodetail);
			if (Contants.SUB_ORDER_STATUS_0307.equals(cur_status_id)) {
				// 支付失败回滚库存(9999无限库存)
				goodsService.updateGoodsJF(order.getGoodsId(), order.getGoodsNum().longValue());
			}
		}
	}

	/**
	 * 处理bps分期支付信息(微信渠道)
	 * 
	 * @param ordermain_id
	 * @param ordersTemp
	 * @param cardNo
	 */
	public void dealWXFQorderBpswithTX(String ordermain_id, List<Map<String, Object>> ordersTemp, String cardNo)
			throws Exception {
		boolean orderMainFlag = true;
		OrderMainModel orderMainModel = new OrderMainModel();
		List<OrderCheckModel> orderCheckList2 = new ArrayList<OrderCheckModel>(); // 事物用，积分正交易
		List<OrderCheckModel> orderCheckList = new ArrayList<OrderCheckModel>(); // 事物用，优惠券正交易
		List<OrderSubModel> orderSubList = new ArrayList<OrderSubModel>(); // 事物用，更新子订单
		List<String> goodsIdList = new ArrayList<String>(); // 事物用，回滚商品库存
		List<OrderSubModel> dealPointPoolList = new ArrayList<OrderSubModel>(); // 事物用，回滚积分池
		List<OrderDoDetailModel> orderDoDetailModelList = new ArrayList<OrderDoDetailModel>(); // 事物用, 订单历史明细
		List<TblOrderExtend1Model> tblOrderExtend1ModelIns = new ArrayList<TblOrderExtend1Model>(); // 事物用, 订单扩展表
		List<TblOrderExtend1Model> tblOrderExtend1Modelupd = new ArrayList<TblOrderExtend1Model>(); // 事物用，订单扩展表
		String nowDate = DateHelper.getyyyyMMdd();
		String nowTime = DateHelper.getHHmmss();

		for (int i = 0; i < ordersTemp.size(); i++) {
			// OrderCheckModel orderCheck2 = new OrderCheckModel(); //积分
			// OrderCheckModel orderCheck = new OrderCheckModel(); //优惠券
			Map map = ordersTemp.get(i);
			OrderSubModel tblOrder = (OrderSubModel) map.get("tblOrder");

			Response<OrderSubModel> response = orderService.findOrderSubById(tblOrder.getOrderId());
			OrderSubModel orderSubModel = new OrderSubModel();
			if (response.isSuccess() && response.getResult() != null) {
				orderSubModel = response.getResult();
			}
			//往上面找，有插入时间
			orderSubModel.setOrder_succ_time(tblOrder.getOrder_succ_time());
			orderSubModel.setOrder_succ_timeStr(tblOrder.getOrder_succ_timeStr());
			tblOrder.setCardno(cardNo);// 修复积分撤销无卡号问题
			TblOrderExtend1Model tempTblOrderExtend1 = (TblOrderExtend1Model) map.get("tblOrderExtend1");
			String cardType = (String) map.get("cardType");// 卡类型
			if (null != cardType && cardType.trim().length() > 0) {// 设置card类型
				tblOrder.setCardtype(cardType);
			}
			GateWayEnvolopeVo returnGateWayEnvolopeVo = (GateWayEnvolopeVo) map.get("returnGateWayEnvolopeVo");
			String errorCode = "";
			if (returnGateWayEnvolopeVo != null) {
				errorCode = returnGateWayEnvolopeVo.getMessageEntityValue("ERRORCODE");
				errorCode = StringUtils.subTopString(errorCode, 4);
			}
			String ischeck = "";
			String ispont = "";
			if (tblOrder.getVoucherNo() != null && !"".equals(tblOrder.getVoucherNo())) {
				ischeck = "0";
			}
			if (tblOrder.getBonusTotalvalue() != null && tblOrder.getBonusTotalvalue().longValue() != 0) {
				ispont = "0";
			}
			if (!"".equals(ispont)) {// 插入积分正交易
				OrderCheckModel orderCheck2 = new OrderCheckModel(); // 积分
				orderCheck2.setOrderId(tblOrder.getOrderId());
				orderCheck2.setCurStatusId("0308");
				orderCheck2.setCurStatusNm("支付成功");
				orderCheck2.setDoDate(nowDate);
				orderCheck2.setDoTime(nowTime);
				orderCheck2.setIscheck("");
				orderCheck2.setIspoint(ispont);
				orderCheck2.setDelFlag(0);
				orderCheckList2.add(orderCheck2);
			}
			// 分期订单电子支付是否已经验证标识 Null或’’:电子支付平台未验证 1:电子支付平台已验证
			orderSubModel.setCashAuthType("1");
			tblOrder.setCashAuthType("1");
			if (returnGateWayEnvolopeVo != null && errorCode != null) {// 如果能正确获取到bps的返回对象
				String approveResult = returnGateWayEnvolopeVo.getMessageEntityValue("APPROVERESULT");
				String followdir = returnGateWayEnvolopeVo.getMessageEntityValue("FOLLOWDIR");
				String caseid = returnGateWayEnvolopeVo.getMessageEntityValue("CASEID");
				String specialcust = returnGateWayEnvolopeVo.getMessageEntityValue("SPECIALCUST");
				String releasetype = returnGateWayEnvolopeVo.getMessageEntityValue("RELEASETYPE");
				String rejectcode = returnGateWayEnvolopeVo.getMessageEntityValue("REJECTCODE");
				String aprtcode = returnGateWayEnvolopeVo.getMessageEntityValue("APRTCODE");
				String ordernbr = returnGateWayEnvolopeVo.getMessageEntityValue("ORDERNBR");
				if (BpsReturnCode.isBp0005Sucess(errorCode, approveResult)) {// 如果支付成功
					orderSubModel.setOrderId(tblOrder.getOrderId());
					orderSubModel.setCardno(cardNo);
					orderSubModel.setCardtype(cardType);
					orderSubModel.setCurStatusId("0308");
					orderSubModel.setCurStatusNm("支付成功");
					orderSubModel.setErrorCode("");
					tblOrder.setCurStatusId("0308");
					tblOrder.setCurStatusNm("支付成功");
					if (!"".equals(ischeck)) {// 插入优惠券正交易
						OrderCheckModel orderCheck = new OrderCheckModel(); // 优惠券
						orderCheck.setOrderId(orderSubModel.getOrderId());
						orderCheck.setCurStatusId("0308");
						orderCheck.setCurStatusNm("支付成功");
						orderCheck.setDoDate(nowDate);
						orderCheck.setDoTime(nowTime);
						orderCheck.setIscheck(ischeck);
						orderCheck.setIspoint("");
						orderCheck.setDelFlag(0);
						orderCheckList.add(orderCheck);
					}
					/**** 支付成功时插入对账文件表end ****/
				} else if (BpsReturnCode.isBp0005Dealing(errorCode, approveResult)) {// 如果处理中
					orderSubModel.setOrderId(tblOrder.getOrderId());
					orderSubModel.setCardno(cardNo);
					orderSubModel.setCardtype(cardType);
					orderSubModel.setCurStatusId("0305");
					orderSubModel.setCurStatusNm("处理中");
					orderSubModel.setErrorCode("");
					tblOrder.setCurStatusId("0305");
					tblOrder.setCurStatusNm("处理中");
				} else if (BpsReturnCode.isBp0005NoSure(errorCode, approveResult)) {// 如果状态未明
					orderSubModel.setOrderId(tblOrder.getOrderId());
					orderSubModel.setCardno(cardNo);
					orderSubModel.setCardtype(cardType);
					orderSubModel.setCurStatusId("0316");
					orderSubModel.setCurStatusNm("状态未明");
					orderSubModel.setErrorCode("");
					tblOrder.setCurStatusId("0316");
					tblOrder.setCurStatusNm("状态未明");
				} else {
					goodsIdList.add(tblOrder.getGoodsId()); // 回滚商品数量
					if (tblOrder.getBonusTotalvalue() != null && tblOrder.getBonusTotalvalue().longValue() != 0) {
						dealPointPoolList.add(tblOrder); // 回滚积分池
					}
					orderSubModel.setOrderId(tblOrder.getOrderId());
					orderSubModel.setCardno(cardNo);
					orderSubModel.setCardtype(cardType);
					orderSubModel.setCurStatusId("0307");
					orderSubModel.setCurStatusNm("支付失败");
					orderSubModel.setErrorCode("");
					tblOrder.setCurStatusId("0307");
					tblOrder.setCurStatusNm("支付失败");
					orderMainFlag = false;
					// 电子支付成功，bps失败的负交易 0307 用当前时间
					if (!"".equals(ischeck) || !"".equals(ispont)) {
						String jfRefundSerialno = "";
						if (!"".equals(ispont)) {
							jfRefundSerialno = idGenarator.jfRefundSerialNo();
						}
						OrderCheckModel orderCheck2 = new OrderCheckModel(); // 积分
						orderCheck2.setJfRefundSerialno(jfRefundSerialno);
						orderCheck2.setOrderId(tblOrder.getOrderId());
						orderCheck2.setCurStatusId("0307");
						orderCheck2.setCurStatusNm("支付失败");
						orderCheck2.setDoDate(nowDate);
						orderCheck2.setDoTime(nowTime);
						orderCheck2.setIscheck(ischeck);
						orderCheck2.setIspoint(ispont);
						orderCheck2.setDelFlag(0);
						orderCheckList2.add(orderCheck2);
						// 支付成功，bps失败 插入积分对账负交易
						if (!"".equals(ispont)) {
							// 调用主动退积分接口
							try {
								sendNSCT009(tblOrder, orderCheck2.getDoDate(), orderCheck2.getDoTime(),
										jfRefundSerialno);
							} catch (Exception se) {
								log.error("微信分期支付失败,主动退积分失败:{}", se.getMessage());
							}
						}
					}
					/**** 支付失败时插入对账文件表end ****/
				}
				// 插入历史记录
				OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
				orderDoDetailModel.setOrderId((orderSubModel.getOrderId()));
				orderDoDetailModel.setDoTime(new Date());
				orderDoDetailModel.setDoUserid("System");
				orderDoDetailModel.setUserType("0");
				orderDoDetailModel.setStatusId(orderSubModel.getCurStatusId());
				orderDoDetailModel.setStatusNm(orderSubModel.getCurStatusNm());
				orderDoDetailModel.setDoDesc("微信广发分期支付");
				orderDoDetailModel.setCreateOper(orderSubModel.getCreateOper());
				orderDoDetailModel.setDelFlag(0);
				orderDoDetailModelList.add(orderDoDetailModel);

				if (tempTblOrderExtend1 == null) {
					// 插入订单扩展表
					TblOrderExtend1Model tblOrderExtend1 = new TblOrderExtend1Model();
					tblOrderExtend1.setOrderId(tblOrder.getOrderId());
					tblOrderExtend1.setErrorcode(errorCode);
					tblOrderExtend1.setApproveresult(approveResult);
					tblOrderExtend1.setFollowdir(followdir);
					tblOrderExtend1.setCaseid(caseid);
					tblOrderExtend1.setSpecialcust(specialcust);
					tblOrderExtend1.setReleasetype(releasetype);
					tblOrderExtend1.setRejectcode(rejectcode);
					tblOrderExtend1.setAprtcode(aprtcode);
					tblOrderExtend1.setOrdernbr(ordernbr);
					tblOrderExtend1ModelIns.add(tblOrderExtend1);

				} else {// 更新扩展表
					TblOrderExtend1Model tblOrderExtend1 = new TblOrderExtend1Model();
					tblOrderExtend1.setOrderId(tblOrder.getOrderId());
					tblOrderExtend1.setErrorcode(errorCode);
					tblOrderExtend1.setApproveresult(approveResult);
					tblOrderExtend1.setFollowdir(followdir);
					tblOrderExtend1.setCaseid(caseid);
					tblOrderExtend1.setSpecialcust(specialcust);
					tblOrderExtend1.setReleasetype(releasetype);
					tblOrderExtend1.setRejectcode(rejectcode);
					tblOrderExtend1.setAprtcode(aprtcode);
					tblOrderExtend1.setOrdernbr(ordernbr);
					tblOrderExtend1Modelupd.add(tblOrderExtend1);
				}
			} else {// 如果returnGateWayEnvolopeVo==null,返回状态未明
				orderSubModel.setOrderId(tblOrder.getOrderId());
				orderSubModel.setCardno(cardNo);
				orderSubModel.setCardtype(cardType);
				orderSubModel.setCurStatusId("0316");
				orderSubModel.setCurStatusNm("状态未明");
				orderSubModel.setErrorCode("");
				tblOrder.setCurStatusId("0316");
				tblOrder.setCurStatusNm("状态未明");
				// 插入历史记录
				OrderDoDetailModel orderDoDetailModel = new OrderDoDetailModel();
				orderDoDetailModel.setOrderId((orderSubModel.getOrderId()));
				orderDoDetailModel.setDoTime(new Date());
				orderDoDetailModel.setDoUserid("System");
				orderDoDetailModel.setUserType("0");
				orderDoDetailModel.setStatusId(orderSubModel.getCurStatusId());
				orderDoDetailModel.setStatusNm(orderSubModel.getCurStatusNm());
				orderDoDetailModel.setMsgContent("");
				orderDoDetailModel.setDoDesc("微信广发分期支付");
				orderDoDetailModel.setRuleId("");
				orderDoDetailModel.setRuleNm("");
				orderDoDetailModel.setCreateOper(orderSubModel.getCreateOper());
				orderDoDetailModel.setDelFlag(0);
				orderDoDetailModelList.add(orderDoDetailModel);
			}
			orderSubList.add(orderSubModel); // 更新子订单表

		}
		Response<OrderMainModel> orderMainResponse = orderService.findOrderMainById(ordermain_id);
		if (orderMainResponse.isSuccess() && orderMainResponse != null) {
			orderMainModel = orderMainResponse.getResult();
		}
		if (orderMainFlag && ordersTemp.size() > 0) {// 大订单成功
			orderMainModel.setOrdermainId(ordermain_id);
			orderMainModel.setCardno(cardNo);
			orderMainModel.setCurStatusId("0308");
			orderMainModel.setCurStatusNm("支付成功");
		} else {// 大订单异常
			orderMainModel.setOrdermainId(ordermain_id);
			orderMainModel.setCardno(cardNo);
			orderMainModel.setCurStatusId("0307");
			orderMainModel.setCurStatusNm("支付失败");
		}

		// 事物处理
		payService.dealWXFQorderBpswithTX(orderCheckList2, orderCheckList, goodsIdList, dealPointPoolList,
				tblOrderExtend1ModelIns, tblOrderExtend1Modelupd, orderMainModel, orderSubList, orderDoDetailModelList);
	}

	/**
	 * 发起撤销积分申请
	 *
	 * @param order
	 * @param curDate 撤销日期
	 * @param curTime 撤销时间
	 * @param jfRefundSerialno 撤销流水 jfRefundSerialno退积分流水
	 */
	private void sendNSCT009(OrderSubModel order, String curDate, String curTime, String jfRefundSerialno)
			throws Exception {
		// bsp分期失败需要调用积分撤销接口
		log.info("开始获取nTNSCT009bean");
		ReturnPointsInfo gateWayEnvolopeVo = new ReturnPointsInfo();

		gateWayEnvolopeVo.setChannelID(sourceIdChangeToChannel(order.getSourceId()));// 渠道标识
		gateWayEnvolopeVo.setMerId(order.getMerId()); // 大商户号(商城商户号)
		gateWayEnvolopeVo.setOrderId(order.getOrderId()); // 订单号(小)
		String consumeTypeStr = "1";
		if (order.getVoucherNo() != null && !"".equals(order.getVoucherNo().trim())) {
			consumeTypeStr = "2";
		}
		gateWayEnvolopeVo.setConsumeType(consumeTypeStr); // 消费类型("0":纯积分(这里不存在)\"1":积分+现金\"2":积分+现金+优惠券)
		gateWayEnvolopeVo.setCurrency("CNY"); // 币种
		gateWayEnvolopeVo.setTranDate(curDate); // 发起方日期(当前日期)
		gateWayEnvolopeVo.setTranTiem(curTime); // 发起方时间(当前时间)
		gateWayEnvolopeVo.setTradeSeqNo(jfRefundSerialno);// 发起方流水号
		gateWayEnvolopeVo.setSendDate(DateHelper.date2string(order.getOrder_succ_time(), "yyyyMMdd")); // 原发起方日期
		gateWayEnvolopeVo.setSendTime(DateHelper.date2string(order.getOrder_succ_time(), "HHmmss")); // 原发起方时间
		gateWayEnvolopeVo.setSerialNo(order.getOrderIdHost()); // 原发起方流水号
		gateWayEnvolopeVo.setCardNo(order.getCardno()); // 卡号
		gateWayEnvolopeVo.setExpiryDate("0000"); // 卡片有效期
		gateWayEnvolopeVo.setPayMomey(new BigDecimal(0)); // 现金支付金额(默认送0)
		gateWayEnvolopeVo.setJgId(Contants.JGID_COMMON); // 积分类型
		gateWayEnvolopeVo.setDecrementAmt(order.getBonusTotalvalue()); // 扣减积分额
		gateWayEnvolopeVo.setTerminalNo("01"); // 终端号("01"广发商城，"02"积分商城)
		paymentService.returnPoint(gateWayEnvolopeVo);
	}

	/**
	 * 上送积分系统渠道标志转换
	 * 
	 * @param sourceId
	 * @return
	 */
	private String sourceIdChangeToChannel(String sourceId) {
		if (Contants.SOURCE_ID_MALL.equals(sourceId)) {
			return Contants.SOURCE_ID_MALL_TYPY;
		}
		if (Contants.SOURCE_ID_CC.equals(sourceId)) {
			return Contants.SOURCE_ID_CC_TYPY;
		}
		if (Contants.SOURCE_ID_IVR.equals(sourceId)) {
			return Contants.SOURCE_ID_IVR_TYPY;
		}
		if (Contants.SOURCE_ID_CELL.equals(sourceId)) {
			return Contants.SOURCE_ID_CELL_TYPY;
		}
		if (Contants.SOURCE_ID_MESSAGE.equals(sourceId)) {
			return Contants.SOURCE_ID_MESSAGE_TYPY;
		}
		if (Contants.SOURCE_ID_WX_BANK.equals(sourceId) || Contants.SOURCE_ID_WX_CARD.equals(sourceId)) {
			return Contants.SOURCE_ID_WX_TYPY;
		}
		if (Contants.SOURCE_ID_APP.equals(sourceId)) {
			return Contants.SOURCE_ID_APP_TYPY;
		}
		return Contants.SOURCE_ID_MALL_TYPY;
	}
}
