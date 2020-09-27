package cn.com.cgbchina.rest.visit.test.point;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.utils.TestClass;
import cn.com.cgbchina.rest.visit.model.BaseResult;
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

/**
 * Comment: Created by 11150321050126 on 2016/5/8.
 */
@Service
public class PaymentServiceImpl implements PaymentService {

	@Override
	public PaymentRequeryResult paymentRequery(PaymentRequeryInfo info) {
		return TestClass.debugMethod(PaymentRequeryResult.class);
	}

	@Override
	public DeliverOrderInfoResult orderDeliveryInfoNotify(
			NotifyOrderDelivery notify) {
		return TestClass.debugMethod(DeliverOrderInfoResult.class);
	}

	@Override
	public BaseResult luckPackReturn(Orderluck orderId) {
		return TestClass.debugMethod(BaseResult.class);
	}

	@Override
	public BaseResult ccPointsPay(CCPointsPay pay) {
		return TestClass.debugMethod(BaseResult.class);
	}

	@Override
	public BaseResult reqMoney(ReqMoneyInfo info) {
		return TestClass.debugMethod(BaseResult.class);
	}

	@Override
	public BaseResult returnGoods(ReturnGoodsInfo info) {
		return TestClass.debugMethod(BaseResult.class);
	}

	@Override
	public BaseResult returnPoint(ReturnPointsInfo info) {
		return TestClass.debugMethod(BaseResult.class);
	}

	@Override
	public BaseResult pointsMallReqMoney(PointsMallReqMoneyInfo info) {
		return TestClass.debugMethod(BaseResult.class);

	}

	@Override
	public BaseResult pointsMallReturnGoods(PointsMallReturnGoodsInfo info) {
		return TestClass.debugMethod(BaseResult.class);
	}

	@Override
	public ChannelPayResult channelPay(ChannelPayInfo info) {
		return TestClass.debugMethod(ChannelPayResult.class);
	}
}
