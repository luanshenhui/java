package com.yulin.am;

import com.yulin.com.A;

public class C extends A {
	public static void main(String[] args) {
		A a=new A();
		System.out.println(a.name);
		a.m();
		/*
		 * �������ʱc����a
		 *Ӧ�������� 
		 */
		C c=new C();
		System.out.println(c.name);
		c.m();
	}
}
