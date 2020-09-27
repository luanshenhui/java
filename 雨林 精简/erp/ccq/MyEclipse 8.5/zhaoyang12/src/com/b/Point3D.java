package com.b;

public class Point3D extends Point2D{
	static{
		System.out.println("point3d静态");
	}

	{
		System.out.println("point3d非静态");
	}
	private int k;

	/**
	 * 
	 */
	public Point3D() {
		this(0,0,0);
	}

	public Point3D(int i, int j, int k) {
		super(i,j);
		System.out.println("point3d构造方法");
		this.k=k;
	}

	public int getK() {
		return k;
	}

	public void setK(int k) {
		this.k = k;
	}

	@Override
	public String toString() {
		return "Point3D [i=" + getI() + " J="+ getJ() + " K= "+ k + "]";
	}

}
