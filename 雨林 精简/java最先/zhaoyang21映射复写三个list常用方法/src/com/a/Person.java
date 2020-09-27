package com.a;

public class Person extends B implements C,D{
	private String name;
	private int age;

	public Person() {
		super();
	}

	public Person(String name, int age) {

		this.name = name;
		this.age = age;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	@Override
	public void m123() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public boolean m4(String ss, int ii) {
		// TODO Auto-generated method stub
		return false;
	}
}
