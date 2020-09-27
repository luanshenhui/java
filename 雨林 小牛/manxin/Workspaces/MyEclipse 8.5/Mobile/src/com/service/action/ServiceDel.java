package com.service.action;

import com.cost.Factory.Factory;
import com.cost.account.Dao.AccountDao;
import com.cost.account.entity.Account;
import com.service.dao.ServiceDao;
import com.service.entity.VO;

public class ServiceDel {
	private int id;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public String execute(){
		VO vo = new VO();
		ServiceDao dao = (ServiceDao) Factory.getInstance("ServiceDao");
		try {
			dao.delService(id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "success";
	}
}
