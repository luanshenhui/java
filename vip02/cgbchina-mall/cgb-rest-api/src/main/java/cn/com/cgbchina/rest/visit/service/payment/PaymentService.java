package cn.com.cgbchina.rest.visit.service.payment;

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

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public interface PaymentService {
	PaymentRequeryResult paymentRequery(PaymentRequeryInfo info);

	DeliverOrderInfoResult orderDeliveryInfoNotify(NotifyOrderDelivery notify);

	BaseResult luckPackReturn(Orderluck orderId);

	CCPointResult ccPointsPay(CCPointsPay pay);

	BaseResult reqMoney(ReqMoneyInfo info);

	BaseResult returnGoods(ReturnGoodsInfo info);

	BaseResult returnPoint(ReturnPointsInfo info);

	BaseResult pointsMallReqMoney(PointsMallReqMoneyInfo info);

	BaseResult pointsMallReturnGoods(PointsMallReturnGoodsInfo info);

	ChannelPayResult channelPay(ChannelPayInfo info);
}
