package com.yulin.User;

public class User {
	int t_id;
	String t_name;
	int t_age;
	public int getT_id() {
		return t_id;
	}
	public void setT_id(int tId) {
		t_id = tId;
	}
	public String getT_name() {
		return t_name;
	}
	public void setT_name(String tName) {
		t_name = tName;
	}
	public int getT_age() {
		return t_age;
	}
	public void setT_age(int tAge) {
		t_age = tAge;
	}
	public User() {
		super();
		// TODO Auto-generated constructor stub
	}
	public User(int tId, String tName, int tAge) {
		super();
		t_id = tId;
		t_name = tName;
		t_age = tAge;
	}
	@Override
	public String toString() {
		return "User [t_age=" + t_age + ", t_id=" + t_id + ", t_name=" + t_name
				+ "]";
	}
	
	

}
