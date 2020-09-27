package com.netctoss.account.action;

import com.netctoss.account.dao.IAccountDAO;
import com.netctoss.account.entity.Account;
import com.netctoss.exception.DAOException;
import com.netctoss.util.DAOFactory;

public class AddAccountAction{
	private Account a;

	public Account getA() {
		return a;
	}
	public void setA(Account a) {
		this.a = a;
	}
	public String execute(){
		IAccountDAO dao=(IAccountDAO) DAOFactory.getInstance("IAccountDAO");
		try {
			dao.saveAccount(a);
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
