package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.SMSOrderAdd;
import cn.com.cgbchina.rest.provider.model.order.SMSOrderAddReturn;

/**
 * MAL401 短信下单接口
 * 
 * @author lizy 2016/4/28.
 */
public interface SMSOrderAddService {
	SMSOrderAddReturn add(SMSOrderAdd smsOrderAdd);
}
