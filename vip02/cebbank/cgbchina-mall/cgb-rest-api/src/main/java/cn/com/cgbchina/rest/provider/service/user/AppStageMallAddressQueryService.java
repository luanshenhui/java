package cn.com.cgbchina.rest.provider.service.user;

import cn.com.cgbchina.rest.provider.model.user.AppStageMallAddressQuery;
import cn.com.cgbchina.rest.provider.model.user.AppStageMallAddressReturn;

/**
 * MAL317 地址查询接口(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public interface AppStageMallAddressQueryService {
	AppStageMallAddressReturn query(AppStageMallAddressQuery appStageMallAddressQuery);
}
