package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderCancelOrRefund;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderCancelOrRefundReturn;

/**
 * @author Lizy MAL107 CC积分商城撤单和退货
 */
public interface CCIntergralOrderCancelOrRefundService {
	CCIntergralOrderCancelOrRefundReturn cancelOrRefund(
			CCIntergralOrderCancelOrRefund ccIntergralOrderCancelOrRefundObj);
}
