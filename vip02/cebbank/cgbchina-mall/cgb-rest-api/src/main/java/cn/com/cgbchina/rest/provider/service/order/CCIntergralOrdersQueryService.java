package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrdersQuery;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrdersReturn;

/**
 * @author Lizy MAL105 CC积分商城订单列表查询
 */
public interface CCIntergralOrdersQueryService {
	CCIntergralOrdersReturn query(CCIntergralOrdersQuery ccIntergralOrdersQueryObj);
}
