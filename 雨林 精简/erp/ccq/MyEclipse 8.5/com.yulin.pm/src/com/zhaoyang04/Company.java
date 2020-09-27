package com.zhaoyang04;

import java.util.ArrayList;
import java.util.List;

public class Company extends IdFarther{
	private String name;
	private  List<Mem>list=new ArrayList<Mem>();

	public Company() {
		this(0,"");
	}
	
	public Company(int id,String name) {
		super(id);
		this.name = name;	
	}
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public List<Mem> getList() {
		return list;
	}

	public void setList(List<Mem> list) {
		this.list = list;
	}

	@Override
	public String toString() {
		return name;
	}

}
