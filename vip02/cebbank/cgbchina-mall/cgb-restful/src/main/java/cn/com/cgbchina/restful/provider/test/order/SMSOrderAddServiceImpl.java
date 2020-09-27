package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.SMSOrderAddService;
import cn.com.cgbchina.rest.provider.model.order.SMSOrderAddReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.SMSOrderAdd;


@Service
public class SMSOrderAddServiceImpl implements SMSOrderAddService {
	@Override
	public SMSOrderAddReturn add(SMSOrderAdd sMSOrderAdd) {
		return BeanUtils.randomClass(SMSOrderAddReturn.class);
	}

}
