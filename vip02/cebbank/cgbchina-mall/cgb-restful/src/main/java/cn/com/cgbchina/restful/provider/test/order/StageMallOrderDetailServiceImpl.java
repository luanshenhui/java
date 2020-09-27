package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.StageMallOrderDetailService;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderDetailReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderDetail;


@Service
public class StageMallOrderDetailServiceImpl implements StageMallOrderDetailService {
	@Override
	public StageMallOrderDetailReturn detail(StageMallOrderDetail stageMallOrderDetail) {
		return BeanUtils.randomClass(StageMallOrderDetailReturn.class);
	}

}
