package com.keda.wuye.entity;

public class Carport {
	private String carport_id;			//车位号
	private String carport_resid;		//车主编号
	private String carport_carnum;		//车牌号
	private String carport_cartype;		//车类型
	private double carport_area;		//车位面积
	public String getCarport_id() {
		return carport_id;
	}
	public void setCarport_id(String carport_id) {
		this.carport_id = carport_id;
	}
	public String getCarport_resid() {
		return carport_resid;
	}
	public void setCarport_resid(String carport_resid) {
		this.carport_resid = carport_resid;
	}
	public String getCarport_carnum() {
		return carport_carnum;
	}
	public void setCarport_carnum(String carport_carnum) {
		this.carport_carnum = carport_carnum;
	}
	public String getCarport_cartype() {
		return carport_cartype;
	}
	public void setCarport_cartype(String carport_cartype) {
		this.carport_cartype = carport_cartype;
	}
	public double getCarport_area() {
		return carport_area;
	}
	public void setCarport_area(double carport_area) {
		this.carport_area = carport_area;
	}
}
