package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.VerificationNotic;
import cn.com.cgbchina.rest.provider.model.order.VerificationNoticReturn;
import cn.com.cgbchina.rest.provider.service.order.VerificationNoticService;
@Service
public class VerificationNoticServiceImpl implements VerificationNoticService {

	@Override
	public VerificationNoticReturn notic(VerificationNotic verificationNotic) {
		return BeanUtils.randomClass(VerificationNoticReturn.class);
	}

}
