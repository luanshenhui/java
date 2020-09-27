package cn.com.cgbchina.rest.provider.service.user;

import cn.com.cgbchina.rest.provider.model.user.CustInfo;
import cn.com.cgbchina.rest.provider.model.user.CustInfoQueryReturn;

/**
 * MAL323 客户信息查询
 * 
 * @author lizy 2016/4/28.
 */
public interface CustInfoQueryService {
	CustInfoQueryReturn query(CustInfo custInfo);
}
