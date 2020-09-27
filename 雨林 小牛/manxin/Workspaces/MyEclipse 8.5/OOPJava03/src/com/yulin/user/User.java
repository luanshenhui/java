package com.yulin.user;
import java.io.*;

public class User implements Serializable{
	/**
	 * 快捷键生成的类	Alt	+ Shift + S
	 */
	private static final long serialVersionUID = 1L;
	private String userName;
	private String passWord;
	private String name;
	private int age;
	private char sex;
	
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getPassWord() {
		return passWord;
	}
	public void setPassWord(String passWord) {
		this.passWord = passWord;
	}
	public User(String userName, String passWord, String name, int age, char sex) {
		super();
		this.userName = userName;
		this.passWord = passWord;
		this.name = name;
		this.age = age;
		this.sex = sex;
	}
	public String getName() {
		return name;
	}
	public User() {
		super();
		// TODO Auto-generated constructor stub
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
	public char getSex() {
		return sex;
	}
	public void setSex(char sex) {
		this.sex = sex;
	}
	 

}
