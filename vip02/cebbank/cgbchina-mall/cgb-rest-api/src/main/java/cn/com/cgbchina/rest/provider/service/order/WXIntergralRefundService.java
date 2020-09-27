package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.WXIntergral;
import cn.com.cgbchina.rest.provider.model.order.WXIntergralRefundReturn;

/**
 * MAL502 微信退积分接口
 * 
 * @author lizy 2016/4/28.
 */
public interface WXIntergralRefundService {
	WXIntergralRefundReturn refund(WXIntergral wxIntergral);
}
