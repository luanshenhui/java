package com.b;

public class B extends Teacher {
	private int number;
	private int salary;
	public B() {
		this("", 0, 0);
	}
	public B(String name, int number, int salary) {
		super(name);
		this.number = number;
		this.salary = salary;
	}
	public int getNumber() {
		return number;
	}
	public void setNumber(int number) {
		this.number = number;
	}
	public int getSalary() {
		return number*salary;
	}
	public void setSalary(int salary) {
		this.salary = salary;
	}
}
