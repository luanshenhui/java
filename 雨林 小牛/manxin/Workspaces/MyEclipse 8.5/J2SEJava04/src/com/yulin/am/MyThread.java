package com.yulin.am;

/**
 * 实现Runnable接口
 */

public class MyThread implements Runnable{
	
	//run()方法中的程序，会独占一个线程，独立运行
	@Override
	public void run(){
		System.out.println("Who?");
	}
}
