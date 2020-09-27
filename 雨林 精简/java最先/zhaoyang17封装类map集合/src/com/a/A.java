package com.a;

import java.util.ArrayList;
import java.util.List;

public class A {
	/*
	 * 八种基本数据类型对应的封装类(类类型)
	 * byte(Byte)
	 * short(Short)
	 * int(Integer)
	 * long(Long)
	 * double(Double)
	 * float(Float)
	 * boolean(Boolean)
	 * char(Character)
	 * 
	 * 为什么要学封装类：
	 * 原因1：集合，(集合存储基本数据类型使用“自动装箱拆箱原理”)
	 * 添加int->自动装箱Integer->自动添加到集合中
	 * 获取int->自动拆箱Integer->自动获取int值
	 * 
	 * 原因2：把字符串转换为基本数据类型
	 */
	
	public static void main(String[] args) {
		List<Integer>list=new ArrayList<Integer>();
		list.add(1);
		list.add(2);
		int a=3;
		list.add(a);//自动装箱
		
		int b=list.get(0);//自动拆箱
		System.out.println(b);
		//8种基本数据类型转换为字符串：String.valueOf()方法实现
		int a1=2;
		String s=String.valueOf(a1);
		
		a1=Integer.parseInt(s);//转回int数据类
		System.out.println(a1);
		
		//double->String
		double a2=2.2;
		String s1=String.valueOf(a2);
		
		a2=Double.parseDouble(s1);
		System.out.println(a2);
	}

}
