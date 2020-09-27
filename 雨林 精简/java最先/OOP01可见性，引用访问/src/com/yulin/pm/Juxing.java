package com.yulin.pm;

public class Juxing extends Shape {

	public Juxing(int w, int h) {
		super(w, h);
		// TODO Auto-generated constructor stub
	}
	@Override
	public double zhouchang() {
		double zc = getW()+getH();
		return zc;
	}
	@Override
	public double mianji() {
		double mj = getW()*getH();
		return mj;
	}
}
