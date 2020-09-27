package com.netctoss.admin.action;

import com.netctoss.admin.dao.IAdminDAO;
import com.netctoss.admin.entity.Admin;
import com.netctoss.exception.DAOException;
import com.netctoss.util.DAOFactory;

public class AddAdminAction {
	private Admin admin;

	public Admin getAdmin() {
		return admin;
	}

	public void setAdmin(Admin admin) {
		this.admin = admin;
	}
	public String execute(){
		//System.out.println(admin);
		IAdminDAO dao=(IAdminDAO) DAOFactory.getInstance("IAdminDAO");
		try {
			dao.saveAdmin(admin);
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
