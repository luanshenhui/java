package cn.com.cgbchina.rest.provider.model.user;

import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.model.BaseEntity;

/**
 * MAL317 地址查询接口(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class AppStageMallAddressReturn extends BaseEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = -757584451972417091L;
	private List<AppStageMallAddressInfo> addresses = new ArrayList<AppStageMallAddressInfo>();

	public List<AppStageMallAddressInfo> getAddresses() {
		return addresses;
	}

	public void setAddresses(List<AppStageMallAddressInfo> addresses) {
		this.addresses = addresses;
	}

}
