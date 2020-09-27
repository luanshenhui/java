package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.StageMallOrdersDetailByAPPQuery;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrdersDetailByAPPReturn;

/**
 * MAL309 订单详细信息查询(分期商城)App
 * 
 * @author Lizy
 *
 */
public interface StageMallOrdersDetailByAPPService {
	StageMallOrdersDetailByAPPReturn detail(StageMallOrdersDetailByAPPQuery stageMallOrdersDetailQueryByAPP);
}
