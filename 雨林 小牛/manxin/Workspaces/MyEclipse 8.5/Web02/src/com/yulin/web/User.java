package com.yulin.web;

public class User {
	private int loginId;
	private int pwd;
	private String name;
	public int getLoginId() {
		return loginId;
	}
	public void setLoginId(int loginId) {
		this.loginId = loginId;
	}
	public int getPwd() {
		return pwd;
	}
	public void setPwd(int pwd) {
		this.pwd = pwd;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public User(int loginId, int pwd, String name) {
		super();
		this.loginId = loginId;
		this.pwd = pwd;
		this.name = name;
	}
	public User() {
		super();
	}
}
