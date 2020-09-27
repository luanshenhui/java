package com.yulin.dangdang.bean;

import java.io.Serializable;

public class Item implements Serializable{
	private static final long serialVersionUID = 1L;
	
	private int id;
	private int order_id;
	private int product_id;
	private String product_name;
	private double dang_price;
	private int product_num;
	private double amount;
	private double fixed_price;
	private boolean has_deleted = false;;
	
	
	public boolean isHas_deleted() {
		return has_deleted;
	}
	public void setHas_deleted(boolean hasDeleted) {
		has_deleted = hasDeleted;
	}
	public double getFixed_price() {
		return fixed_price;
	}
	public void setFixed_price(double fixedPrice) {
		fixed_price = fixedPrice;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getOrder_id() {
		return order_id;
	}
	public void setOrder_id(int orderId) {
		order_id = orderId;
	}
	public int getProduct_id() {
		return product_id;
	}
	public void setProduct_id(int productId) {
		product_id = productId;
	}
	public String getProduct_name() {
		return product_name;
	}
	public void setProduct_name(String productName) {
		product_name = productName;
	}
	public double getDang_price() {
		return dang_price;
	}
	public void setDang_price(double dangPrice) {
		dang_price = dangPrice;
	}
	public int getProduct_num() {
		return product_num;
	}
	public void setProduct_num(int productNum) {
		product_num = productNum;
	}
	public double getAmount() {
		return amount;
	}
	public void setAmount(double amount) {
		this.amount = amount;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	public Item() {
		super();
	}
	
	public Item(int id, int orderId, int productId, String productName,
			double dangPrice, int productNum, double amount, double fixedPrice,
			boolean hasDeleted) {
		super();
		this.id = id;
		order_id = orderId;
		product_id = productId;
		product_name = productName;
		dang_price = dangPrice;
		product_num = productNum;
		this.amount = amount;
		fixed_price = fixedPrice;
		has_deleted = hasDeleted;
	}
	
	@Override
	public String toString() {
		return "Item [amount=" + amount + ", dang_price=" + dang_price
				+ ", fixed_price=" + fixed_price + ", has_deleted="
				+ has_deleted + ", id=" + id + ", order_id=" + order_id
				+ ", product_id=" + product_id + ", product_name="
				+ product_name + ", product_num=" + product_num + "]";
	}
	@Override
	public int hashCode() {
		return product_id*1234-1234;
	}
	
	@Override
	public boolean equals(Object obj) {
		if (obj == null) {
			return false;
		}
		if (obj instanceof Item) {//检验o指向的类型是否是Card
			Item item = (Item)obj;//强制类型转换
			if (item.product_id == this.product_id) {
				return true;
			}
		}
		return false;
	}
	
}
