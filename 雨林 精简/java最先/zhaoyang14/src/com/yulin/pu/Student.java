package com.yulin.pu;

public class Student extends Farther implements P{

	private int age;

	public Student(String name, int age) {
		// TODO Auto-generated constructor stub
		super(name, age);

	}

	@Override
	public void print() {
		System.out.println(this.getName() + this.getAge());

	}
}
