package com.netctoss.role.action;

import com.netctoss.exception.DAOException;
import com.netctoss.role.dao.IRoleDAO;
import com.netctoss.util.DAOFactory;

public class DeleteRoleAction {
	private int id;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String execute(){
		IRoleDAO dao=(IRoleDAO) DAOFactory.getInstance("IRoleDAO");
		try {
			//System.out.println(id);
			dao.deleteRole(id);
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
