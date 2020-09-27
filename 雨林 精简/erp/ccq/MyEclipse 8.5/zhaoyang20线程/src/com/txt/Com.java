package com.txt;

import java.util.ArrayList;
import java.util.List;

public class Com {
	
	private Men men;
	private Emp emp;

	public Com(String string) {
		// TODO Auto-generated constructor stub
	}
	List<Person>list=new ArrayList<Person>();
	public void add(Person person) {
		//System.out.println("00"+person);
		list.add(person);
	}

	public double getAllSalary() {
		double count=0;
		for(Person p:list){
		//	p.m123(p);
		//	count=count+p.m123();
			count+=p.m123();
		}
		return count;
	}

	

}
