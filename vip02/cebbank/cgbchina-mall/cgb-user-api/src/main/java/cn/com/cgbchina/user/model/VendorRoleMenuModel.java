package cn.com.cgbchina.user.model;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

public class VendorRoleMenuModel implements Serializable {

	private static final long serialVersionUID = 1950612485416303551L;
	@Getter
	@Setter
	private Long id;//
	@Getter
	@Setter
	private Long menuId;// 资源编码
	@Getter
	@Setter
	private Long roleId;// 角色ID
	@Getter
	@Setter
	private String rightRead;// 用户读权限
	@Getter
	@Setter
	private String rightWrite;// 用户新增权限
	@Getter
	@Setter
	private String rightMod;// 用户修改权限
	@Getter
	@Setter
	private String rightDel;// 用户删除权限
	@Getter
	@Setter
	private String checkStatus;// 审核状态
	@Getter
	@Setter
	private String refuseDesc;// 拒绝原因
	@Getter
	@Setter
	private String vendorId;//
}