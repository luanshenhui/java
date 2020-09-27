package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderDetailQuery;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderDetailReturn;

/**
 * @author Lizy MAL108 CC积分商城订单详细信息查询
 */
public interface CCIntergralOrderDetailService {
	CCIntergralOrderDetailReturn detail(CCIntergralOrderDetailQuery ccIntergralOrderDetailQueryObj);
}
