package com.pm;

public class Student implements Comparable<Object>{

	private String name;
	private char sex;
	private int age;
	private School school;
	public Student(){
		
	}

	public Student(String name, char sex, int age) {
		// TODO Auto-generated constructor stub
		this.name=name;
		this.sex=sex;
		this.age=age;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public char getSex() {
		return sex;
	}

	public void setSex(char sex) {
		this.sex = sex;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	@Override
	public String toString() {
		return name+" "+age+" "+sex;
	}

	@Override
	public int compareTo(Object o) {
		// TODO Auto-generated method stub
		Student s=(Student)o;
		return this.getAge()-s.getAge();
	}

}
