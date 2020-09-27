package cn.com.cgbchina.restful.provider.test.user;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.user.CustCarAddService;
import cn.com.cgbchina.rest.provider.model.user.CustCarAddReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.user.CustCarAdd;


@Service
public class CustCarAddServiceImpl implements CustCarAddService {
	@Override
	public CustCarAddReturn add(CustCarAdd custCarAdd) {
		return BeanUtils.randomClass(CustCarAddReturn.class);
	}

}
