package com.lsh.domen;
/**
 * DAO��ʵ�ֲ���
 * (1)��Ƴ�������ģ��(��˭������)(ʧѪģ��)
 * (2)���DAO�ӿ�
 * (3)ʵ��DAO�ӿ�
 * 
 * 
 * java��������֮��Ĺ�ϵ��
 * �����������һ����ά��������ϵ
 * ˫���������˫����ά��������ϵ
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
