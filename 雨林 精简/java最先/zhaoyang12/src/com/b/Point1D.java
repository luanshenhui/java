package com.b;

public class Point1D {
static{
	System.out.println("point1d静态");
}

{
	System.out.println("point1d非静态");
}
	private int i;

	/**
	 * 
	 */
	public Point1D() {
		this(0);
	}

	public Point1D(int i) {
		System.out.println("point1d构造方法");
		this.i=i;
		
	}

	public int getI() {
		return i;
	}

	public void setI(int i) {
		this.i = i;
	}

	@Override
	public String toString() {
		return ""+this.i;
	}
	

}
