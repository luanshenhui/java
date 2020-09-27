package com.lsh.domen;
/**
 * DAO层实现步骤
 * (1)设计抽象领域模型(对谁做操作)(失血模型)
 * (2)设计DAO接口
 * (3)实现DAO接口
 * 
 * 
 * java中类与类之间的关系：
 * 单向关联：由一方来维护关联关系
 * 双向关联：由双方来维护关联关系
 */
import java.util.ArrayList;
import java.util.List;

import com.am.lsh.CompanyDAOImpl;

public class Company extends Basedemon{
	//private int id;
	private String name;
	private List<Mem>list=new ArrayList<Mem>();
	
	public Company() {
		this(0,"");
	}
	public Company(int id, String name) {
		super(id);
		//this.id = id;
		this.name = name;
		
	}


	public List<Mem> getList() {
//		CompanyDAOImpl cd=new CompanyDAOImpl();
//		cd.getList();
		return list;
	}
	public void setList(List<Mem> list) {
		this.list = list;
	}
//	public int getId() {
//		return id;
//	}
//	public void setId(int id) {
//		this.id = id;
//	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	@Override
	public String toString() {
		return   " 2name    " + name ;
	}


}
