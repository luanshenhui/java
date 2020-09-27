package com.cost.action;

import com.cost.Dao.CostDao;
import com.cost.Factory.Factory;
import com.cost.entity.Cost;

public class CostDelAction {
	private int id;

	public int getId() {
		return id;
	}
	
	public void setId(int id) {
		this.id = id;
	}

	public String execute() {
		Cost cost = new Cost();
		CostDao dao = (CostDao) Factory.getInstance("CostDao");
		try {
			cost.setId(id);
			dao.deleteCost(id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "success";
	}
}
