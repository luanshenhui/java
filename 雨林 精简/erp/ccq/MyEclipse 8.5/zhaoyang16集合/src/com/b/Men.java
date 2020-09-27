package com.b;

public class Men {

	private String name;
	private String sex;
	private int age;
	private Com company;

	public Men(String name,int age) {
		// TODO Auto-generated constructor stub
		this.name=name;
		
		this.age=age;
		
	}
	public Men(String name, String sex, int age) {
		// TODO Auto-generated constructor stub
		this.name=name;
		this.sex=sex;
		this.age=age;
		
	}


	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public Com getCompany() {
		return company;
	}

	public void setCompany(Com company) {
		this.company = company;
	}

	@Override
	public String toString() {
		return "Men [age=" + age  + ", name=" + name
				+ ", sex=" + sex + "]";
	}

	

}
