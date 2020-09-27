package com.a;

import java.util.Date;

public class A {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		/*
		 * 在java中一切皆对象。所有java中的异常也封装成了对象
		 * 
		 * 
		 * 异常
		 * 1java.lang.ArrayIndexOutOfBoundsException:下标越界
		 * 2java.lang.ArithmeticException:算数异常
		 * 3java.lang.NullPointerException：空指针异常
		 * 4ClassCastException
		 */
		int[]arr={1,2,3};
		//System.out.println(arr[3]);
		//System.out.println(3/0);
		String str=null;
		//System.out.println(str.equals("你好"));
		
//		Object obj="abc";
//		Date date=(Date)obj;//(4)java.lang.ClassCastException强制转化异常、
		
		int a=Integer.parseInt("你好");//(5)java.lang.NumberFormatException数字转化异常
	}

}
