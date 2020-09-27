package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.CCVerificationCodeService;
import cn.com.cgbchina.rest.provider.model.order.CCVerificationCodeReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.CCVerificationCodeQuery;


@Service
public class CCVerificationCodeServiceImpl implements CCVerificationCodeService {
	@Override
	public CCVerificationCodeReturn getCCVerificationCode(CCVerificationCodeQuery cCVerificationCodeQuery) {
		CCVerificationCodeReturn res=  BeanUtils.randomClass(CCVerificationCodeReturn.class);
		res.setResultCode("0");
		res.setResultMsg(" conntect test  ok");
		 return res;
	}

}
