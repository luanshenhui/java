package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.StageMallOrderCancelorRefund;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderCancelorRefundReturn;

/**
 * @author lizy MAL110 订单撤销退货(分期商城)
 */
public interface StageMallOrderCancelorRefundService {
	StageMallOrderCancelorRefundReturn cancelorRefundorder(
			StageMallOrderCancelorRefund stageMallOrderCancelorRefundObj);
}
