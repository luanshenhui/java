package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.CCIntergralOrdersQueryService;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrdersReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrdersQuery;


@Service
public class CCIntergralOrdersQueryServiceImpl implements CCIntergralOrdersQueryService {
	@Override
	public CCIntergralOrdersReturn query(CCIntergralOrdersQuery cCIntergralOrdersQuery) {
		return BeanUtils.randomClass(CCIntergralOrdersReturn.class);
	}

}
