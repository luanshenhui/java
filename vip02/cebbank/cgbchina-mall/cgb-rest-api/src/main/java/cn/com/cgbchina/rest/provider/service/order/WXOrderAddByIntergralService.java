package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.WXOrderAddByIntergralQuery;
import cn.com.cgbchina.rest.provider.model.order.WXOrderAddByIntergralReturn;

/**
 * MAL501 微信生成订单接口（积分）
 * 
 * @author lizy 2016/4/28.
 */
public interface WXOrderAddByIntergralService {
	WXOrderAddByIntergralReturn add(WXOrderAddByIntergralQuery wxOrderAddByIntergralQuery);
}
