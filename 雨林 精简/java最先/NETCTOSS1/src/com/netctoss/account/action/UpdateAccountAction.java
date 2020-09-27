package com.netctoss.account.action;

import com.netctoss.account.dao.IAccountDAO;
import com.netctoss.account.entity.Account;
import com.netctoss.exception.DAOException;
import com.netctoss.util.DAOFactory;

public class UpdateAccountAction {
	private Account a;

	public Account getA() {
		return a;
	}

	public void setA(Account a) {
		this.a = a;
	}

	public String execute() {
		IAccountDAO dao = (IAccountDAO) DAOFactory.getInstance("IAccountDAO");
		try {
			//System.out.println(a);
			if (a.getLoginPassword() == null||a.getLoginPassword().equals("")) {
				a.setLoginPassword(dao.findById(a.getId()).getLoginPassword());
			}
			//System.out.println(a);
			dao.modifyAccount(a);
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
