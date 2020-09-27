package com.c;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;



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

}
