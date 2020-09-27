package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.StageMallOrderUpdate;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderUpdateReturn;

/**
 * @author lizy MAL109 订单修改(分期商城)
 */
public interface StageMallOrderUpdateService {
	StageMallOrderUpdateReturn update(StageMallOrderUpdate stageMallOrderUpdateObj);
}
