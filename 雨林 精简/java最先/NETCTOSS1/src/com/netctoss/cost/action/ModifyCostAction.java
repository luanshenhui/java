package com.netctoss.cost.action;

import com.netctoss.cost.dao.ICostDAO;
import com.netctoss.cost.entity.Cost;
import com.netctoss.exception.DAOException;
import com.netctoss.util.DAOFactory;

public class ModifyCostAction {
	private int id;
	private Cost cost;
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public Cost getCost() {
		return cost;
	}

	public void setCost(Cost cost) {
		this.cost = cost;
	}

	public String load(){
		ICostDAO dao=(ICostDAO) DAOFactory.getInstance("ICostDAO");
		try {
			cost=dao.findById(id);
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "load";
	}
	
	public String modify(){
		ICostDAO dao=(ICostDAO) DAOFactory.getInstance("ICostDAO");
		try {
			//System.out.println(cost);
			dao.modify(cost);
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "modify";
	}
}
