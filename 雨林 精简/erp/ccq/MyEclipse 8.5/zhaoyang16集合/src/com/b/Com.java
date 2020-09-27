package com.b;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class Com {

	private String city;
	private String company;
	List<Men> list = new ArrayList<Men>();
	private Men men;

	public Com(String city, String company) {
		// TODO Auto-generated constructor stub
		this.city = city;
		this.company = company;
	}

	public void add(Men men) {
		list.add(men);

	}

	public void add(String name, String sex, int age) {
		list.add(new Men(name,sex,age));

	}

	public void printAll() {
		// TODO Auto-generated method stub
		// System.out.println(this.men.getAge()+this.men.getSex());

		Iterator<Men> iterator = list.iterator();
		while (iterator.hasNext()) {// has.next找迭代器中是否有下一个元素
			Men m = iterator.next();// next()取出对应的元素
			System.out.println(m);
		}

	}

	public List<Men> findByAge(int age) {
		List<Men> result = new ArrayList<Men>();
		for (Men m : list) {
			if (m.getAge()>=50) {
				result.add(m);
			}
		}
		return result;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getCompany() {
		return company;
	}

	public void setCompany(String company) {
		this.company = company;
	}

	public List<Men> getList() {
		return list;
	}

	public void setList(List<Men> list) {
		this.list = list;
	}

	public Men getMen() {
		return men;
	}

	public void setMen(Men men) {
		this.men = men;
	}

	public Men findByMen(String name, int age) {
	Men m=null;
		for(Men n:list){
			if(name.equals(n.getName())&&n.getAge()==(age)){
				m=n;
			}
		}
		
		return m;
	}

	public void updateMen(String name, int age) {
		// TODO Auto-generated method stub
		for(Men m:list){
			if(name.equals(m.getName())){
				m.setAge(age);
			}
		}
		
	}

}
