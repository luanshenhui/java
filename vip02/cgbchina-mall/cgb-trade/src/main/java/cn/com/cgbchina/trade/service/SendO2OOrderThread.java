package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.trade.vo.SystemEnvelopeVo;
import com.spirit.common.model.Response;

/**
 * 发送O2O订单线程
 *
 */
public class SendO2OOrderThread extends Thread {

//	SystemEnvelopeVo systemEnvelopeVo = new SystemEnvelopeVo();

	// 大订单号
	private String orderMainId = "";
	// 小订单号
	private String orderId = "";

	private OrderSendForO2OService orderSendForO2OService;

	public SendO2OOrderThread(OrderSendForO2OService orderSendForO2OService, String orderMainId) {
		this.orderSendForO2OService = orderSendForO2OService;
		this.orderMainId = orderMainId;
	}

	public SendO2OOrderThread(OrderSendForO2OService orderSendForO2OService, String orderMainId, String orderId) {
		this.orderSendForO2OService = orderSendForO2OService;
		this.orderMainId = orderMainId;
		this.orderId = orderId;
	}

	public void run() {
		Response result = new Response();
		result = orderSendForO2OService.orderSendForO2O(orderMainId, orderId);
		// 可能是正式写法
		// SystemEnvelopeVo systemEnvolopeVo = new SystemEnvelopeVo();
		// systemEnvolopeVo.setOrderId(orderMainId);
		// systemEnvolopeVo.setOrderId(orderId);
		// result = orderSendForO2OService.sendO2OOrderProcess(systemEnvolopeVo);
		if (result.isSuccess()) {
			System.out.println("线程执行O2O订单推送接口成功");
		}
		if (!result.isSuccess()) {
			System.out.println("线程执行O2O订单推送接口失败");
		}
	}

}
