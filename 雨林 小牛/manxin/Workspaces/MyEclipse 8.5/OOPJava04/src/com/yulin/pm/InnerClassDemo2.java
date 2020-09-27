package com.yulin.pm;

/** 
 * 匿名内部类的应用
 */

public class InnerClassDemo2 {
	public static void main(String[] args){
		Woo woo = new Woo(){
			//匿名内部类实际上是创建了一个类的匿名子类
			@Override
			public void woo(){
				System.out.println("我是匿名子类...");
			}
			//匿名内部类可否创建构造方法
			//public Woo(){};
		};
		woo.woo();
	}
}

class Woo{
	public void woo(){
		System.out.println("我是Woo...");
	}
}