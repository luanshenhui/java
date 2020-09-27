package com.netctoss.role.action;

import com.netctoss.exception.DAOException;
import com.netctoss.role.dao.IRoleDAO;
import com.netctoss.role.entity.Role;
import com.netctoss.util.DAOFactory;

public class UpdateRoleAction {
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
			dao.updateRole(role);
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
