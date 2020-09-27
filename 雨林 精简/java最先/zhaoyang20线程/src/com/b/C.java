package com.b;

public class C implements Runnable{

	@Override
	public void run() {
		// TODO Auto-generated method stub
		while(true){
			System.out.println(Thread.currentThread().getName());
		}
	}
	public static void main(String[] args) {
		C c1=new C();
		Thread t1=new Thread(c1);
		t1.start();
		
		C c2=new C();
		Thread t2=new Thread(c2);
		t2.start();
		
		System.out.println(Thread.currentThread().getName());//就打印一次
	}
}
