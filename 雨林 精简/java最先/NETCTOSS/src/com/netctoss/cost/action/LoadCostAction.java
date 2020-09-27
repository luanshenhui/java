package com.netctoss.cost.action;

import com.netctoss.cost.dao.ICostDAO;
import com.netctoss.cost.entity.Cost;
import com.netctoss.exception.DAOException;
import com.netctoss.util.DAOFactory;

public class LoadCostAction {
	private int id;
	private Cost cost;
	public Cost getCost() {
		return cost;
	}

	public void setCost(Cost cost) {
		this.cost = cost;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}
	public String execute(){
		ICostDAO dao=(ICostDAO) DAOFactory.getInstance("ICostDAO");
		try {
			cost=dao.findById(id);
			if(cost.getName().indexOf("包月")!=-1){
				cost.setCostType("0");//表示包月
			}else if(cost.getName().indexOf("套餐")!=-1){
				cost.setCostType("1");
			}else if(cost.getName().indexOf("计时")!=-1){
				cost.setCostType("2");
			}
		} catch (DAOException e) {
			e.printStackTrace();
			return "error";
		}
		return "success";
	}
}
