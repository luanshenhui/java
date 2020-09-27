package com.b;

public class Member {

	private String name;
	private int age;
	
	/*
	 * 补充一：
	 * 让set集合自定义类型的对象 的实现的方法
	 * 1，复写Object Hashcode 方法
	 * 2，复写Object equals方法
	 * 
	 */

	public Member(String name, int age) {
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

	@Override
	public int hashCode() {
		// TODO Auto-generated method stub
		return 1;
	}
	
	

	@Override
	public boolean equals(Object obj) {
		// TODO Auto-generated method stub
		Member m=(Member)obj;
		boolean boo=(this.getName().equals(m.getName())&&this.getAge()==m.getAge());
		return boo;
	}

	@Override
	public String toString() {
		return "Member [age=" + age + ", name=" + name + "]";
	}

}
