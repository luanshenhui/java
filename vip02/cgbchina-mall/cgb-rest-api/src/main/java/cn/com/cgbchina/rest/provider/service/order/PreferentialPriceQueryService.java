package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.PreferentialPrice;
import cn.com.cgbchina.rest.provider.model.order.PreferentialPriceRetrun;

/**
 * MAL322 获取最优价
 * 
 * @author lizy 2016/4/28.
 */
public interface PreferentialPriceQueryService {
	PreferentialPriceRetrun query(PreferentialPrice PreferentialPrice);
}
