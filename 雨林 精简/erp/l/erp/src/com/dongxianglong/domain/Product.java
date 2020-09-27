/**
 * 
 */
package com.dongxianglong.domain;

import java.util.ArrayList;
import java.util.List;

/**
 * @author 董祥龙
 *
 * 2015-2-2上午10:46:25
 * 商品类
 */
public class Product extends BaseDomain {

	
	
	private String code;
	
	private String name;
	
	private double price;
	
	private String info;
	
	private Category category=new Category();
	
	
	public Product() {
		this("","",0.0,"");
	}

	public Product(String code, String name, double price, String info) {
		super();
		this.code = code;
		this.name = name;
		this.price = price;
		this.info = info;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public String getInfo() {
		return info;
	}

	public void setInfo(String info) {
		this.info = info;
	}

	public Category getCategory() {
		return category;
	}

	public void setCategory(Category category) {
		this.category = category;
	}


	

	public String toString() {
		return "Product [code=" + code + ", info=" + info + ", name=" + name
				+ ", price=" + price + "]";
	}
	
}
