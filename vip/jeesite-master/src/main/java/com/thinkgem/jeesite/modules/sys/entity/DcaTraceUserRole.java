/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.thinkgem.jeesite.modules.sys.entity;

import org.hibernate.validator.constraints.Length;

import com.thinkgem.jeesite.common.persistence.TreeEntity;

/**
 * 岗位管理Entity
 * 
 * @author zhengwei.cui
 * @version 2016-12-15
 */
public class DcaTraceUserRole extends TreeEntity<DcaTraceUserRole> {

	private static final long serialVersionUID = 1L;
	private String roleId; // 主键id
	private String orgId; // 组织ID
	private String roleName; // 岗位名称
	private String userIdList; // 适用用户ID
	private String userNameList; // 使用用户名称
	private String roleParentId; // 父岗位ID
	private String roleParentName; // 父岗位名称
	private String deptId; // 系统岗位标识
	private String roleRank; // 岗位级别
	private String createPerson; // create_person
	private String updatePerson; // update_person

	public DcaTraceUserRole() {
		super();
	}

	public DcaTraceUserRole(String id) {
		super(id);
	}

	@Length(min = 1, max = 50, message = "role_id长度必须介于 1 和 50 之间")
	public String getRoleId() {
		return roleId;
	}

	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}

	@Length(min = 0, max = 50, message = "org_id长度必须介于 0 和 50 之间")
	public String getOrgId() {
		return orgId;
	}

	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}

	@Length(min = 0, max = 150, message = "role_name长度必须介于 0 和 150 之间")
	public String getRoleName() {
		return roleName;
	}

	public void setRoleName(String roleName) {
		this.roleName = roleName;
	}

	public String getUserIdList() {
		return userIdList;
	}

	public void setUserIdList(String userIdList) {
		this.userIdList = userIdList;
	}

	@Length(min = 0, max = 50, message = "role_parent_id长度必须介于 0 和 50 之间")
	public String getRoleParentId() {
		return roleParentId;
	}

	public void setRoleParentId(String roleParentId) {
		this.roleParentId = roleParentId;
	}

	@Length(min = 0, max = 50, message = "dept_id长度必须介于 0 和 50 之间")
	public String getDeptId() {
		return deptId;
	}

	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}

	public String getRoleRank() {
		return roleRank;
	}

	public void setRoleRank(String roleRank) {
		this.roleRank = roleRank;
	}

	@Length(min = 0, max = 64, message = "create_person长度必须介于 0 和 64 之间")
	public String getCreatePerson() {
		return createPerson;
	}

	public void setCreatePerson(String createPerson) {
		this.createPerson = createPerson;
	}

	@Length(min = 0, max = 64, message = "update_person长度必须介于 0 和 64 之间")
	public String getUpdatePerson() {
		return updatePerson;
	}

	public void setUpdatePerson(String updatePerson) {
		this.updatePerson = updatePerson;
	}

	public String getRoleParentName() {
		return roleParentName;
	}

	public void setRoleParentName(String roleParentName) {
		this.roleParentName = roleParentName;
	}

	public String getUserNameList() {
		return userNameList;
	}

	public void setUserNameList(String userNameList) {
		this.userNameList = userNameList;
	}

	@Override
	public DcaTraceUserRole getParent() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void setParent(DcaTraceUserRole parent) {
		// TODO Auto-generated method stub

	}

}