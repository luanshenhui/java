package day05;

import java.util.Arrays;
/**
 * Arrays 的 排序算法
 */
public class Demo04 {
	public static void main(String[] args) {
		int[] score = {67, 49, 88, 69, 95};
		Arrays.sort(score);//小 -> 大
		System.out.println(Arrays.toString(score));  
//		我的问题是能不能Arrays.sort(score) 放到toString这个方法里
		//对应的unicode编码  0  48  a 97  A 65
		String[] names = {"Tom", "Jerry", "Andy", "John","0"};
		Arrays.sort(names);
		System.out.println(Arrays.toString(names));
		//使用null 填满 names 
		Arrays.fill(names, null);
		System.out.println(Arrays.toString(names));
		
	}
}


