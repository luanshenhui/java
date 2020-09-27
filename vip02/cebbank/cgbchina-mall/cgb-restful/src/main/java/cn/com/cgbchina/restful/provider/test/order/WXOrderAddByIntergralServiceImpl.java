package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.WXOrderAddByIntergralService;
import cn.com.cgbchina.rest.provider.model.order.WXOrderAddByIntergralReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.WXOrderAddByIntergralQuery;


@Service
public class WXOrderAddByIntergralServiceImpl implements WXOrderAddByIntergralService {
	@Override
	public WXOrderAddByIntergralReturn add(WXOrderAddByIntergralQuery wXOrderAddByIntergralQuery) {
		return BeanUtils.randomClass(WXOrderAddByIntergralReturn.class);
	}

}
