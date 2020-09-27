package com.yulin.am;

import java.io.Serializable;

public class User implements Serializable{

	/**
	 * @param args
	 */
//	public static void main(String[] args) {
//		// TODO Auto-generated method stub
//
//	}
	private static final long serialVersionUID=-1L;
	
	private String name;
	
	private int age;

	public User() {
		super();
		// TODO Auto-generated constructor stub
	}
	public User(String name, int age) {
		super();
		this.name=name;
		this.age=age;
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
	
	
	

}
