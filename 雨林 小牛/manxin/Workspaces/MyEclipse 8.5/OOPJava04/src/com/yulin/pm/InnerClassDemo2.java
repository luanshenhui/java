package com.yulin.pm;

/** 
 * �����ڲ����Ӧ��
 */

public class InnerClassDemo2 {
	public static void main(String[] args){
		Woo woo = new Woo(){
			//�����ڲ���ʵ�����Ǵ�����һ�������������
			@Override
			public void woo(){
				System.out.println("������������...");
			}
			//�����ڲ���ɷ񴴽����췽��
			//public Woo(){};
		};
		woo.woo();
	}
}

class Woo{
	public void woo(){
		System.out.println("����Woo...");
	}
}