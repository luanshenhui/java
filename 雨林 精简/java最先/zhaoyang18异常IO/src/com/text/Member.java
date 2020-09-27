package com.text;

public class Member {

	private String name;
	private char sex;
	private int age;
	private double salary;

	public Member(String name, char sex, int age, double salary) {
		// TODO Auto-generated constructor stub
		this.name=name;
		this.sex=sex;
		this.age=age;
		this.salary=salary;
	}

	

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public char getSex() {
		return sex;
	}

	public void setSex(char sex) {
		this.sex = sex;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public double getSalary() {
		return salary;
	}

	public void setSalary(double salary) {
		this.salary = salary;
	}

	@Override
	public String toString() {
		return "Member [age=" + age + ", name=" + name + ", salary=" + salary
				+ ", sex=" + sex + "]";
	}

}
