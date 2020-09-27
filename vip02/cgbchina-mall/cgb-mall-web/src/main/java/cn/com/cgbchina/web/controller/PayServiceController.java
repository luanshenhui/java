package cn.com.cgbchina.web.controller;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.service.ItemIndexService;
import cn.com.cgbchina.log.model.MessageLogModel;
import cn.com.cgbchina.log.service.MessageLogService;
import cn.com.cgbchina.rest.common.constants.Constant;
import cn.com.cgbchina.trade.dto.*;
import cn.com.cgbchina.trade.service.OrderCheckService;
import cn.com.cgbchina.trade.service.OrderDealService;
import cn.com.cgbchina.trade.service.SmsMessageService;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import com.spirit.redis.JedisTemplate;
import com.spirit.redis.utils.DistributedLocks;
import com.spirit.util.JsonMapper;
import com.spirit.web.MessageSources;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * 支付网关支付返回报文后的处理流程
 *
 * @author shangqb
 * @version 2016年6月27日 下午15:00:00
 */
@Slf4j
@Controller
@RequestMapping("/pay")
public class PayServiceController {

	@Autowired
	private OrderDealService orderDealService;

	@Autowired
	private SmsMessageService smsMessageService;

	@Autowired
	private MessageSources messageSources;

	@Autowired
	ItemIndexService itemIndexService;
	@Resource
	private OrderCheckService orderCheckService;
	@Value("#{app.orderResult}")
	private String orderResult;
	@Resource
	private MessageLogService messageLogService;
	@Autowired
	private JedisTemplate jedisTemplate;
	private ExecutorService threadPool=Executors.newFixedThreadPool(Constant.THREAD_NUM);
	private JsonMapper jsonMapper=JsonMapper.nonDefaultMapper();
	@RequestMapping(value = "/dealPay", method = RequestMethod.POST)
	public String dealPay(HttpServletRequest request, HttpServletResponse response) {
		log.info("支付dealPay 开始:" + DateHelper.getCurrentTime() + request.getParameterMap());
		Response<DealPayResult> orderDealDto = null;
		try {
			String orderid = this.getTrimValue(request.getParameter("orderid")); // 订单号
			String payAccountNo = this.getTrimValue(request.getParameter("payAccountNo"));// 支付账号
			String cardType = this.getTrimValue(request.getParameter("cardType"));// 卡类型
			String orders = this.getTrimValue(request.getParameter("orders"));// 订单信息串
			String crypt = this.getTrimValue(request.getParameter("crypt"));// 签名
			String sendTime = this.getTrimValue(request.getParameter("sendTime"));// 支付时间
			if (Strings.isNullOrEmpty(sendTime)) {
				sendTime = this.getTrimValue(request.getParameter("payTime"));// 支付时间
			}
			PayOrderInfoDto payOrderInfoDto = new PayOrderInfoDto();
			payOrderInfoDto.setOrderid(orderid);
			payOrderInfoDto.setPayAccountNo(payAccountNo);
			payOrderInfoDto.setCardType(cardType);
			payOrderInfoDto.setCrypt(crypt);
			payOrderInfoDto.setSendTime(sendTime);
			final MessageLogModel model=new MessageLogModel();
			model.setSendersn(payOrderInfoDto.getOrderid());
			model.setTradecode(Contants.ONLINE_PAY_MARK);
			model.setReceiverid(Contants.ONLINE_PAY_MARK);
			model.setOpertime(new Date());
			model.setSendflag(Constant.RECEIVE_FLG);
			model.setMessagecontent(jsonMapper.toJson(request.getParameterMap()));
			threadPool.execute(new Runnable() {
				public void run() {
					messageLogService.insertMessageLog(model);
				}
			});
			log.info("\n************ e-payment response info start ************\norderid:{}\npayAccountNo:{}\ncardType:{}\norders:{}\ncrypt:{}\npayTime:{}\n************ e-payment response info end ************\n", orderid, payAccountNo, cardType, orders, crypt,
					sendTime);
			if (orderid == null || payAccountNo == null || cardType == null || orders == null || crypt == null) {
				response.sendRedirect(getReturnUrl(2,null));
			}
			// 验签 String
			String singGene = orderid + "|" + payAccountNo + "|" + cardType + "|" + orders;
			// SHA加密
			try {
				boolean isCrypt = orderCheckService.verify_md(singGene, crypt);
				if (isCrypt == false) {// 如果验签失败
					log.info("验签出错");
					response.sendRedirect(getReturnUrl(8, null));
					return null;
				}
			} catch (Exception e) {
				log.error("验签出错, error:{}", Throwables.getStackTraceAsString(e));
				response.sendRedirect(getReturnUrl(8, null));
				return null;
			}

			Boolean isParse = parseOrders(orders, payOrderInfoDto);// 解析子订单信息
			if (!isParse) {
				response.sendRedirect(getReturnUrl(2,null));
			}
			log.info("调用支付回调接口");
			payOrderInfoDto.setIsPayment(true);
			log.info("回调入参{}",payOrderInfoDto);
			// 获取分布式锁
			String lockId = DistributedLocks.acquireLockWithTimeout(jedisTemplate, "ORDERID" + payOrderInfoDto.getOrderid(), 50, 100000);
			if (lockId == null) {
				log.info("支付网关重复返回结果");
				response.sendRedirect(getReturnUrl(3, null));
				return null;
			}
			orderDealDto = orderDealService.makeOrderTradeInfo(payOrderInfoDto);
			if (orderDealDto.isSuccess()) {
				orderDealDto = orderDealService.dealPay(payOrderInfoDto,
						orderDealDto.getResult().getOrderMainModel(),
						orderDealDto.getResult().getPayOrderIfDtos());
			}
			DistributedLocks.releaseLock(jedisTemplate, "ORDERID" + payOrderInfoDto.getOrderid(), lockId);
			log.info("调用结束:{}", orderDealDto.getResult());

			OrderDealDto resData = orderDealDto.getResult().getOrderDealDto();
			if (resData != null) { // 如果ejb返回数据不为空
				// 商品上架 创建单品索引 end
				String retcode = resData.getRetcode();
				String errorCode = resData.getErrorCode();
				String orderType = resData.getOrderType();
				String sucessFlag = resData.getSucessFlag();
				if (sucessFlag == null || "".equals(sucessFlag.trim())) {
					sucessFlag = "0";
				}
				log.info("errorCode:{}", errorCode);
				if ("3333".equals(errorCode)) {// 如果是支付网关重复返回结果
					log.info("支付网关重复返回结果");
					response.sendRedirect(getReturnUrl(3,null));
				} else if ("YG".equals(orderType)) {// 一期
					log.info("一次性支付处理");
					if ("0".equals(retcode) && "0000".equals(errorCode)) {// 如果订单处理正常
						log.info("订单处理正常");
						if ("0".equals(sucessFlag.trim())) {
							log.info("支付成功");
							response.sendRedirect(getReturnUrl(1,null));
						} else if ("1".equals(sucessFlag.trim())) {
							log.info("支付失败");
							response.sendRedirect(getReturnUrl(2,null));
						} else if ("7".equals(sucessFlag.trim())) {
							log.info("支付状态未明");
							response.sendRedirect(getReturnUrl(3,null));
						} else {
							log.info("支付部分成功");
							response.sendRedirect(getReturnUrl(6,null));
						}
					} else {// 支付失败
						log.info("订单处理异常");
						response.sendRedirect(getReturnUrl(2,null));
					}
				} else if ("FQ".equals(orderType)) {// 分期
					log.info("分期支付处理");
					if ("0".equals(retcode) && "0000".equals(errorCode)) {// 如果订单处理正常
						log.info("订单处理正常");
						if ("0".equals(sucessFlag.trim())) { // 全部订单成功
							log.info("全部订单成功");
							response.sendRedirect(getReturnUrl(1,null));
						} else if ("1".equals(sucessFlag.trim())) { // 全部子订单失败
							log.info("全部子订单失败");
							response.sendRedirect(getReturnUrl(2,null));
						} else if ("3".equals(sucessFlag.trim())) { // 如果全部子订单处理中
							log.info("全部子订单处理中");
							response.sendRedirect(getReturnUrl(4,null));
						} else if ("2".equals(sucessFlag.trim())) { // 如果部分成功、部分失败、部分处理中
							log.info("部分成功、部分失败、部分处理中");
							response.sendRedirect(getReturnUrl(7,null));
						} else if ("4".equals(sucessFlag.trim())) { // 部分成功、部分处理中
							log.info("部分成功、部分处理中");
							response.sendRedirect(getReturnUrl(5,null));
						} else if ("5".equals(sucessFlag.trim())) { // 部分成功、部分失败
							log.info("部分成功、部分失败");
							response.sendRedirect(getReturnUrl(6,null));
						} else if ("6".equals(sucessFlag.trim())) { // 部分处理中、部分失败
							log.info("部分处理中、部分失败");
							response.sendRedirect(getReturnUrl(7,null));
						} else if ("7".equals(sucessFlag.trim())) { // 状态未明
							log.info("状态未明");
							response.sendRedirect(getReturnUrl(3,null));
						}
					} else {// 支付失败
						log.info("订单处理异常");
						response.sendRedirect(getReturnUrl(2,null));
					}
				} else if ("JF".equals(orderType)) {// 积分
					log.info("积分支付处理");
					if ("0".equals(retcode) && "0000".equals(errorCode)) {// 如果订单处理正常
						log.info("订单处理正常");
						if ("0".equals(sucessFlag.trim())) {
							log.info("支付成功");
							if(Contants.GOODS_TYPE_ID_01.equals(orderDealDto.getResult().getGoodsType())){
								response.sendRedirect(getReturnUrl(9,orderDealDto.getResult().getGoodsName()));
							}else{
								response.sendRedirect(getReturnUrl(11,orderDealDto.getResult().getGoodsName()));
							}

						} else if ("1".equals(sucessFlag.trim())) {
							log.info("支付失败");
							response.sendRedirect(getReturnUrl(10,null));
						} else if ("7".equals(sucessFlag.trim())) {
							log.info("支付状态未明");
							response.sendRedirect(getReturnUrl(3,null));
						} else {
							log.info("支付部分成功");
							response.sendRedirect(getReturnUrl(6,null));
						}
					} else {// 支付失败
						log.info("订单处理异常");
						response.sendRedirect(getReturnUrl(2,null));
					}
				} else {
					response.sendRedirect(getReturnUrl(2,null));
				}
			}
			sendMsg(resData); // 发送短信
		} catch (Exception e) {
			log.error("pay.state.fail,{}", Throwables.getStackTraceAsString(e));
		}
		return null;
	}

