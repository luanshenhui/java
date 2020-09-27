package com.c;

public class S {

	private String name;
	private Teacher[] arr=new Teacher[4];
	private int i=0;

	public S(String name) {
		this.name=name;
	}

	public void add(Teacher t) {
		arr[i++]=t;
		
	}

	public double getSumSalary() {
		int sum=0;
		for(Teacher t:arr){
			double s=t.getSalary();
			sum+=s;
		}
		return sum;
	}

}
