package cn.com.cgbchina.rest.provider.service.user;

import cn.com.cgbchina.rest.provider.model.user.CustCarQuery;
import cn.com.cgbchina.rest.provider.model.user.CustCarQueryReturn;

/**
 * MAL305 查询购物车(分期商城)
 *
 * @author lizy 2016/4/28.
 */
public interface CustCarQueryService {
	CustCarQueryReturn query(CustCarQuery custCarQueryObj);
}