	private String getReturnUrl(int type,String productName){
		String url=orderResult+"?type="+type;
		try {
			return Strings.isNullOrEmpty(productName)?url:url+"&productName="+ URLEncoder.encode(productName,"UTF-8");
		} catch (UnsupportedEncodingException e) {
			throw new RuntimeException(e); 
		}
	}

	/**
	 * 根据子订单拼xml报文
	 *
	 * @throws Exception
	 */
	private boolean parseOrders(String orders, PayOrderInfoDto payOrderInfoDto) throws Exception {
		log.info("进入parseOrders,子订单信息:{}", orders);
		if (orders == null || "".equals(orders)) {
			log.error("pay.orders.null,{}", messageSources.get("pay.orders.null"));
			return false;
		}
		String orderArray[] = orders.split("\\|");
		if (orderArray.length % 4 != 0) {// 如果除以5余数不为0
			log.error("pay.orders.error,{}", messageSources.get("pay.orders.error"));
			return false;
		}
		List<PayOrderSubDto> payOrderSubDtoList = new ArrayList<PayOrderSubDto>();
		for (int i = 0; i < orderArray.length; i = i + 4) {
			PayOrderSubDto payOrderSubDto = new PayOrderSubDto();
			payOrderSubDto.setVendor_id(orderArray[i]);
			payOrderSubDto.setOrder_id(orderArray[i + 1]);
			payOrderSubDto.setMoney(orderArray[i + 2]);
			payOrderSubDto.setReturnCode(orderArray[i + 3]);
			payOrderSubDtoList.add(payOrderSubDto);
		}
		payOrderInfoDto.setPayOrderSubDtoList(payOrderSubDtoList);
		return true;
	}

