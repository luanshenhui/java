package com.cost.entity;

import java.util.Date;

public class Cost {
	/*
	 *  id            NUMBER(4) not null,
  name          VARCHAR2(50) not null,
  base_duration NUMBER(11),
  base_cost     NUMBER(7,2),
  unit_cost     NUMBER(7,4),
  status        CHAR(1),
  descr         VARCHAR2(100),
  creatime      DATE default SYSDATE,
  startime      DATE,
  cost_type     CHAR(1)
	 * */
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
	public Cost() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Cost(int id, String name, int baseDuration, int baseCost,
			int unitCost, String status, String descr, Date creatime,
			Date startime, String costType) {
		super();
		this.id = id;
		this.name = name;
		base_duration = baseDuration;
		base_cost = baseCost;
		unit_cost = unitCost;
		this.status = status;
		this.descr = descr;
		this.creatime = creatime;
		this.startime = startime;
		cost_type = costType;
	}
	@Override
	public String toString() {
		return "Cost [base_cost=" + base_cost + ", base_duration="
				+ base_duration + ", cost_type=" + cost_type + ", creatime="
				+ creatime + ", descr=" + descr + ", id=" + id + ", name="
				+ name + ", startime=" + startime + ", status=" + status
				+ ", unit_cost=" + unit_cost + "]";
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		long temp;
		temp = Double.doubleToLongBits(base_cost);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		result = prime * result + base_duration;
		result = prime * result
				+ ((cost_type == null) ? 0 : cost_type.hashCode());
		result = prime * result
				+ ((creatime == null) ? 0 : creatime.hashCode());
		result = prime * result + ((descr == null) ? 0 : descr.hashCode());
		result = prime * result + id;
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result
				+ ((startime == null) ? 0 : startime.hashCode());
		result = prime * result + ((status == null) ? 0 : status.hashCode());
		temp = Double.doubleToLongBits(unit_cost);
		result = prime * result + (int) (temp ^ (temp >>> 32));
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Cost other = (Cost) obj;
		if (Double.doubleToLongBits(base_cost) != Double
				.doubleToLongBits(other.base_cost))
			return false;
		if (base_duration != other.base_duration)
			return false;
		if (cost_type == null) {
			if (other.cost_type != null)
				return false;
		} else if (!cost_type.equals(other.cost_type))
			return false;
		if (creatime == null) {
			if (other.creatime != null)
				return false;
		} else if (!creatime.equals(other.creatime))
			return false;
		if (descr == null) {
			if (other.descr != null)
				return false;
		} else if (!descr.equals(other.descr))
			return false;
		if (id != other.id)
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		if (startime == null) {
			if (other.startime != null)
				return false;
		} else if (!startime.equals(other.startime))
			return false;
		if (status == null) {
			if (other.status != null)
				return false;
		} else if (!status.equals(other.status))
			return false;
		if (Double.doubleToLongBits(unit_cost) != Double
				.doubleToLongBits(other.unit_cost))
			return false;
		return true;
	}
	
	
}
