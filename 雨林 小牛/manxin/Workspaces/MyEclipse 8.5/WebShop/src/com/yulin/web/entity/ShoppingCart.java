package com.yulin.web.entity;

public class ShoppingCart {
	private String t_name;
	private double t_price;
	private double t_num;

	public ShoppingCart(String tName,double tPrice, double tNum) {
		super();
		t_name = tName;
		t_price = tPrice;
		t_num = tNum;
	}
	public ShoppingCart() {
		super();
	}
	public double getT_price() {
		return t_price;
	}
	public void setT_price(double tPrice) {
		t_price = tPrice;
	}
	public String getT_name() {
		return t_name;
	}
	public void setT_name(String tName) {
		t_name = tName;
	}

	public double getT_num() {
		return t_num;
	}
	public void setT_num(double tNum) {
		t_num = tNum;
	}
}
