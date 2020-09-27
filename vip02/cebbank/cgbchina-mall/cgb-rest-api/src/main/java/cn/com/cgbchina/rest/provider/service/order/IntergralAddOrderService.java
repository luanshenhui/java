package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.IntergralAddOrder;
import cn.com.cgbchina.rest.provider.model.order.IntergralAddOrderReturn;

/**
 * MAL324 积分商城下单
 * 
 * @author lizy 2016/4/28.
 */
public interface IntergralAddOrderService {
	IntergralAddOrderReturn add(IntergralAddOrder intergralAddOrder);

}
