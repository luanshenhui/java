package cn.com.cgbchina.restful.provider.test.user;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.user.AppStageMallAddressQueryService;
import cn.com.cgbchina.rest.provider.model.user.AppStageMallAddressReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.user.AppStageMallAddressQuery;


@Service
public class AppStageMallAddressQueryServiceImpl implements AppStageMallAddressQueryService {
	@Override
	public AppStageMallAddressReturn query(AppStageMallAddressQuery appStageMallAddressQuery) {
		return BeanUtils.randomClass(AppStageMallAddressReturn.class);
	}

}
