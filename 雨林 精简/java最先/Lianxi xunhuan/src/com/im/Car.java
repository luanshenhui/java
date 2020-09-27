package com.im;

public class Car implements Ob{

	private String name;
	private int salary;

	public Car(String name, int salary) {
		// TODO Auto-generated constructor stub
		this.name=name;
		this.salary=salary;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getSalary() {
		return salary;
	}

	public void setSalary(int salary) {
		this.salary = salary;
	}

	@Override
	public String toString() {
		return "Car [name=" + name + ", salary=" + salary + "]";
	}

	@Override
	public boolean ms(Object obj) {
		// TODO Auto-generated method stub
		Car car=(Car)obj;
		return this.getSalary()>car.getSalary();
	}

	

}
