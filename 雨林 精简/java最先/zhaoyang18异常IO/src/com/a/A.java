package com.a;

import java.util.Date;

public class A {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		/*
		 * ��java��һ�нԶ�������java�е��쳣Ҳ��װ���˶���
		 * 
		 * 
		 * �쳣
		 * 1java.lang.ArrayIndexOutOfBoundsException:�±�Խ��
		 * 2java.lang.ArithmeticException:�����쳣
		 * 3java.lang.NullPointerException����ָ���쳣
		 * 4ClassCastException
		 */
		int[]arr={1,2,3};
		//System.out.println(arr[3]);
		//System.out.println(3/0);
		String str=null;
		//System.out.println(str.equals("���"));
		
//		Object obj="abc";
//		Date date=(Date)obj;//(4)java.lang.ClassCastExceptionǿ��ת���쳣��
		
		int a=Integer.parseInt("���");//(5)java.lang.NumberFormatException����ת���쳣
	}

}
