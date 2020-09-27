package cn.com.cgbchina.rest.provider.service.user;

import cn.com.cgbchina.rest.provider.model.user.AddressUpdate;
import cn.com.cgbchina.rest.provider.model.user.AddressUpdateReturn;

/**
 * MAL333 修改地址接口
 * 
 * @author lizy 2016/4/28.
 */
public interface AddressUpdateService {
	AddressUpdateReturn update(AddressUpdate addressUpdate);

}
