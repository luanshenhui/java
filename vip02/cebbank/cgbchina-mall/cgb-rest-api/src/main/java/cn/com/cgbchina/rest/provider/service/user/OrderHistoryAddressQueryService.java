package cn.com.cgbchina.rest.provider.service.user;

import cn.com.cgbchina.rest.provider.model.user.OrderHistoryAddressQuery;
import cn.com.cgbchina.rest.provider.model.user.OrderHistoryAddressQueryReturn;

/**
 * 2016/4/27. MAL114 订单历史地址信息查询
 * 
 * @author lizy
 *
 */
public interface OrderHistoryAddressQueryService {
	OrderHistoryAddressQueryReturn query(OrderHistoryAddressQuery orderHistoryAddressQueryObj);
}
