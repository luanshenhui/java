package cn.com.cgbchina.rest.provider.service.user;

import cn.com.cgbchina.rest.provider.model.user.AddressDel;
import cn.com.cgbchina.rest.provider.model.user.AddressDelReturn;

/**
 * MAL334 删除地址接口
 * 
 * @author lizy 2016/4/28.
 */
public interface AddressDelService {
	AddressDelReturn del(AddressDel addressDel);
}
