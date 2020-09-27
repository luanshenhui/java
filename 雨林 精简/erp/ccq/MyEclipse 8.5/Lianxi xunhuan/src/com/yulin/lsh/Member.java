package com.yulin.lsh;

public class Member {
	private int id;
	private String name;
	private int age;

	public Member(){
		this("",0);
	}
	
//	public Member(int id, String name, int age) {
//		// TODO Auto-generated constructor stub
//		this.id=id;
//		this.name=name;
//		this.age=age;
//	}

	public Member(String name, int age) {
		this.name=name;
		this.age=age;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
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
	public String toString() {
		return "Member [age=" + age + ", id=" + id + ", name=" + name + "]";
	}

}
