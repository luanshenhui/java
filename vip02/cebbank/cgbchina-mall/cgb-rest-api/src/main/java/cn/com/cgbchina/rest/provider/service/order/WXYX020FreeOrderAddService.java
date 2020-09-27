package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.WXYX020FreeOrderReturn;
import cn.com.cgbchina.rest.provider.model.order.WXYX020FreeOrderQuery;

/**
 * MAL423 微信易信O2O合作商0元秒杀下单
 * 
 * @author lizy 2016/4/28.
 */
public interface WXYX020FreeOrderAddService {
	// WXYX020FreeOrderReturn add (WXYX020FreeOrderQuery freeOrder);
	WXYX020FreeOrderReturn add(WXYX020FreeOrderQuery freeOrder);
}
