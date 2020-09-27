package com.zhaoyang04;

public class Mem {

	private String name;
	private int age;
	private Company company;
	
	/**
	 * @param name
	 * @param age
	 * @param company
	 */
	public Mem() {
		// TODO Auto-generated constructor stub
	}
	public Mem(String name, int age) {
		super();
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
	public Company getCompany() {
		return company;
	}
	public void setCompany(Company company) {
		this.company = company;
	}
	@Override
	public String toString() {
		return "Mem [age=" + age + ", company=" + company + ", name=" + name
				+ "]";
	}
	
}
