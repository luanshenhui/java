package cn.com.cgbchina.restful.provider.test.payment;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderUpdateReturn;
import cn.com.cgbchina.rest.provider.model.payment.WXPay;
import cn.com.cgbchina.rest.provider.model.payment.WXPayReturn;
import cn.com.cgbchina.rest.provider.service.payment.WXPayService;
/**
 * MAL503	微信发起支付接口
 * @author lizy
 *         2016/4/28.
 */
@Service
public class WXPayServiceImpl implements WXPayService {

	@Override
	public WXPayReturn pay(WXPay wxPay) {
		return BeanUtils.randomClass(WXPayReturn.class);
	}

}
