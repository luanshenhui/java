package com.cost.account.action;

import com.cost.Factory.Factory;
import com.cost.account.Dao.AccountDao;

public class StartAccount {
	//输入
	private int id;

	//输出
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
		AccountDao dao = (AccountDao) Factory.getInstance("AccountDao");
		try {
			dao.start(id);
			ok = true;
		} catch (Exception e) {
			e.printStackTrace();
			ok = false;
		}
		
		return "success";
	}
}
