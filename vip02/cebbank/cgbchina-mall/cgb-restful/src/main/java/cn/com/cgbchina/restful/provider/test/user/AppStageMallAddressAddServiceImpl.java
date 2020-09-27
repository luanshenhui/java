package cn.com.cgbchina.restful.provider.test.user;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.user.AppStageMallAddressAddService;
import cn.com.cgbchina.rest.provider.model.user.AppStageMallAddressAddReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.user.AppStageMallAddressAdd;


@Service
public class AppStageMallAddressAddServiceImpl implements AppStageMallAddressAddService {
	@Override
	public AppStageMallAddressAddReturn add(AppStageMallAddressAdd appStageMallAddressAdd) {
		return BeanUtils.randomClass(AppStageMallAddressAddReturn.class);
	}

}
