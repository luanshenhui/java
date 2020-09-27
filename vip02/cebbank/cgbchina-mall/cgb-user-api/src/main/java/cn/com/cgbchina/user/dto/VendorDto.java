package cn.com.cgbchina.user.dto;

import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.model.VendorModel;
import cn.com.cgbchina.user.model.VendorRoleModel;

import java.io.Serializable;
import java.util.List;

/**
 * Created by niufw on 16-4-25.
 */
public class VendorDto extends VendorModel implements Serializable {
	private static final long serialVersionUID = -126948414458591768L;
	/**
	 * 角色表
	 */
	private List<VendorRoleModel> vendorRoleModels;

	public List<VendorRoleModel> getVendorRoleModels() {
		return vendorRoleModels;
	}

	public void setVendorRoleModels(List<VendorRoleModel> vendorRoleModels) {
		this.vendorRoleModels = vendorRoleModels;
	}
}
