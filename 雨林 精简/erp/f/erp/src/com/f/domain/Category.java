package com.f.domain;


import java.util.List;
import java.util.Vector;

/**
 * 
 * 
 * @author 冯学明
 *
 * 2015-2-2上午10:15:41
 *  类别类
 */
public class Category extends BaseDomain{
	private String code;
	private String name;
	private String info;
	private List<Product> list=new Vector<Product>();
	
	public Category() {
		this("","","");
	}
	public Category(String code, String name, String info) {
		super();
		this.code = code;
		this.name = name;
		this.info = info;
	}
	public List<Product> getList() {
		return list;
	}
	public void setList(List<Product> list) {
		this.list = list;
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
	public String getInfo() {
		return info;
	}
	public void setInfo(String info) {
		this.info = info;
	}
	@Override
	public String toString() {
		return "Category [code=" + code + ", name=" + name + ", info=" + info
				+ "]";
	}

}
