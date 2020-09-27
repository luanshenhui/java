package cn.com.cgbchina.restful.provider.test.user;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.user.CustCarUpdateService;
import cn.com.cgbchina.rest.provider.model.user.CustCarUpdateReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.user.CustCarUpdate;


@Service
public class CustCarUpdateServiceImpl implements CustCarUpdateService {
	@Override
	public CustCarUpdateReturn update(CustCarUpdate custCarUpdate) {
		return BeanUtils.randomClass(CustCarUpdateReturn.class);
	}

}
