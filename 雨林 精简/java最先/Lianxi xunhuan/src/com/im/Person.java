package com.im;

public class Person implements Ob {

	private String name;
	private int age;

	public Person(String name, int age) {
		// TODO Auto-generated constructor stub
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

	@Override
	public String toString() {
		return "Person [age=" + age + ", name=" + name + "]";
	}

	@Override
	public boolean ms(Object obj) {
		// TODO Auto-generated method stub
		Person person=(Person)obj;
		return this.getAge()>person.getAge();
	}

	

}
