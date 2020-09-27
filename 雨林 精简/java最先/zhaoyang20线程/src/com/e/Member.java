package com.e;

public class Member {

	private String name;
	private double salary;
	private Department department;

	public Member(String name, double salary) {
		// TODO Auto-generated constructor stub
		this.name=name;
		this.salary=salary;
	}

	public void setDepartment(Department department) {
		this.department=department;
		
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public double getSalary() {
		return salary;
	}

	public void setSalary(double salary) {
		this.salary = salary;
	}

	@Override
	public String toString() {
		return  department.getBumen()+name+salary;
	}

}
