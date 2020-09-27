package com.netctoss.admin.action;

import java.util.Arrays;

import com.netctoss.admin.dao.IAdminDAO;
import com.netctoss.exception.DAOException;
import com.netctoss.util.DAOFactory;

public class ResertPasswordAction {
	private String[] ids;
	private boolean ok;
	public String[] getIds() {
		return ids;
	}
	public void setIds(String[] ids) {
		this.ids = ids;
	}
	public boolean isOk() {
		return ok;
	}
	public void setOk(boolean ok) {
		this.ok = ok;
	}
	public String execute(){
		IAdminDAO dao=(IAdminDAO) DAOFactory.getInstance("IAdminDAO");
		try {
			//System.out.println(Arrays.toString(ids));
			dao.resetPassword(ids);
			ok=true;
		} catch (DAOException e) {
			e.printStackTrace();
			ok=false;
		}
		return "success";
	}
}
