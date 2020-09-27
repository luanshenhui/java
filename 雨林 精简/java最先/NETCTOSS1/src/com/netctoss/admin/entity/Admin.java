package com.netctoss.admin.entity;

import java.sql.Date;
import java.util.Arrays;

public class Admin {
	private Integer id;
	private String adminCode;
	private String password;
	private String name;
	private String telephone;
	private String email;
	private Date enrollDate;
	
	//追加拥有的角色，用于查询
	private String roleName;
	private String[] roleIds;
	
	
	public String[] getRoleIds() {
		return roleIds;
	}
	public void setRoleIds(String[] roleIds) {
		this.roleIds = roleIds;
	}
	public String getRoleName() {
		return roleName;
	}
	public void setRoleName(String roleName) {
		this.roleName = roleName;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getAdminCode() {
		return adminCode;
	}
	public void setAdminCode(String adminCode) {
		this.adminCode = adminCode;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getTelephone() {
		return telephone;
	}
	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public Date getEnrollDate() {
		return enrollDate;
	}
	public void setEnrollDate(Date enrollDate) {
		this.enrollDate = enrollDate;
	}
	@Override
	public String toString() {
		return "Admin [adminCode=" + adminCode + ", email=" + email
				+ ", enrollDate=" + enrollDate + ", id=" + id + ", name="
				+ name + ", password=" + password + ", roleIds="
				+ Arrays.toString(roleIds) + ", roleName=" + roleName
				+ ", telephone=" + telephone + "]";
	}
	
	
}
