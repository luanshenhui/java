package cn.com.cgbchina.rest.provider.service.coupon;

import cn.com.cgbchina.rest.provider.model.coupon.PrivilegeTypeQuery;
import cn.com.cgbchina.rest.provider.model.coupon.PrivilegeTypeQueryReturn;

/**
 * MAL120 商户、类别查询（优惠券）
 *
 * @author lizy 2016/4/28.
 */
public interface PrivilegeTypeQueryService {
	PrivilegeTypeQueryReturn query(PrivilegeTypeQuery privilegeTypeQueryObj);
}
