package com.a;

public class Men {

	private String name;
	private Com com;

	public Men(String name) {
		// TODO Auto-generated constructor stub
		this.name=name;
	}

	public Com getCom() {
		return com;
	}

	public void setCom(Com com) {
		this.com = com;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public String toString() {
		return this.name;
	}

}
