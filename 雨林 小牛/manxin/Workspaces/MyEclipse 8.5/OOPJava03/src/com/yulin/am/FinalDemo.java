package com.yulin.am;

public class FinalDemo {
	public static void main(String[] argd){
		
	}

}

class Boo{
	public final void boo(){}
	final int a=1;
	final int b;
	public static final int c=0;	//常量
	public Boo(){
		b=1;
//		b=2;	//final变量只能被赋值一次
	}
}

class Booo extends Boo{
//	@Override 
//	public final void boo(){}	//final修饰的方法， 不能被重写
}
