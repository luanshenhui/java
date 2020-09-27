package com.yulin.pu;

public abstract class Farther {
	private String name;
	private int age;

	public Farther(String name,int age){
		this.name=name;
		this.age=age;
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

	
	
}
