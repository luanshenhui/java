package com.yulin.pm;

public class Circle extends Shape{

	public Circle(int r) {
		super(r);
		// TODO Auto-generated constructor stub
	}

	/**
	 * 继承Shape
	 */
	
	@Override	//声明覆盖
	public double zhouChang(){	//改写父类中周长的方法
		double zc = 2*Math.PI*getR();
		return zc;
	}
	
	@Override
	public double mianJi(){
		double mj=Math.PI*getR()*getR();
		return mj;
	}
	
	


}
