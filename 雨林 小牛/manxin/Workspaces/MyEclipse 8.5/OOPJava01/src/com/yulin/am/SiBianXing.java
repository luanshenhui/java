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
	
	public SiBianXing(){	//���û���Զ��幹�췽����ϵͳ��Ĭ���ṩһ��
		System.out.println("���Ǹ��࣬�ı���~");
	}
	public SiBianXing(int l){
		this.l=l;
		System.out.println("���Ǹ��࣬�ı��Σ��в���");
	}
	public SiBianXing(int w,int h){
		this.w=w;
		this.h=h;
	}

}
