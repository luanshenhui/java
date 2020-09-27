package com.a;
/*
 * 并发：单处理器。在某一时刻只有一个线程执行。
 * 并行：多处理器。可以在某一个时刻多个线程执行。
 * 
 * 我们之前写的程序都是单线程的程序。
 * 
 * java中怎样实现多线程的程序
 * 
 * java中实现两种线程的方法(要求掌握两种实现方法及调用)
 * 方法1：直接继成Thread类。
 * 方法2：实现Runnable接口实现多线程。
 * 
 * 线程不安全的问题和以及处理方法：
 * 什么情况会线程不安全：当多个线程访问同一个资源会线程不安全。
 * 1)同步方法可以处理多线程不安全的问题，synchronized
 * 2)同步块,在语句块前加关键字
 * 
 * 
 */
public class A {
	public static void main(String[] args) {
		while(true){
			System.out.println(Thread.currentThread().getName());//线程。当前线程。名字
		}
		
	}

}
