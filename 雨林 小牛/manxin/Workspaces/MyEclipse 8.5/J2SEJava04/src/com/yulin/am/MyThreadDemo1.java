package com.yulin.am;

	/**
	 * ���߳�
	 */
public class MyThreadDemo1 {
	
	public static void main(String[] args){
		MyThread mt = new MyThread();
		Thread thr = new Thread(mt);	//����һ���̶߳���
		thr.start();	//�����߳�
		
		System.out.println("��ˮ�ܵ�");
		
		MyThreadDemo2 mt2 = new MyThreadDemo2();
		mt2.start();
		
		Thread thr2 = new Thread(new Runnable(){	//ʵ�ֶ��̵߳�2�ַ���
			public void run(){
				System.out.println("�����ڲ���....");
			}
		});
		thr2.start();
	}

}
