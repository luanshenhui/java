package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.AppIntergralAddOrderService;
import cn.com.cgbchina.rest.provider.model.order.AppIntergralAddOrderReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.AppIntergralAddOrder;


@Service
public class AppIntergralAddOrderServiceImpl implements AppIntergralAddOrderService {
	@Override
	public AppIntergralAddOrderReturn add(AppIntergralAddOrder appIntergralAddOrder) {
		return BeanUtils.randomClass(AppIntergralAddOrderReturn.class);
	}

}
