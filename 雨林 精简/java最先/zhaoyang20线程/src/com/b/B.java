package com.b;

public class B extends Thread {// ͨ���̳�Thread��ʵ�ֶ��̵߳ķ�ʽ

	@Override
	public void run() {
		// ���߳�ִ�еĹ��ܲ�����д�ڴ˷�����(����ҵ�񷽷�)
		while (true) {
			System.out.println(Thread.currentThread().getName());
		}
	}

	public static void main(String[] args) {
		//���ö��߳�1��new����
		B b1=new B();
		b1.start();//�����ǵ���start�����߳�ʱjava���run���������߳�
		
		B b2=new B();
		b2.start();
		
		B b3=new B();
		b3.start();
	

	}
}
