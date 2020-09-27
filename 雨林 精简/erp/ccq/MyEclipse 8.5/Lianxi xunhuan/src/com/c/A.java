package com.c;

public class A extends Teacher{

	//private String name;
	private double salary;
	public A(String name, double salary) {
		super(name);
	//	this.name=name;
		this.salary=salary;	
	}
	public void setSalary(double salary) {
		this.salary = salary;
	}
	@Override
	public double getSalary() {
		// TODO Auto-generated method stub
		return salary;
	}

	

//	@Override
//	public String toString() {
//		return salary;
//	}

	
//	public String getName() {
//		return name;
//	}
//
//	public void setName(String name) {
//		this.name = name;
//	}

}
