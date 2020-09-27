package com.netctoss.account.action;

import com.netctoss.account.dao.IAccountDAO;
import com.netctoss.account.entity.Account;
import com.netctoss.exception.DAOException;
import com.netctoss.util.DAOFactory;

public class ValidPwdAction {
	private int id;
	private String oldPwd;
	private boolean ok;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getOldPwd() {
		return oldPwd;
	}
	public void setOldPwd(String oldPwd) {
		this.oldPwd = oldPwd;
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
			Account a=dao.findByIdAndPwd(id, oldPwd);
			if(a!=null){
				ok=true;
			}else{
				ok=false;
			}
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
