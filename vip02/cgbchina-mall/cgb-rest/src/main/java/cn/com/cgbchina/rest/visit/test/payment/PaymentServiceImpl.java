package cn.com.cgbchina.rest.visit.test.payment;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.payment.CCPointResult;
import cn.com.cgbchina.rest.visit.model.payment.CCPointsPay;
import cn.com.cgbchina.rest.visit.model.payment.ChannelPayInfo;
import cn.com.cgbchina.rest.visit.model.payment.ChannelPayResult;
import cn.com.cgbchina.rest.visit.model.payment.DeliverOrderInfoResult;
import cn.com.cgbchina.rest.visit.model.payment.NotifyOrderDelivery;
import cn.com.cgbchina.rest.visit.model.payment.Orderluck;
import cn.com.cgbchina.rest.visit.model.payment.PaymentRequeryInfo;
import cn.com.cgbchina.rest.visit.model.payment.PaymentRequeryResult;
import cn.com.cgbchina.rest.visit.model.payment.PointsMallReqMoneyInfo;
import cn.com.cgbchina.rest.visit.model.payment.PointsMallReturnGoodsInfo;
import cn.com.cgbchina.rest.visit.model.payment.ReqMoneyInfo;
import cn.com.cgbchina.rest.visit.model.payment.ReturnGoodsInfo;
import cn.com.cgbchina.rest.visit.model.payment.ReturnPointsInfo;
import cn.com.cgbchina.rest.visit.service.payment.PaymentService;
import lombok.extern.slf4j.Slf4j;

/**
 * Comment: Created by 11150321050126 on 2016/5/8.
 */
@Service
@Slf4j
public class PaymentServiceImpl implements PaymentService {

	@Override
	public PaymentRequeryResult paymentRequery(PaymentRequeryInfo info) {
		return null;
	}

	@Override
	public DeliverOrderInfoResult orderDeliveryInfoNotify(NotifyOrderDelivery notify) {
		return null;
	}

	@Override
	public BaseResult luckPackReturn(Orderluck orderId) {
		return null;
	}

	@Override
	public CCPointResult ccPointsPay(CCPointsPay pay) {
		return null;
	}

	@Override
	public BaseResult reqMoney(ReqMoneyInfo info) {
		return null;
	}

	@Override
	public BaseResult returnGoods(ReturnGoodsInfo info) {
		return null;
	}

	@Override
	public BaseResult returnPoint(ReturnPointsInfo info) {
		return null;
	}

	@Override
	public BaseResult pointsMallReqMoney(PointsMallReqMoneyInfo info) {
		return null;
	}

	@Override
	public BaseResult pointsMallReturnGoods(PointsMallReturnGoodsInfo info) {
		return null;
	}

	@Override
	public ChannelPayResult channelPay(ChannelPayInfo info) {
		return null;
	}
}
