package com.a;

import java.util.ArrayList;
import java.util.List;

public class A {
	/*
	 * ���ֻ����������Ͷ�Ӧ�ķ�װ��(������)
	 * byte(Byte)
	 * short(Short)
	 * int(Integer)
	 * long(Long)
	 * double(Double)
	 * float(Float)
	 * boolean(Boolean)
	 * char(Character)
	 * 
	 * ΪʲôҪѧ��װ�ࣺ
	 * ԭ��1�����ϣ�(���ϴ洢������������ʹ�á��Զ�װ�����ԭ��)
	 * ���int->�Զ�װ��Integer->�Զ���ӵ�������
	 * ��ȡint->�Զ�����Integer->�Զ���ȡintֵ
	 * 
	 * ԭ��2�����ַ���ת��Ϊ������������
	 */
	
	public static void main(String[] args) {
		List<Integer>list=new ArrayList<Integer>();
		list.add(1);
		list.add(2);
		int a=3;
		list.add(a);//�Զ�װ��
		
		int b=list.get(0);//�Զ�����
		System.out.println(b);
		//8�ֻ�����������ת��Ϊ�ַ�����String.valueOf()����ʵ��
		int a1=2;
		String s=String.valueOf(a1);
		
		a1=Integer.parseInt(s);//ת��int������
		System.out.println(a1);
		
		//double->String
		double a2=2.2;
		String s1=String.valueOf(a2);
		
		a2=Double.parseDouble(s1);
		System.out.println(a2);
	}

}
