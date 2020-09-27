package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.IntergrallPayVerificationService;
import cn.com.cgbchina.rest.provider.model.order.IntergrallPayVerification;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.IntergrallPayVerificationReturn;


@Service
public class IntergrallPayVerificationServiceImpl implements IntergrallPayVerificationService {
 
	@Override
	public IntergrallPayVerificationReturn Verification(IntergrallPayVerification intergrallPayVerification) {
		return BeanUtils.randomClass(IntergrallPayVerificationReturn.class);
	}

}
