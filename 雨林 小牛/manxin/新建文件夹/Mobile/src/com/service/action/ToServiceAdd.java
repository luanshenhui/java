package com.service.action;

import java.util.List;

import com.cost.Dao.CostDao;
import com.cost.Factory.Factory;
import com.cost.entity.Cost;

public class ToServiceAdd {
	private List<Cost> cost;

	public List<Cost> getCost() {
		return cost;
	}

	public void setCost(List<Cost> cost) {
		this.cost = cost;
	}
	public String execute(){
		CostDao dao = (CostDao) Factory.getInstance("CostDao");
		try {
			cost = dao.findAll();
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
