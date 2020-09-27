package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.StageMallOrdersQueryByAPP;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrdersQueryByAPPReturn;

/**
 * MAL308 订单查询(分期商城)
 * 
 * @author Lizy
 *
 */
public interface StageMallOrdersQueryByAPPService {
	StageMallOrdersQueryByAPPReturn query(StageMallOrdersQueryByAPP stageMallOrdersQueryByAPPObj);
}
