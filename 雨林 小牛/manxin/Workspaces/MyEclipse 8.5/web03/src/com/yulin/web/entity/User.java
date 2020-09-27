package com.yulin.web.entity;

import java.io.Serializable;

public class User implements Serializable{
	private String loginId;
	private String pwd;
	private String name;
	private String sex;
	private int age;
	private String phone;
	private String email;
	private String city;
	
	/*get set*/
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
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	
	/*构造*/
	public User() {
		super();
	}
	public User(String loginId, String pwd, String name, String sex, int age,
			String phone, String email, String city) {
		super();
		this.loginId = loginId;
		this.pwd = pwd;
		this.name = name;
		this.sex = sex;
		this.age = age;
		this.phone = phone;
		this.email = email;
		this.city = city;
	}
	
}
