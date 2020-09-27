package com.a;

import java.util.ArrayList;
import java.util.List;

public class Com <T>{

	private String name;

	public Com(String name) {
		// TODO Auto-generated constructor stub
		this.name=name;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public String toString() {
		return "Com [name=" + name + "]";
	}
List<T>list=new ArrayList<T>();
	public void add(T t) {
		//System.out.println(men);
		list.add(t);
		
	}

	public void printALl() {
		// TODO Auto-generated method stub
		for(T t:list){
			System.out.println(t);
		}
		
	}

}
