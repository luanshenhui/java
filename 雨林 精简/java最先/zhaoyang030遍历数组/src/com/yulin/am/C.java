package com.yulin.am;

import com.yulin.com.A;

public class C extends A {
	public static void main(String[] args) {
		A a=new A();
		System.out.println(a.name);
		a.m();
		/*
		 * 子类对象时c不是a
		 *应该是下面 
		 */
		C c=new C();
		System.out.println(c.name);
		c.m();
	}
}
