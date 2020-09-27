package com.lsh.domain;

import java.util.ArrayList;
import java.util.List;

/**
 * 
 * @author 栾慎辉
 * 
 *         2015-2-2上午10:21:59
 *         
 *         用户表
 */
public class Person extends BaseDomain{
//	private long id;
	
	private String username;
	private String password;
	private String sex;
	private int age;
	private String email;
	private long phone;
	private double salary;
//	private List<Stock>list=new ArrayList<Stock>();
//	private List<Sell>list2=new ArrayList<Sell>();
	private Roleaction roleaction=new Roleaction();
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

//	public long getId() {
//		return id;
//	}
//
//	public void setId(long id) {
//		this.id = id;
//	}
	


	public Roleaction getRoleaction() {
		return roleaction;
	}

	public void setRoleaction(Roleaction roleaction) {
		this.roleaction = roleaction;
	}
//	public List<Sell> getList2() {
//		return list2;
//	}

//	public void setList2(List<Sell> list2) {
//		this.list2 = list2;
//	}

	public String getUsername() {
		return username;
	}

//	public List<Stock> getList() {
//		return list;
//	}
//
//	public void setList(List<Stock> list) {
//		this.list = list;
//	}

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

	@Override
	public String toString() {
		return "Person [age=" + age + ", email=" + email + ", password=" + password + ", phone=" + phone + ", salary="
				+ salary + ", sex=" + sex + ", username=" + username + "]";
	}

}
