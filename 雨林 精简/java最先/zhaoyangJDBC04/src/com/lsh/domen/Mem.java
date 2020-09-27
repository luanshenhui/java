package com.lsh.domen;

public class Mem extends Basedemon{
	//private int id;
	private String name;
	private int age;
	private Company company;
	
	
	public Mem() {
		this(0,"",0);
	}

	public Mem(int id, String name, int age) {
		super(id);
	//	this.id = id;
		this.name = name;
		this.age = age;
	}
	
//	public int getId() {
//		return id;
//	}
//	public void setId(int id) {
//		this.id = id;
//	}
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
