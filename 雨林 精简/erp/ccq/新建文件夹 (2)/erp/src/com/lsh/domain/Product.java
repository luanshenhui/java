/**
 * 
 */
package com.lsh.domain;

import java.util.ArrayList;
import java.util.List;

/**
 * @author 栾慎辉
 * 
 *         2015-2-2上午10:50:11
 * 
 *         商品类
 */
public class Product extends BaseDomain {
	private String code;
	private String name;
	private double price;
	private String info;
	private Category category;
//	private List<Stock>list=new ArrayList<Stock>();
//	private List<Sell>list2=new ArrayList<Sell>();
//	private List<Repertory>list3=new ArrayList<Repertory>();
	

	public Product() {
		this("","",0,"");
	}

	public Product(String code, String name, double price, String info) {
		super();
		this.code = code;
		this.name = name;
		this.price = price;
		this.info = info;
	}

	
//	public List<Repertory> getList3() {
//		return list3;
//	}
//
//	public void setList3(List<Repertory> list3) {
//		this.list3 = list3;
//	}

//	public List<Sell> getList2() {
//		return list2;
//	}
//
//	public void setList2(List<Sell> list2) {
//		this.list2 = list2;
//	}
//
//	public List<Stock> getList() {
//		return list;
//	}
//
//	public void setList(List<Stock> list) {
//		this.list = list;
//	}

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

	@Override
	public String toString() {
		return "Product [code=" + code + ", info=" + info + ", name=" + name
				+ ", price=" + price + "]";
	}

}
