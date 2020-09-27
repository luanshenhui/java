package com.netctoss.role.action;

import com.netctoss.exception.DAOException;
import com.netctoss.role.dao.IRoleDAO;
import com.netctoss.role.entity.Role;
import com.netctoss.util.DAOFactory;

public class AddRoleAction {
	private Role role;

	public Role getRole() {
		return role;
	}

	public void setRole(Role role) {
		this.role = role;
	}
	public String execute(){
		IRoleDAO dao=(IRoleDAO) DAOFactory.getInstance("IRoleDAO");
		try {
			//System.out.println(role);
			dao.saveRole(role);
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
