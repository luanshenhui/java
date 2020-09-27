package com.yulin.exam.bean;

public class User {
	private String loginId;
	private String pwd;
	private String name;
	private int score;
	private String email;
	
	/*构造方法*/
	public User() {
		super();
	}
	
	public User(String loginId, String pwd, String name, int score, String email) {
		super();
		this.loginId = loginId;
		this.pwd = pwd;
		this.name = name;
		this.score = score;
		this.email = email;
	}
	
	/*get、set 方法*/
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

	public int getScore() {
		return score;
	}

	public void setScore(int score) {
		this.score = score;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	/*改写toString*/
	@Override
	public String toString() {
		return "User [email=" + email + ", loginId=" + loginId + ", name="
				+ name + ", pwd=" + pwd + ", score=" + score + "]";
	}
}
