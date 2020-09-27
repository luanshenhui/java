package com.dongxianglong.domain;

import java.util.ArrayList;
import java.util.List;

/**
 * 
 * 
 */
public class Person extends BaseDomain {

	private String username;

	private String password;

	private String sex;

	private int age;

	private String email;

	private long phone;

	private double salary;

	public Person() {
		this("", "", "", 0, "", 0, 0.0);
	}

	public Person(String username, String password, String sex, int age,
			String email, long phone, double salary) {
		super();
		this.username = username;
		this.password = password;
		this.sex = sex;
		this.age = age;
		this.email = email;
		this.phone = phone;
		this.salary = salary;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
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

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public long getPhone() {
		return phone;
	}

	public void setPhone(long phone) {
		this.phone = phone;
	}

	public double getSalary() {
		return salary;
	}

	public void setSalary(double salary) {
		this.salary = salary;
	}

	public static void main(String[] args) {
		// Person p=new Person();
		// System.out.println(p.getId());

	}

}
