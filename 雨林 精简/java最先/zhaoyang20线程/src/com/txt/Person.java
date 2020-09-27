package com.txt;

public abstract class Person {
	private String name;
	private double salary;

	public Person(String name, double salary) {
	
		this.name = name;
		this.salary = salary;
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
		return "Person [name=" + name + ", salary=" + salary + "]";
	}

	public abstract double m123() ;
		// TODO Auto-generated method 

//	public abstract void m123(Person p); 
//		// TODO Auto-generated method stub

	
		
	
	
}