package cn.com.cgbchina.restful.provider.test.coupon;

import org.springframework.stereotype.Service;
import cn.com.cgbchina.rest.provider.service.coupon.PrivilegeTypeQueryService;
import cn.com.cgbchina.rest.provider.model.coupon.PrivilegeTypeQueryReturn;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.coupon.PrivilegeTypeQuery;


@Service
public class PrivilegeTypeQueryServiceImpl implements PrivilegeTypeQueryService {
	@Override
	public PrivilegeTypeQueryReturn query(PrivilegeTypeQuery privilegeTypeQuery) {
		return BeanUtils.randomClass(PrivilegeTypeQueryReturn.class);
	}

}
