package com.yulin.am;

public class SiBianXing {
	private int l;
	private int w;
	private int h;
	
	public void setW(int w){
		this.w=w;
	}
	
	public int getW(){
		return this.w;
	}
	
	public int mj(int l){
		return l*l;
	}
	
	public int mj(int w,int h){
		return w*h;
	}
	
	public SiBianXing(){	//如果没有自定义构造方法，系统会默认提供一个
		System.out.println("我是父类，四边形~");
	}
	public SiBianXing(int l){
		this.l=l;
		System.out.println("我是父类，四边形，有参数");
	}
	public SiBianXing(int w,int h){
		this.w=w;
		this.h=h;
	}

}
