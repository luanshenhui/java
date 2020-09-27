package com.yulin.am;

	/**
	 * 多线程
	 */
public class MyThreadDemo1 {
	
	public static void main(String[] args){
		MyThread mt = new MyThread();
		Thread thr = new Thread(mt);	//创建一个线程对象
		thr.start();	//启动线程
		
		System.out.println("修水管的");
		
		MyThreadDemo2 mt2 = new MyThreadDemo2();
		mt2.start();
		
		Thread thr2 = new Thread(new Runnable(){	//实现多线程的2种方法
			public void run(){
				System.out.println("匿名内部类....");
			}
		});
		thr2.start();
	}

}
