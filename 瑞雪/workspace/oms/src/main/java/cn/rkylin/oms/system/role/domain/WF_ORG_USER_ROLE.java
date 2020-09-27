package cn.rkylin.oms.system.role.domain;

import cn.rkylin.oms.common.base.BaseEntity;

/**
 * 
 * <p>
 * 描述： 角色与用户
 *</p>
 */
@SuppressWarnings("serial")
public class WF_ORG_USER_ROLE extends BaseEntity {
	private String roleId;

	public void setRoleId(String roleId) {
		this.roleId = roleId == null ? null : roleId.trim();
	}

	public String getRoleId() {
		return roleId;
	}

	private String userId;

	public void setUserId(String unitId) {
		this.userId = unitId == null ? null : unitId.trim();
	}

	public String getUserId() {
		return userId;
	}

	public WF_ORG_USER_ROLE() {

	}
}
