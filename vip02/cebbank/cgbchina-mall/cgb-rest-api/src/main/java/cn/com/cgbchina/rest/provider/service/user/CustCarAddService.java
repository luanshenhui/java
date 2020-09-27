package cn.com.cgbchina.rest.provider.service.user;

import cn.com.cgbchina.rest.provider.model.user.CustCarAdd;
import cn.com.cgbchina.rest.provider.model.user.CustCarAddReturn;

/**
 * MAL304 加入购物车(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public interface CustCarAddService {
	CustCarAddReturn add(CustCarAdd custCarAddObj);
}
