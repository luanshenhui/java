package com.dhc.organization.role.domain;

import com.dhc.organization.common.data.BaseVO;

public class WF_ORG_USER_ROLE extends BaseVO {
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
