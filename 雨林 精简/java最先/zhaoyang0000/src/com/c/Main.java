package com.c;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Company com=new Company("IBM");
		
		Set<Employee>list=new HashSet<Employee>();
		list.add(new Employee("张三",3000.5));
		list.add(new Employee("李四",4500.5));
		list.add(new Employee("王五",5900.5));
		list.add(new Employee("赵六",3300.5));
		list.add(new Employee("刘二",6700.5));
		
		com.add(list);
		
		int count=com.salaryCount();
		System.out.println(count);
	}

}
