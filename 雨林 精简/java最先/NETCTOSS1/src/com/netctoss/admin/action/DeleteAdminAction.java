package com.netctoss.admin.action;

import com.netctoss.admin.dao.IAdminDAO;
import com.netctoss.exception.DAOException;
import com.netctoss.util.DAOFactory;

public class DeleteAdminAction {
	private Integer id;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}
	public String execute(){
		IAdminDAO dao=(IAdminDAO) DAOFactory.getInstance("IAdminDAO");
		try {
			dao.deleteAdmin(id);
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
