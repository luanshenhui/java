package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.MsgReceipReturn;
import cn.com.cgbchina.rest.provider.model.order.SendCodeInfo;
import cn.com.cgbchina.rest.provider.model.order.SendCodeReturn;
import cn.com.cgbchina.rest.provider.service.order.SendCodeService;
@Service
public class SendCodeServiceImpl implements SendCodeService {

	@Override
	public SendCodeReturn send(SendCodeInfo sendCodeInfo) {
		return BeanUtils.randomClass(SendCodeReturn.class);
	}

}
