package com.yulin.am;
import java.io.*;
/**
 * 对象流
 */
public class User implements Serializable{//实现序列化接口
	
	private static final long serialVersionUID = -1L;   //出现：java.io.InvalidClassException
	
	private String name;
	private int age;
	
	public User(String name, int age) {
		super();
		this.name = name;
		this.age = age;
	}

	public User() {
		super();
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

	@Override
	public String toString() {
		return "User [age=" + age + ", name=" + name + "]";
	}
}
