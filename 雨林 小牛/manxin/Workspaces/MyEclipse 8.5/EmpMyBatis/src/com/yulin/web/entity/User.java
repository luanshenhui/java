package com.yulin.web.entity;

import java.io.Serializable;

public class User implements Serializable{
	private static final long serialVersionUID = 1L;
	private String u_loginId;
	private String u_pwd;
	private String u_name;
	private int u_salary;
	private int u_age;
	public String getU_loginId() {
		return u_loginId;
	}
	public void setU_loginId(String uLoginId) {
		u_loginId = uLoginId;
	}
	public String getU_pwd() {
		return u_pwd;
	}
	public void setU_pwd(String uPwd) {
		u_pwd = uPwd;
	}
	public String getU_name() {
		return u_name;
	}
	public void setU_name(String uName) {
		u_name = uName;
	}
	public int getU_salary() {
		return u_salary;
	}
	public void setU_salary(int uSalary) {
		u_salary = uSalary;
	}
	public int getU_age() {
		return u_age;
	}
	public void setU_age(int uAge) {
		u_age = uAge;
	}
	public User(String uLoginId, String uPwd, String uName, int uSalary,
			int uAge) {
		super();
		u_loginId = uLoginId;
		u_pwd = uPwd;
		u_name = uName;
		u_salary = uSalary;
		u_age = uAge;
	}
	public User() {
		super();
	}
	@Override
	public String toString() {
		return "User [u_age=" + u_age + ", u_loginId=" + u_loginId
				+ ", u_name=" + u_name + ", u_pwd=" + u_pwd + ", u_salary="
				+ u_salary + "]";
	}
}
