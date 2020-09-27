package com.e;

public class Student implements Comparable{

	private String name;
	private int grade;

	public Student(String name, int grade) {
		// TODO Auto-generated constructor stub
		this.name=name;
		this.grade=grade;
	}

	@Override
	public String toString() {
		return "Student [grade=" + grade + ", name=" + name + "]";
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getGrade() {
		return grade;
	}

	public void setGrade(int grade) {
		this.grade = grade;
	}

	@Override
	public int compareTo(Object o) {
		Student s=(Student)o;
		return this.getGrade()-s.getGrade();
	}

}
