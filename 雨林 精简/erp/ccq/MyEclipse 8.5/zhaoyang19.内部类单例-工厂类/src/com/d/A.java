package com.d;

/*
 * java种右23种经典设计模式思想,常见问题总结归纳出来的套路
 * 例如:单例模式,工厂模式,代理模式,模板模式,迭代模式,装饰模式
 * 
 * 单例模式:要求类A,在应用中对外只提供唯一的一个对象
 */
public class A {
	private static A a; //= new A();// 2

	private A() {// 1

	}

	public static A getA() {// 3
		if(a==null){				//
		a=new A();
		}							//
		return a;
	}

}
