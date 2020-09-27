package com.cost.action;

import java.util.Date;

import com.cost.Dao.CostDao;
import com.cost.Factory.Factory;
import com.cost.entity.Cost;

public class CostUpAction {
	private int id;
	private String name;
	private int base_duration;
	private double base_cost;
	private double unit_cost;
	private String status;
	private String descr;
	private Date creatime;
	private Date startime;
	private String cost_type;
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
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getBase_duration() {
		return base_duration;
	}
	public void setBase_duration(int baseDuration) {
		base_duration = baseDuration;
	}
	public double getBase_cost() {
		return base_cost;
	}
	public void setBase_cost(double baseCost) {
		base_cost = baseCost;
	}
	public double getUnit_cost() {
		return unit_cost;
	}
	public void setUnit_cost(double unitCost) {
		unit_cost = unitCost;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getDescr() {
		return descr;
	}
	public void setDescr(String descr) {
		this.descr = descr;
	}
	public Date getCreatime() {
		return creatime;
	}
	public void setCreatime(Date creatime) {
		this.creatime = creatime;
	}
	public Date getStartime() {
		return startime;
	}
	public void setStartime(Date startime) {
		this.startime = startime;
	}
	public String getCost_type() {
		return cost_type;
	}
	public void setCost_type(String costType) {
		cost_type = costType;
	}
	public String execute() {
		CostDao dao = (CostDao) Factory.getInstance("CostDao");
		Cost cost = new Cost();
		cost.setId(id);
		cost.setName(name);
		cost.setBase_duration(base_duration);
		cost.setBase_cost(base_cost);
		cost.setUnit_cost(unit_cost);
		cost.setStatus("0");
		cost.setDescr(descr);
		cost.setCreatime(null);
		cost.setStartime(null);
		cost.setCost_type(null);
		try {
			dao.updateCost(cost);
//			System.out.println(cost);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "success";
	}
}
