package com.yulin.am;

public class Demo1 {
	public static void main(String[] args){
		byte num1 = 129;//整数默认int、
		int num2 = 2.0;//小数默认double
		System.out.println(5/3);//自动类型转换
		char num3 ='中';
		System.out.println(num3);
		System.out.println((int)num3);//强制类型转换
		System.out.println(Integer.toBinaryString((int)num3));//2进制强制转换
		System.out.println(Integer.toHexString((int)num3));//16进制强制类型转换
		//TODO
		boolean num4 = true;
		//System.println((int)num4);类型不匹配，不能强制转换
	}

}
