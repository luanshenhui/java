package cn.rkylin.oms.system.role.domain;

/**
 * 
 * <p>
 * 描述： 角色与组织单元
 *</p>
 */
public class WF_ORG_ROLE_UNIT {
	private String roleId;

	public void setRoleId(String roleId) {
		this.roleId = roleId == null ? null : roleId.trim();
	}

	public String getRoleId() {
		return roleId;
	}

	private String unitId;

	public void setUnitId(String unitId) {
		this.unitId = unitId == null ? null : unitId.trim();
	}

	public String getUnitId() {
		return unitId;
	}

	public WF_ORG_ROLE_UNIT() {

	}
}
