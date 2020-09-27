package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.CCAddOrderByCgbService;
import cn.com.cgbchina.rest.provider.model.order.CCAddOrderByCgbAddReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.CCAddOrderByCgbAdd;


@Service
public class CCAddOrderByCgbServiceImpl implements CCAddOrderByCgbService {
	@Override
	public CCAddOrderByCgbAddReturn add(CCAddOrderByCgbAdd cCAddOrderByCgbAdd) {
		return BeanUtils.randomClass(CCAddOrderByCgbAddReturn.class);
	}

}
