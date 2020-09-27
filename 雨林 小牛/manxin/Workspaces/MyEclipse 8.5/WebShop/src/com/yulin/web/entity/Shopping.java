package com.yulin.web.entity;

public class Shopping {
	private String t_name;
	private String t_descript;
	private double t_price;
	
	public String getT_name() {
		return t_name;
	}
	public void setT_name(String tName) {
		t_name = tName;
	}
	public String getT_descript() {
		return t_descript;
	}
	public void setT_descript(String tDescript) {
		t_descript = tDescript;
	}
	
	public double getT_price() {
		return t_price;
	}
	public void setT_price(double tPrice) {
		t_price = tPrice;
	}
	public Shopping(String tName, String tDescript, double tPrice) {
		super();
		t_name = tName;
		t_descript = tDescript;
		t_price = tPrice;
	}
	public Shopping() {
		super();
	}

}
