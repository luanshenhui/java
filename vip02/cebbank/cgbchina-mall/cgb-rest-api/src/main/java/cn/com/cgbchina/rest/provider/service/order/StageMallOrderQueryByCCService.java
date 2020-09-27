package cn.com.cgbchina.rest.provider.service.order;

import cn.com.cgbchina.rest.provider.model.order.StageMallOrderQueryByCC;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderQueryByCCReturn;

/**
 * @author lizy MAL113 订单信息查询(分期商城)
 */
public interface StageMallOrderQueryByCCService {
	StageMallOrderQueryByCCReturn query(StageMallOrderQueryByCC stageMallOrderQueryByCCObj);
}
