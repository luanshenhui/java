package com.yulin.pu;

public class Member extends Farther implements P{

	private int salary;

	public Member(String name, int age, int salary) {
		super(name, age);
		this.salary = salary;
	}

	public int getSalary() {
		return salary;
	}

	public void setSalary(int salary) {
		this.salary = salary;
	}

	@Override
	public void print() {
		System.out.println(this.getName() + this.getAge() + this.getSalary());

	}

	@Override
	public String toString() {
		return "Ãû×Ö"+this.getName()+"ÄêÁä"+this.getAge()+"Ğ½Ë®"+this.getSalary();
	}

}
