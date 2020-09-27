package cn.com.cgbchina.restful.provider.test.user;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.user.AddressUpdateService;
import cn.com.cgbchina.rest.provider.model.user.AddressUpdateReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.user.AddressUpdate;


@Service
public class AddressUpdateServiceImpl implements AddressUpdateService {
	@Override
	public AddressUpdateReturn update(AddressUpdate addressUpdate) {
		return BeanUtils.randomClass(AddressUpdateReturn.class);
	}

}
