package com.c;

public abstract class Teacher {
	private String name;
	public Teacher(){
		
	}
public Teacher(String name){
		this.name=name;
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
public abstract double getSalary();


}
