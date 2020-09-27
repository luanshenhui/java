package com.keda.wuye.entity;

public class Plant {
	private String plant_id;			//设备编号
	private String plant_name;			//设备名字
	private String plant_comid;			//设备所属小区编号
	private String plant_factory;		//设备身产商
	private String plant_date;			//设备身产日期
	private int plant_num;				//设备数量
	private int plant_repaircycle;		//设备检修周期
	public String getPlant_id() {
		return plant_id;
	}
	public void setPlant_id(String plant_id) {
		this.plant_id = plant_id;
	}
	public String getPlant_name() {
		return plant_name;
	}
	public void setPlant_name(String plant_name) {
		this.plant_name = plant_name;
	}
	public String getPlant_comid() {
		return plant_comid;
	}
	public void setPlant_comid(String plant_comid) {
		this.plant_comid = plant_comid;
	}
	
	public String getPlant_factory() {
		return plant_factory;
	}
	public void setPlant_factory(String plant_factory) {
		this.plant_factory = plant_factory;
	}
	public String getPlant_date() {
		return plant_date;
	}
	public void setPlant_date(String plant_date) {
		this.plant_date = plant_date;
	}
	public int getPlant_num() {
		return plant_num;
	}
	public void setPlant_num(int plant_num) {
		this.plant_num = plant_num;
	}
	public int getPlant_repaircycle() {
		return plant_repaircycle;
	}
	public void setPlant_repaircycle(int plant_repaircycle) {
		this.plant_repaircycle = plant_repaircycle;
	}
	
}
