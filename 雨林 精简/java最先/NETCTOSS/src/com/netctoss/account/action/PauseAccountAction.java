package com.netctoss.account.action;

import com.netctoss.account.dao.IAccountDAO;
import com.netctoss.exception.DAOException;
import com.netctoss.util.DAOFactory;

public class PauseAccountAction {
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
		IAccountDAO dao=(IAccountDAO) DAOFactory.getInstance("IAccountDAO");
		try {
			dao.setPause(id);
			ok=true;
			dao.pauseServiceByAccountId(id);
		} catch (DAOException e) {
			e.printStackTrace();
			ok=false;
		}
		return "success";
	}
}
