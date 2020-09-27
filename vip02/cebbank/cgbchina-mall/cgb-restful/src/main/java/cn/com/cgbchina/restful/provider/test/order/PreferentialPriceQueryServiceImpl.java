package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.PreferentialPriceQueryService;
import cn.com.cgbchina.rest.provider.model.order.PreferentialPriceRetrun;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.PreferentialPrice;


@Service
public class PreferentialPriceQueryServiceImpl implements PreferentialPriceQueryService {
	@Override
	public PreferentialPriceRetrun query(PreferentialPrice preferentialPrice) {
		return BeanUtils.randomClass(PreferentialPriceRetrun.class);
	}

}
