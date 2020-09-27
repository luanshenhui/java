package com.d;

public class Person implements All {

	private String name;
	private int age;

	public Person(String name, int age) {
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
	public boolean ms(Object o) {
		Person person=(Person)o;
		return this.getAge()>person.getAge();
	}




	

	

}
