package com.yulin.web.entity;

import java.io.Serializable;

public class User implements Serializable{
	private String loginId;
	private String pwd;
	private String name;
	private int age;
	private int salary;
	public User(String loginId, String pwd, String name) {
		super();
		this.loginId = loginId;
		this.pwd = pwd;
		this.name = name;
	}
	public User() {
		super();
	}
	public User(String loginId, String pwd, String name, int age, int salary) {
		super();
		this.loginId = loginId;
		this.pwd = pwd;
		this.name = name;
		this.age = age;
		this.salary = salary;
	}
	public String getLoginId() {
		return loginId;
	}
	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
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
	public int getSalary() {
		return salary;
	}
	public void setSalary(int salary) {
		this.salary = salary;
	}
}
	