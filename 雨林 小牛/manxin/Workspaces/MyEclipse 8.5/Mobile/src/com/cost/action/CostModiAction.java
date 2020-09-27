package com.cost.action;

import com.cost.Dao.CostDao;
import com.cost.Factory.Factory;
import com.cost.entity.Cost;

public class CostModiAction {
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
	public String execute() {
		CostDao dao = (CostDao) Factory.getInstance("CostDao");
		try {
			cost = dao.finById(id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "success";
	}
//	public static void main(String[] args) {
////		CostDao dao = (CostDao) Factory.getInstance("CostDao");
////		cost = null;
//		try {
////			cost = dao.finById(1);
////			System.out.println(cost);
//		} catch (Exception e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//	}
}
