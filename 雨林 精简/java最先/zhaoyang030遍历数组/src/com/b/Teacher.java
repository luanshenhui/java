package com.b;

public abstract class Teacher {

	private String name;

	// private int number;
	// private int salary;

	public Teacher() {

	}

	public Teacher(String name) {
		this.name = name;

	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public String toString() {
		return name;
	}

	public abstract int getSalary();

}
