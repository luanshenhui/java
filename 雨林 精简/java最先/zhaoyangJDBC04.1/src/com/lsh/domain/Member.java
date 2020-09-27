package com.lsh.domain;

public class Member {
	private int id;
	private String name;
	private String sex;
	private double salary;
	private String department;

	public Member() {
		super();
	}

	public Member(int id, String name, String sex, double salary,
			String department) {
		super();
		this.id = id;
		this.name = name;
		this.sex = sex;
		this.salary = salary;
		this.department = department;
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

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public double getSalary() {
		return salary;
	}

	public void setSalary(double salary) {
		this.salary = salary;
	}

	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	@Override
	public String toString() {
		return "Member [department=" + department + ", id=" + id + ", name="
				+ name + ", salary=" + salary + ", sex=" + sex + "]";
	}

}
