package com.c;

import java.util.*;

public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Company com = new Company("IBM");

		Set<Employee> list = new HashSet<Employee>();
		list.add(new Employee("张三", 3000.5));
		list.add(new Employee("李四", 4500.5));
		list.add(new Employee("王五", 5900.5));
		list.add(new Employee("赵六", 3300.5));
		list.add(new Employee("刘二", 6700.5));

		com.add(list);

		int count = com.salaryCount();
		System.out.println(count);

		com.addSalary(1000);// 每人长1000
		com.printAll();

		com.delSalary(5000);// 删除5000以下的在打印
		com.printAll();
	
	}

}
