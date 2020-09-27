package com.yulin.Login;

import java.io.*;

public class User implements Serializable{
	private static final long serialVersionUID = 1L;
	private String loginId;
	private String pwd;
	private String name;
	private String email;
	private int score = -1;	//小于0表示没有参加过考试
	public User() {
		super();
	}
	public User(String loginId, String pwd, String name, String email) {
		super();
		this.loginId = loginId;
		this.pwd = pwd;
		this.name = name;
		this.email = email;
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
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public int getScore() {
		return score;
	}
	public void setScore(int score) {
		this.score = score;
	}
	@Override
	public String toString() {
		return "User [email=" + email + ", loginId=" + loginId + ", name="
		+ name + ", pwd=" + pwd + ", score=" + score + "]";
	}
}
