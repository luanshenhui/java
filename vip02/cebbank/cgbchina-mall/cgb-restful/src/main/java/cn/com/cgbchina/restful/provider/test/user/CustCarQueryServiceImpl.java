package cn.com.cgbchina.restful.provider.test.user;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.user.CustCarQueryService;
import cn.com.cgbchina.rest.provider.model.user.CustCarQueryReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.user.CustCarQuery;


@Service
public class CustCarQueryServiceImpl implements CustCarQueryService {
	@Override
	public CustCarQueryReturn query(CustCarQuery custCarQuery) {
		return BeanUtils.randomClass(CustCarQueryReturn.class);
	}

}
