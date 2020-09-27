package cn.com.cgbchina.restful.provider.test.order;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.order.AppStageMallPayVerificationService;
import cn.com.cgbchina.rest.provider.model.order.AppStageMallPayVerificationReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.AppStageMallPayVerification;


@Service
public class AppStageMallPayVerificationServiceImpl implements AppStageMallPayVerificationService {
	@Override
	public AppStageMallPayVerificationReturn Verification(AppStageMallPayVerification appStageMallPayVerification) {
		return BeanUtils.randomClass(AppStageMallPayVerificationReturn.class);
	}

}
