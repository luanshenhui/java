package com.yulin.web;

import java.util.ArrayList;

public class MyEL {
	public static int sum(int a, int b){
		return a + b;
	}
	
	//截取字符串
	public static String sub(String str,String beginStr,String endStr){
		return str.substring(str.indexOf(beginStr), str.lastIndexOf(endStr));
	}
	
	//字符串集合
	public static String list(ArrayList<String> arr){
		String s = "";
		for(String str : arr){
			s = s + "," + str;
		}
		return s;
	}
}

/**
 * 1.自定义一个函数，用来截取字符串，subString(str beginStr,endStr)
 *   返回一个新的字符串，既包含前面也包含后面
 * 2.用JSP-Java代码定义一个字符串集合，存入pageContext中
 * 	 自定义一个EL函数，可以输出集合中的所有元素
 */