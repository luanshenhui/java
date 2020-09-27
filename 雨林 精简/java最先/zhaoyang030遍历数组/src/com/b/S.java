package com.b;

public class S{
	

	private String name;
	private Teacher[]arr=new Teacher[4];
	private int a=0;

	public S(String school) {
		this.name = school;
	}

	public void add(Teacher t) {
		arr[a++]=t;
	}


	public int getSumSalary() {
		int sum=0;
		for(Teacher h:arr){
			  int money = h.getSalary();
			sum+=money;
		}

		return sum;
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

}
