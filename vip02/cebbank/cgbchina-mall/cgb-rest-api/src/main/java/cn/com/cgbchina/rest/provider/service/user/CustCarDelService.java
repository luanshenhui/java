package cn.com.cgbchina.rest.provider.service.user;

import cn.com.cgbchina.rest.provider.model.user.CustCarDel;
import cn.com.cgbchina.rest.provider.model.user.CustCarDelReturn;

/**
 * MAL306 修改购物车(分期商城)
 *
 * @author lizy 2016/4/28.
 */
public interface CustCarDelService {
	CustCarDelReturn del(CustCarDel custCarDel);

}
