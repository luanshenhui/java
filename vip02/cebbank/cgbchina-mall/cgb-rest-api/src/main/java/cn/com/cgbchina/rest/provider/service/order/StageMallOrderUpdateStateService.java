package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.StageMallOrderUpdateState;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderUpdateStateRetrun;

/**
 * MAL112 订单状态修改(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public interface StageMallOrderUpdateStateService {
	StageMallOrderUpdateStateRetrun update(StageMallOrderUpdateState stageMallOrderUpdateStateObj);
}
