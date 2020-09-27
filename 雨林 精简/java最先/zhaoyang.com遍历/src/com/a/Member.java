package com.a;

public class Member {

	private String name;
	private int age;
	private Company company;
	

	public Member(String name, int age) {
		this.name = name;
		this.age = age;
	}
	@Override
	public String toString() {
		return name + age + company.com;
	}

	public Member() {
		this("");

	}
	public Member(String name) {
		this(name,0);

	}


	public Member (String name, int age, Company company) {
		super();
		this.name = name;
		this.age = age;
		this.company = company;
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

	

	public Company getCompany() {
		return company;
	}

	public void setCompany(Company company) {
		this.company = company;

	}
//	public void setSchool(School school) {

//		this.school=school;
//	}

}
