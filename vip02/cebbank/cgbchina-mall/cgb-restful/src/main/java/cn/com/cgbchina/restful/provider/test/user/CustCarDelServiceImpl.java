package cn.com.cgbchina.restful.provider.test.user;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.user.CustCarDelService;
import cn.com.cgbchina.rest.provider.model.user.CustCarDelReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.user.CustCarDel;


@Service
public class CustCarDelServiceImpl implements CustCarDelService {
	@Override
	public CustCarDelReturn del(CustCarDel custCarDel) {
		return BeanUtils.randomClass(CustCarDelReturn.class);
	}

}
