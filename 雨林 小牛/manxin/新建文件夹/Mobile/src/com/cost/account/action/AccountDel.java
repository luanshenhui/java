package com.cost.account.action;

import com.cost.Factory.Factory;
import com.cost.account.Dao.AccountDao;
import com.cost.account.entity.Account;

public class AccountDel {
	private int id;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String execute(){
		AccountDao dao = (AccountDao) Factory.getInstance("AccountDao");
		try {
//			account.setId(id);
			dao.delAccount(id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "success";
	}
}
