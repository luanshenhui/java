package com.d;

/*
 * java����23�־������ģʽ˼��,���������ܽ���ɳ�������·
 * ����:����ģʽ,����ģʽ,����ģʽ,ģ��ģʽ,����ģʽ,װ��ģʽ
 * 
 * ����ģʽ:Ҫ����A,��Ӧ���ж���ֻ�ṩΨһ��һ������
 */
public class A {
	private static A a; //= new A();// 2

	private A() {// 1

	}

	public static A getA() {// 3
		if(a==null){				//
		a=new A();
		}							//
		return a;
	}

}
