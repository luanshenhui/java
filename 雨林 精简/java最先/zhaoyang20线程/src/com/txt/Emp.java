package com.txt;

public class Emp extends Person{

	private double doer;

	public Emp(String name, double salary, double doer) {
		// TODO Auto-generated constructor stub
		super(name,salary);
		this.doer=doer;
	}

	@Override
	public String toString() {
		return this.getName()+this.doer+this.getSalary();
	}

	@Override
	public double m123() {
		// TODO Auto-generated method stub
		return getSalary()+this.doer;
	}

	public double mss() {
		// TODO Auto-generated method stub
		return getSalary()+doer;
	}



//	@Override
//	public void m123(Person p) {
//		// TODO Auto-generated method stub
//		
//	}
	}
