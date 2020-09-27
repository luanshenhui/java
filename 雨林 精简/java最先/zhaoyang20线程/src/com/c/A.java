package com.c;

public class A {
	private static A a;

	private A() {

	}

	// 此种方法线程不安全，需要添加synchronized关键字,可以保证线程安全
	// 同步方法(synchronized修饰的方法)，不加就是非同步方法
	/*
	 * 在java中，每个对象都有一个锁 如果方法是同步方法，线程在进入方法之前会检查当前类的对象时否被加锁，如果加锁在外等候，如果没加锁则可进入。
	 * 当线程进入同步方法，则会对类进行加锁，当方法结束后会对类对象解锁
	 */
	public/* synchronized */static A getA() {
		String s = "你好";// 随便定一个对象
		synchronized (s) {// 对对象加锁
			if (a == null) {
				a = new A();
			}
		}
		return a;
	}
}
