package com.a;
import java.lang.*;
import java.util.Random;
public class A {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// 1java�Ļ����﷨
		/* 2java���������
		 * 3java��Ӧ�ó���ӿ�
		 * 
		 */
		//1String
		//���ñ����������ֱ�ӵ���,�������Ҫimport
		String str="�ߺ�";//java���Զ�����java.lang.*����İ�,�����ļ��������ᵼ��(public)'
		System.out.println(str);
		
		//Math��ѧ������
		/*
		 * 
		 */
		System.out.println(Math.PI);
		System.out.println("����ֵ"+Math.abs(-2));
		System.out.println("���ֵ"+Math.max(2, 3));
		System.out.println("��Сֵ"+Math.min(2, 3));
		System.out.println("4��5��"+Math.round(1.3F));
		System.out.println("4��5��"+Math.round(1.3));
		
		
		//Random�������
		
		Random r=new Random();
		for(int i=0;i<50;i++){
			System.out.println(r.nextInt());//���������int����
			//ָ������
			System.out.println(r.nextInt(10));//0~9�������
			//�⣺
			System.out.println(r.nextInt(6)+5);//5~10
		}
		

	}

}
