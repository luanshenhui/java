package cn.com.cgbchina.restful.provider.test.user;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.user.OrderHistoryAddressQueryService;
import cn.com.cgbchina.rest.provider.model.user.OrderHistoryAddressQueryReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.user.OrderHistoryAddressQuery;


@Service
public class OrderHistoryAddressQueryServiceImpl implements OrderHistoryAddressQueryService {
	@Override
	public OrderHistoryAddressQueryReturn query(OrderHistoryAddressQuery orderHistoryAddressQuery) {
		return BeanUtils.randomClass(OrderHistoryAddressQueryReturn.class);
	}

}
