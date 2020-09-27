package com.c;

public class B extends Teacher{

	//private String name;
	private int time;
	private double free;

	public B(String name, int time, double free) {
		//this.name=name;
		this.time=time;
		this.free=free;
	}

//	public String getName() {
//		return name;
//	}
//
//	public void setName(String name) {
//		this.name = name;
//	}

	public int getTime() {
		return time;
	}

	public void setTime(int time) {
		this.time = time;
	}

	public double getFree() {
		return free;
	}

	public void setFree(double free) {
		this.free = free;
	}

	@Override
	public double getSalary() {
		// TODO Auto-generated method stub
		return time*free;
	}

//	@Override
//	public String toString() {
//		return time+free;
//	}

}
