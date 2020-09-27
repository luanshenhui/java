package com.netctoss.role.action;

import java.util.List;

import com.netctoss.exception.DAOException;
import com.netctoss.role.dao.IRoleDAO;
import com.netctoss.role.entity.Privilege;
import com.netctoss.role.entity.Role;
import com.netctoss.util.DAOFactory;
import com.netctoss.util.PrivilegeReader;

public class ToUpdateRoleAction {
	private int id;
	private List<Privilege> privileges;
	private Role role;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	
	public List<Privilege> getPrivileges() {
		return privileges;
	}
	public void setPrivileges(List<Privilege> privileges) {
		this.privileges = privileges;
	}
	public Role getRole() {
		return role;
	}
	public void setRole(Role role) {
		this.role = role;
	}
	
	public String execute(){
			
		privileges=PrivilegeReader.getPrivileges();
		IRoleDAO dao=(IRoleDAO) DAOFactory.getInstance("IRoleDAO");
		try {
			role=dao.findById(id);
		} catch (DAOException e) {
			e.printStackTrace();
		}
		return "success";
	}
}
