package com.b;

public class A extends Teacher {

	private int salary;

	public A() {
		this("", 0);
	}

	public A(String name, int salary) {
		super(name);
		this.salary = salary;
	}

	public int getSalary() {
		return salary;
	}

	public void setSalary(int salary) {
		this.salary = salary;
	}

}
