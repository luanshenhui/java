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
		list.add(new Employee("����", 3000.5));
		list.add(new Employee("����", 4500.5));
		list.add(new Employee("����", 5900.5));
		list.add(new Employee("����", 3300.5));
		list.add(new Employee("����", 6700.5));

		com.add(list);

		int count = com.salaryCount();
		System.out.println(count);

		com.addSalary(1000);// ÿ�˳�1000
		com.printAll();

		com.delSalary(5000);// ɾ��5000���µ��ڴ�ӡ
		com.printAll();
	
	}

}
