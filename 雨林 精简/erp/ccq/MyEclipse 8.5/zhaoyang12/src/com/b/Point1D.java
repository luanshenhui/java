package com.b;

public class Point1D {
static{
	System.out.println("point1d��̬");
}

{
	System.out.println("point1d�Ǿ�̬");
}
	private int i;

	/**
	 * 
	 */
	public Point1D() {
		this(0);
	}

	public Point1D(int i) {
		System.out.println("point1d���췽��");
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
