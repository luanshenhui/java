package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderUpdate;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderUpdateReturn;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrdersReturn;

/**
 * @author Lizy MAL106 CC积分商城订单修改
 */
public interface CCIntergralOrderUpdateService {
	CCIntergralOrderUpdateReturn update(CCIntergralOrderUpdate ccIntergralOrderUpdateObj);
}
