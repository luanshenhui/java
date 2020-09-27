package com.yulin.pm;
import java.util.*;

public class StringDemo {

	public static void main(String[] args) {
		/**java.lang.String 
		 * 从控制台输入一个字符串，屏蔽其中的“共产党”三个字，用***代替
		 */
/*		Scanner scan = new Scanner(System.in);
		System.out.println("请输入一串字符串:");
		String str=scan.next();
		str=str.replace("共产党", "***");
		System.out.println("输入的字符串是："+str);*/
		
		/**从控制台输入一个字符串，记录每个字符出现的个数*/
		Scanner scan = new Scanner(System.in);
		System.out.println("请输入一串字符串:");
		String str=scan.next();

		
		/**从控制台输入一个字符串“1,2,3,4”，将其变成字符串数组{“1”，“2”，“3”，“4”}*/
/*		Scanner scan = new Scanner(System.in);
		System.out.println("请输入一串字符串:");
		String str=scan.next();
		String strs=Arrays.toString(str.toCharArray());
		System.out.println("输入的字符串数组是:"+strs);*/

	}

}
