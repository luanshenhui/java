package com.dhc.base.security;

import java.util.Set;

public class SecurityRole implements java.io.Serializable {
	/**
	 * 
	 */

	/**
	 * 账户
	 */
	private String userName;
	/**
	 * 角色id
	 */
	private String roleId;
	/**
	 * 角色名称
	 */
	private String roleName;
	/**
	 * 角色描述
	 */
	private String roleDescription;
	/**
	 * 角色对应的资源-这里一般指系统一级菜单 system
	 */
	private Set<SecurityResource> resources;

	/**
	 * 角色分为一般用户角色 和管理员角色两种,未授权定义预留
	 */
	private String roleType;

	class RoleType {
		public static final String ROLE_USER = "ROLE_USER";
		public static final String ROLE_ADMIN = "ROLE_ADMIN";
		public static final String ROLE_UNAUTHRORIZATION = "ROLE_UNAUTHRORIZATION";
	}

	public SecurityRole() {
	}

	public String gerUserName() {
		return userName;
	}

	public String getRoleId() {
		return roleId;
	}

	public String getRoleName() {
		return roleName;
	}

	public String GetRoleDescription() {
		return roleDescription;
	}

	public String getRoleType() {
		return roleType;
	}

	public void setRoleName(String rolename) {
		this.roleName = rolename;
	}

	public void setRoleId(String roleid) {
		this.roleId = roleid;
	}

	public void setRoldDescription(String roledescription) {
		this.roleDescription = roledescription;
	}

	public void setRoleType(String roletype) {
		if (roletype == null) {
			this.roleType = RoleType.ROLE_UNAUTHRORIZATION;
		} else if (roletype.equals("1")) {
			this.roleType = RoleType.ROLE_ADMIN;
		} else if (roletype.equals("0")) {
			this.roleType = RoleType.ROLE_USER;
		}
	}

	public Set<SecurityResource> getResources() {
		return resources;
	}

}
