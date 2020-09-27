package com.b;

public class Point2D extends Point1D{
	static{
		System.out.println("point2d静态");
	}

	{
		System.out.println("point2d非静态");
	}
	private int j;

	/**
	 * 
	 */
	public Point2D() {
		this(0,0);
	}

	public Point2D(int i, int j) {
		super(i);
		System.out.println("point2d构造方法");
		this.j=j;
	}

	public int getJ() {
		return j;
	}

	public void setJ(int j) {
		this.j = j;
	}

	@Override
	public String toString() {
		return "Point2D [j=" + j +" i="+ getI()+"]";
	}

}
