package cn.com.cgbchina.rest.provider.vo.user;

import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.provider.vo.BaseEntityVO;

/**
 * MAL317 地址查询接口(分期商城)
 * 
 * @author lizy 2016/4/28.
 */
public class AppStageMallAddressReturnVO extends BaseEntityVO {

	/**
	 * 
	 */
	private static final long serialVersionUID = -757584451972417091L;
	private List<AppStageMallAddressInfoVO> addresses = new ArrayList<AppStageMallAddressInfoVO>();

	public List<AppStageMallAddressInfoVO> getAddresses() {
		return addresses;
	}

	public void setAddresses(List<AppStageMallAddressInfoVO> addresses) {
		this.addresses = addresses;
	}

}
