package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.WXYXVerificationCodeService;
import cn.com.cgbchina.rest.provider.model.order.VerificationCodeReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.VerificationCodeQuery;


@Service
public class WXYXVerificationCodeServiceImpl implements WXYXVerificationCodeService {
	@Override
	public VerificationCodeReturn getVerificationCode(VerificationCodeQuery verificationCodeQuery) {
		return BeanUtils.randomClass(VerificationCodeReturn.class);
	}

}
