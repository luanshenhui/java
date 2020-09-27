/**
 * 
 */
package com.lsh.domain;

import java.util.ArrayList;
import java.util.List;

/**
 * @author 栾慎辉
 * 
 *         2015-2-2上午10:47:04
 *         
 *         类别类
 */
public class Category extends BaseDomain {
	private String code;
	private String name;
	private String info;
	private List<Product>list=new ArrayList<Product>();

	public Category() {
		this("", "", "");
	}

	public Category(String code, String name, String info) {
		super();
		this.code = code;
		this.name = name;
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

	public String getInfo() {
		return info;
	}

	public void setInfo(String info) {
		this.info = info;
	}

	public List<Product> getList() {
		return list;
	}

	public void setList(List<Product> list) {
		this.list = list;
	}

	@Override
	public String toString() {
		return "Category [code=" + code + ", info=" + info + ", name=" + name
				+ "]";
	}

}
