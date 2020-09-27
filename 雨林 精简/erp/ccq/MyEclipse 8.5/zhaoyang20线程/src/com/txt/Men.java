package com.txt;

public class Men extends Person {

	public Men(String name, double salary) {
		// TODO Auto-generated constructor stub
		super(name,salary);
	}

	@Override
	public double m123() {
		// TODO Auto-generated method stub
		return this.getSalary();
	}

//	@Override
//	public void m123(Person p) {
//		// TODO Auto-generated method stub
//		
//		
//	}

	

}
