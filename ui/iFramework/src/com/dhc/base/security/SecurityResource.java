package com.dhc.base.security;

import java.util.List;

import com.dhc.base.security.SecurityRole.RoleType;

public class SecurityResource {

	private String resourceId;
	private String resourceType;
	private String resourceName;
	private String resourceValue;
	private List<SecurityRole> roles;

	public SecurityResource() {
	}

	public SecurityResource(String url) {

	}

	public String getResourceId() {
		return resourceId;
	}

	class ResourceType {
		public static final String SYSTEM_URL = "SYSTEM_URL";
	}

	public String getResourceType() {
		return resourceType;
	}

	public String getResourceName() {
		return resourceName;
	}

	public String getResourceValue() {
		return resourceValue;
	}

	public List<SecurityRole> getRoles() {
		SecurityRole userRole = new SecurityRole();
		userRole.setRoleType(RoleType.ROLE_USER);
		userRole.setRoleId("1");
		userRole.setRoleName("һ���û�");
		List<SecurityRole> roles = null;
		roles.add(userRole);
		return roles;
		// return roles;
	}

	public void setRoles(List<SecurityRole> roles) {
		this.roles = roles;
	}

	public void setResourceId(String resourceid) {
		this.resourceId = resourceid;
	}

	public void setResourceName(String resourcename) {
		this.resourceName = resourcename;
	}

	public void setResourceType() {
		this.resourceType = ResourceType.SYSTEM_URL;
	}

	public void setResourceValue(String resourcevalue) {
		this.resourceValue = resourcevalue;
	}

}
