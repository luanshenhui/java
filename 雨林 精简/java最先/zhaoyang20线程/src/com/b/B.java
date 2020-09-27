package com.b;

public class B extends Thread {// 通过继成Thread类实现多线程的方式

	@Override
	public void run() {
		// 多线程执行的功能操作就写在此方法中(核心业务方法)
		while (true) {
			System.out.println(Thread.currentThread().getName());
		}
	}

	public static void main(String[] args) {
		//调用多线程1，new对象
		B b1=new B();
		b1.start();//当我们调用start启动线程时java会调run方法启动线程
		
		B b2=new B();
		b2.start();
		
		B b3=new B();
		b3.start();
	

	}
}
