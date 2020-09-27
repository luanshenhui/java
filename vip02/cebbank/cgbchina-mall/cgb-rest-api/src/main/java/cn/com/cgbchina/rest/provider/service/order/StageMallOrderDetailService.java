package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.StageMallOrderDetail;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderDetailReturn;

/**
 * @author lizy MAL111 订单详细信息查询(分期商城)
 */
public interface StageMallOrderDetailService {
	StageMallOrderDetailReturn detail(StageMallOrderDetail stageMallOrderDetailObj);
}
