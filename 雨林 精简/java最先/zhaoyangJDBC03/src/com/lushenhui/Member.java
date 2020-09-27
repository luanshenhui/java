package com.lushenhui;

public class Member {
	private String name;
	private String sex;
	private double salary;
	private int id;
	private String department;

	public Member() {
		this("", "", 0.0, 0, "");
	}

	public Member(String name, String sex, double salary, int id,
			String department) {
		super();
		this.name = name;
		this.sex = sex;
		this.salary = salary;
		this.id = id;
		this.department = department;
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

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
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
