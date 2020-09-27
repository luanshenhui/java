package com.yulin.dangdang.bean;

import java.io.Serializable;

public class Product implements Serializable{
	private static final long serialVersionUID = 1L;
	private int id;
	private String product_name;
	private String description;
	private long add_time;
	private double fixed_price;
	private double dang_price;
	private String keywords;
	private int has_deleted;
	private String product_pic;
	private Book book;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getProduct_name() {
		return product_name;
	}
	public void setProduct_name(String productName) {
		product_name = productName;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public long getAdd_time() {
		return add_time;
	}
	public void setAdd_time(long addTime) {
		add_time = addTime;
	}
	public double getFixed_price() {
		return fixed_price;
	}
	public void setFixed_price(double fixedPrice) {
		fixed_price = fixedPrice;
	}
	public double getDang_price() {
		return dang_price;
	}
	public void setDang_price(double dangPrice) {
		dang_price = dangPrice;
	}
	public String getKeywords() {
		return keywords;
	}
	public void setKeywords(String keywords) {
		this.keywords = keywords;
	}
	public int getHas_deleted() {
		return has_deleted;
	}
	public void setHas_deleted(int hasDeleted) {
		has_deleted = hasDeleted;
	}
	public String getProduct_pic() {
		return product_pic;
	}
	public void setProduct_pic(String productPic) {
		product_pic = productPic;
	}
	public Book getBook() {
		return book;
	}
	public void setBook(Book book) {
		this.book = book;
	}
	public Product() {
		super();
		// TODO Auto-generated constructor stub
	}
	public Product(int id, String productName, String description,
			long addTime, double fixedPrice, double dangPrice, String keywords,
			int hasDeleted, String productPic, Book book) {
		super();
		this.id = id;
		product_name = productName;
		this.description = description;
		add_time = addTime;
		fixed_price = fixedPrice;
		dang_price = dangPrice;
		this.keywords = keywords;
		has_deleted = hasDeleted;
		product_pic = productPic;
//		this.book = book;
	}
	@Override
	public String toString() {
		return "Product [add_time=" + add_time + ", book=" + book
				+ ", dang_price=" + dang_price + ", description=" + description
				+ ", fixed_price=" + fixed_price + ", has_deleted="
				+ has_deleted + ", id=" + id + ", keywords=" + keywords
				+ ", product_name=" + product_name + ", product_pic="
				+ product_pic + "]";
	}
	
	
}
