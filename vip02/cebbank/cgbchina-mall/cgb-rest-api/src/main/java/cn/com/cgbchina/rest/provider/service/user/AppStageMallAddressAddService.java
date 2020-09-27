package cn.com.cgbchina.rest.provider.service.user;

import cn.com.cgbchina.rest.provider.model.user.AppStageMallAddressAdd;
import cn.com.cgbchina.rest.provider.model.user.AppStageMallAddressAddReturn;

/**
 * MAL318 添加地址接口(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public interface AppStageMallAddressAddService {
	AppStageMallAddressAddReturn add(AppStageMallAddressAdd appStageMallAddressAdd);
}
