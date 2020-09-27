package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.CCAddOrderByCgbAdd;
import cn.com.cgbchina.rest.provider.model.order.CCAddOrderByCgbAddReturn;

/**
 * MAL115 CC广发下单
 * 
 * @author lizy 2016/4/28.
 */
public interface CCAddOrderByCgbService {
	CCAddOrderByCgbAddReturn add(CCAddOrderByCgbAdd ccAddOrderByCgbAddObject);
}
