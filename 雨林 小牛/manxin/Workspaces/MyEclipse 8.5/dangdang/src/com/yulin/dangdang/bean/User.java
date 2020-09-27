package com.yulin.dangdang.bean;

import java.io.Serializable;

public class User implements Serializable{
	private static final long serialVersionUID = 1L;
	private int id;
	private String email;
	private String nickname = null;
	private String password;
	private int user_integral = 0;
	private char is_email_verify;
	private String email_verify_code = null;
	private long last_login_time = 0;
	private String last_login_ip = null;
	
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public int getUser_integral() {
		return user_integral;
	}
	public void setUser_integral(int userIntegral) {
		user_integral = userIntegral;
	}
	public char getIs_email_verify() {
		return is_email_verify;
	}
	public void setIs_email_verify(char isEmailVerify) {
		is_email_verify = isEmailVerify;
	}
	public String getEmail_verify_code() {
		return email_verify_code;
	}
	public void setEmail_verify_code(String emailVerifyCode) {
		email_verify_code = emailVerifyCode;
	}
	public long getLast_login_time() {
		return last_login_time;
	}
	public void setLast_login_time(long lastLoginTime) {
		last_login_time = lastLoginTime;
	}
	public String getLast_login_ip() {
		return last_login_ip;
	}
	public void setLast_login_ip(String lastLoginIp) {
		last_login_ip = lastLoginIp;
	}
	public User(int id, String email, String nickname, String password,
			char isEmailVerify) {
		super();
		this.id = id;
		this.email = email;
		this.nickname = nickname;
		this.password = password;
		is_email_verify = isEmailVerify;
	}
	
	public User() {
		super();
	}
	
	@Override
	public String toString() {
		return "User [email=" + email + ", email_verify_code="
				+ email_verify_code + ", id=" + id + ", is_email_verify="
				+ is_email_verify + ", last_login_ip=" + last_login_ip
				+ ", last_login_time=" + last_login_time + ", nickname="
				+ nickname + ", password=" + password + ", user_integral="
				+ user_integral + "]";
	}
	
}
