package com.netctoss.service.action;

import com.netctoss.exception.DAOException;
import com.netctoss.service.dao.IServiceDAO;
import com.netctoss.util.DAOFactory;

public class SetPauseAction {
	private int id;
	private boolean ok;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public boolean isOk() {
		return ok;
	}
	public void setOk(boolean ok) {
		this.ok = ok;
	}
	public String execute(){
		IServiceDAO dao=(IServiceDAO) DAOFactory.getInstance("IServiceDAO");
		try {
			dao.SetPause(id);
			ok=true;
		} catch (DAOException e) {
			e.printStackTrace();
			ok=false;
		}
		return "success";
	}
}
