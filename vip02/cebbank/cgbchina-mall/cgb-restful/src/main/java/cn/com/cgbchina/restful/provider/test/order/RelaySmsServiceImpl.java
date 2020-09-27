package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.RelaySmsReturn;
import cn.com.cgbchina.rest.provider.model.order.SmsInfo;
import cn.com.cgbchina.rest.provider.service.order.RelaySmsService;
@Service
public class RelaySmsServiceImpl implements RelaySmsService {

	@Override
	public RelaySmsReturn RelaySms(SmsInfo smsInfo) {
		return BeanUtils.randomClass(RelaySmsReturn.class);
	}

}
