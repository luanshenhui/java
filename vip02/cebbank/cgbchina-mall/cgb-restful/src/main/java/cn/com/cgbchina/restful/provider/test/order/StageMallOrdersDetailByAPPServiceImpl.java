package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.StageMallOrdersDetailByAPPService;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrdersDetailByAPPReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrdersDetailByAPPQuery;


@Service
public class StageMallOrdersDetailByAPPServiceImpl implements StageMallOrdersDetailByAPPService {
	@Override
	public StageMallOrdersDetailByAPPReturn detail(StageMallOrdersDetailByAPPQuery stageMallOrdersDetailByAPPQuery) {
		return BeanUtils.randomClass(StageMallOrdersDetailByAPPReturn.class);
	}

}
