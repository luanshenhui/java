package com.netctoss.role.entity;

import java.util.Arrays;

public class Role {
	private int id;
	private String name;
	private String privilegeName;
	private String[] privilegeIds;
	
	
	public String[] getPrivilegeIds() {
		return privilegeIds;
	}
	public void setPrivilegeIds(String[] privilegeIds) {
		this.privilegeIds = privilegeIds;
	}
	public String getPrivilegeName() {
		return privilegeName;
	}
	public void setPrivilegeName(String privilegeName) {
		this.privilegeName = privilegeName;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	@Override
	public String toString() {
		return "Role [id=" + id + ", name=" + name + ", privilegeIds="
				+ Arrays.toString(privilegeIds) + ", privilegeName="
				+ privilegeName + "]";
	}
	
}
