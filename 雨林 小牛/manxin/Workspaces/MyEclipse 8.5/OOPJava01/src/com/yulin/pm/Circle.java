package com.yulin.pm;

public class Circle extends Shape{

	public Circle(int r) {
		super(r);
		// TODO Auto-generated constructor stub
	}

	/**
	 * �̳�Shape
	 */
	
	@Override	//��������
	public double zhouChang(){	//��д�������ܳ��ķ���
		double zc = 2*Math.PI*getR();
		return zc;
	}
	
	@Override
	public double mianJi(){
		double mj=Math.PI*getR()*getR();
		return mj;
	}
	
	


}
