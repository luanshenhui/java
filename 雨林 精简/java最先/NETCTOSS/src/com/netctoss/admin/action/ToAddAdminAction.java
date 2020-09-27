package com.netctoss.admin.action;

import java.util.List;

import com.netctoss.exception.DAOException;
import com.netctoss.role.dao.IRoleDAO;
import com.netctoss.role.entity.Role;
import com.netctoss.util.DAOFactory;

public class ToAddAdminAction {
	private List<Role> roles;
	
	
	public List<Role> getRoles() {
		return roles;
	}


	public void setRoles(List<Role> roles) {
		this.roles = roles;
	}


	public String execute(){
		IRoleDAO dao=(IRoleDAO) DAOFactory.getInstance("IRoleDAO");
		try {
			roles=dao.findAll();
		} catch (DAOException e) {
			e.printStackTrace();
		}
		return "success";
	}
}
