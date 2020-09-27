package cn.com.cgbchina.rest.provider.service.payment;

import cn.com.cgbchina.rest.provider.model.payment.WXPay;
import cn.com.cgbchina.rest.provider.model.payment.WXPayReturn;

/**
 * MAL503 微信发起支付接口
 * 
 * @author lizy 2016/4/28.
 */
public interface WXPayService {
	WXPayReturn pay(WXPay wxPay);
}
