package cn.com.cgbchina.rest.visit.service.payment;

import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.payment.*;

/**
 * Comment: Created by 11150321050126 on 2016/4/29.
 */
public interface PaymentService {
	PaymentRequeryResult paymentRequery(PaymentRequeryInfo info);

	DeliverOrderInfoResult orderDeliveryInfoNotify(NotifyOrderDelivery notify);

	BaseResult luckPackReturn(Orderluck orderId);

	BaseResult ccPointsPay(CCPointsPay pay);

	BaseResult reqMoney(ReqMoneyInfo info);

	BaseResult returnGoods(ReturnGoodsInfo info);

	BaseResult returnPoint(ReturnPointsInfo info);

	BaseResult pointsMallReqMoney(PointsMallReqMoneyInfo info);

	BaseResult pointsMallReturnGoods(PointsMallReturnGoodsInfo info);

	ChannelPayResult channelPay(ChannelPayInfo info);
}
