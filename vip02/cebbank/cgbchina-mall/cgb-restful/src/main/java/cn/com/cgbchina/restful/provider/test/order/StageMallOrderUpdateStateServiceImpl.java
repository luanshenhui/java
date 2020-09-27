package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.StageMallOrderUpdateStateService;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderUpdateStateRetrun;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderUpdateState;


@Service
public class StageMallOrderUpdateStateServiceImpl implements StageMallOrderUpdateStateService {
	@Override
	public StageMallOrderUpdateStateRetrun update(StageMallOrderUpdateState stageMallOrderUpdateState) {
		return BeanUtils.randomClass(StageMallOrderUpdateStateRetrun.class);
	}

}
