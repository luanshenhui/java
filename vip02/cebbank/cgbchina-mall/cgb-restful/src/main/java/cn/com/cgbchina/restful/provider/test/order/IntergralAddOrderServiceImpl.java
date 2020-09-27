package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.IntergralAddOrderService;
import cn.com.cgbchina.rest.provider.model.order.IntergralAddOrderReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.IntergralAddOrder;


@Service
public class IntergralAddOrderServiceImpl implements IntergralAddOrderService {
	@Override
	public IntergralAddOrderReturn add(IntergralAddOrder intergralAddOrder) {
		return BeanUtils.randomClass(IntergralAddOrderReturn.class);
	}

}