	/**
	 * 返回s的trim值，如果s为空，则返回空
	 *
	 * @param s
	 */
	public static String getTrimValue(String s) {
		if (s == null) {
			return null;
		} else {
			return s.trim();
		}
	}

	/**
	 * 发短信
	 *
	 * @param orderDealDto
	 */
	private void sendMsg(OrderDealDto orderDealDto) {
		try {
			if (orderDealDto != null) {
				String orderType = orderDealDto.getOrderType();
				String phone = orderDealDto.getPhone();
				if (phone == null || "".equals(phone.trim())) {// 如果手机号为空，不发短信
					log.info("手机号为空，不发短信");
					return;
				}
				if (orderType == null || "".equals(orderType.trim())) {
					return;
				} else if ("JF".equals(orderType.trim())) {// 积分
					String payResult = orderDealDto.getPayResult();// 支付结果 1:支付成功
					String messageFlag = orderDealDto.getMessageFlag();// 发送短信模板标志
					double money = Double.parseDouble(orderDealDto.getMoney());// 钱
					long point = Long.parseLong(orderDealDto.getBonus_totalvalue());// 积分

					if ("1".equals(payResult)) {// 如果支付成功
						smsMessageService.sendJFSMSMessage(point, money, phone, messageFlag);
					}
				} else if ("YG".equals(orderType.trim())) {// 乐购
					// else if("YG".equals(orderType.trim())||"FQ".equals(orderType.trim())){//乐购
					List<OrderDealPayResultDto> orderNodes = orderDealDto.getOrderList();// 订单
					for (OrderDealPayResultDto orderDealPayResultDto : orderNodes) {
						int amountall = orderNodes.size();// 总件数
						int amountsuc = 0;// 成功受理件数
						int amounterrMoney = 0;// 因为余额不足而失败信用卡的支付件数的件数
						String payResult = orderDealPayResultDto.getPayResult();// 支付结果 1:支付成功
						if ("1".equals(payResult)) {// 如果支付成功
							amountsuc++;
						} else {
							String cardType = orderDealPayResultDto.getCardType();// 卡类型 C：信用卡 Y：借记卡
							String errorCode = orderDealPayResultDto.getErrorCode();// 错误码
							if (cardType != null && "C".equals(cardType) && errorCode != null
									&& "vvvvvvv".equals(errorCode)) {
								amounterrMoney++;
							}
						}
						smsMessageService.sendLGSucess(amountall, amountsuc, phone);
						if (amounterrMoney != 0) {
							// sMSMessage.sendLGErr(amounterrMoney, phone);//发失败短信
						}
					}
				}
			}
		} catch (Exception e) {
			log.error("pay.orders.error,{}", messageSources.get("sms.state.fail"));
		}
	}
}
