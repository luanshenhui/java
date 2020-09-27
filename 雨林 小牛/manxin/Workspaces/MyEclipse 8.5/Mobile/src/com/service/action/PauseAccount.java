package com.service.action;

import com.cost.Factory.Factory;
import com.cost.account.Dao.AccountDao;
import com.service.dao.ServiceDao;

public class PauseAccount {
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
		ServiceDao dao = (ServiceDao) Factory.getInstance("ServiceDao");
		try {
			dao.pause(id);
			ok = true;
		} catch (Exception e) {
			e.printStackTrace();
			ok = false;
		}
		return "success";
	}
}
