package cn.com.cgbchina.restful.provider.test.user;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.user.CustInfoQueryService;
import cn.com.cgbchina.rest.provider.model.user.CustInfoQueryReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.user.CustInfo;


@Service
public class CustInfoQueryServiceImpl implements CustInfoQueryService {
	@Override
	public CustInfoQueryReturn query(CustInfo custInfo) {
		return BeanUtils.randomClass(CustInfoQueryReturn.class);
	}

}
