package cn.com.cgbchina.restful.provider.test.user;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.user.AddressDelService;
import cn.com.cgbchina.rest.provider.model.user.AddressDelReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.user.AddressDel;


@Service
public class AddressDelServiceImpl implements AddressDelService {
	@Override
	public AddressDelReturn del(AddressDel addressDel) {
		return BeanUtils.randomClass(AddressDelReturn.class);
	}

}
