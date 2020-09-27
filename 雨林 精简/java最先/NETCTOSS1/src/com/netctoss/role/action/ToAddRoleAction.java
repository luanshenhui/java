package com.netctoss.role.action;

import java.util.List;

import com.netctoss.role.entity.Privilege;
import com.netctoss.util.PrivilegeReader;

public class ToAddRoleAction {
	private List<Privilege> privileges;

	public List<Privilege> getPrivileges() {
		return privileges;
	}

	public void setPrivileges(List<Privilege> privileges) {
		this.privileges = privileges;
	}
	public String execute(){
		privileges=PrivilegeReader.getPrivileges();
		return "success";
	}
}
