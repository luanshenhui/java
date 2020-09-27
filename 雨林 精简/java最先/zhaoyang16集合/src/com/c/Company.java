package com.c;

import java.util.*;

public class Company {

	private String name;

	public Company(String name) {
		// TODO Auto-generated constructor stub
		this.name = name;
	}

	Set<Employee> com = new HashSet<Employee>();

	// Company com=null;
	public void add(Set<Employee> list) {
		for (Employee e : list) {
			com.add(e);
		}

	}

	public int salaryCount() {
		int as = 0;
		for (Employee a : com) {
			if (a.getSalary() > 5000) {
				as++;
			}
		}
		return as;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public String toString() {
		return "Company [name=" + name + "]";
	}

	public void addSalary(int salary) {
		// TODO Auto-generated method stub
		for (Employee emp : com) {
			// double aa=emp.getSalary()+1000;
			emp.setSalary(salary + emp.getSalary());
		}

	}

	public void printAll() {
		Iterator<Employee> iterator = com.iterator();
		while (iterator.hasNext()) {// has.next找迭代器中是否有下一个元素
			Employee str = iterator.next();// next()取出对应的元素
			System.out.println(str);
		}

	}

	public void delSalary(int salary) {
		Iterator<Employee> iterator = com.iterator();
		// Set<Employee> com = new HashSet<Employee>();
		while (iterator.hasNext()) {
			Employee e = iterator.next();
			if (e.getSalary() < salary) {
				iterator.remove();

			}
		}
	}

}
