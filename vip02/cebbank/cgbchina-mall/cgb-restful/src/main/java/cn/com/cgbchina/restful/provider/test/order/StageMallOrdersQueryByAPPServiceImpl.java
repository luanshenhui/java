package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.StageMallOrdersQueryByAPPService;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrdersQueryByAPPReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrdersQueryByAPP;


@Service
public class StageMallOrdersQueryByAPPServiceImpl implements StageMallOrdersQueryByAPPService {
	@Override
	public StageMallOrdersQueryByAPPReturn query(StageMallOrdersQueryByAPP stageMallOrdersQueryByAPP) {
		return BeanUtils.randomClass(StageMallOrdersQueryByAPPReturn.class);
	}

}
