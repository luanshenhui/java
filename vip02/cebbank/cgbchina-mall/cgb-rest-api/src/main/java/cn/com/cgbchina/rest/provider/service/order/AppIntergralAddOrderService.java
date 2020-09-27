package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.AppIntergralAddOrder;
import cn.com.cgbchina.rest.provider.model.order.AppIntergralAddOrderReturn;

/**
 * MAL314 下单接口(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public interface AppIntergralAddOrderService {
	AppIntergralAddOrderReturn add(AppIntergralAddOrder order);
}
