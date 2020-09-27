package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.CCIntergralOrderDetailService;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderDetailReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderDetailQuery;


@Service
public class CCIntergralOrderDetailServiceImpl implements CCIntergralOrderDetailService {
	@Override
	public CCIntergralOrderDetailReturn detail(CCIntergralOrderDetailQuery cCIntergralOrderDetailQuery) {
		return BeanUtils.randomClass(CCIntergralOrderDetailReturn.class);
	}

}
