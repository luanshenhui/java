package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.CCAndIVRIntergalOrder;
import cn.com.cgbchina.rest.provider.model.order.CCAndIVRIntergalOrderReturn;

/**
 * @author lizy MAL104 CC/IVR积分商城下单
 */
public interface CCAndIVRIntergralAddOrderService {
	CCAndIVRIntergalOrderReturn add(CCAndIVRIntergalOrder ccAndIVRIntergalOrder);
}
