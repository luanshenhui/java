package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.StageMallOrderQueryByCCService;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderQueryByCCReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.StageMallOrderQueryByCC;


@Service
public class StageMallOrderQueryByCCServiceImpl implements StageMallOrderQueryByCCService {
	@Override
	public StageMallOrderQueryByCCReturn query(StageMallOrderQueryByCC stageMallOrderQueryByCC) {
		return BeanUtils.randomClass(StageMallOrderQueryByCCReturn.class);
	}

}
