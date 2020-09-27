package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.StageMallOrderUpdateService;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderUpdateReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderUpdate;


@Service
public class StageMallOrderUpdateServiceImpl implements StageMallOrderUpdateService {
	@Override
	public StageMallOrderUpdateReturn update(StageMallOrderUpdate stageMallOrderUpdate) {
		return BeanUtils.randomClass(StageMallOrderUpdateReturn.class);
	}

}
