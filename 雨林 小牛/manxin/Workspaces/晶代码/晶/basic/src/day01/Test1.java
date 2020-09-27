package day01;

import java.util.Arrays;

/*
 * 董祥龙  
 * java为什么是跨平台的？  jvm java虚拟机     .class  
 * 变量  命名规则：以字母  _ $ 开头  后面可以接 字母  _ $ 数字
 * boolean byte char  short int float double long
 * 1/8byte  8    16    16   32    32   64     64
 * 流程控制语句  if else  for  while do while switch case 
 * 数组。。。。
 * 
 */
public class Test1 {
	//定义一个数组  那么把数组输出有几种方式呢？  三种
	public static void main(String[] args) {
		int[] ary = {1,2,3,4,5,6};
		//输出的是一个地制值  并不能直接的输出数组元素
		System.out.println(ary);
		//1   ??数组的length和string的length有什么区别
		//      answer： 数组的length是一个属性 
		//              string的length是一个方法
		for(int i = 0; i<=ary.length-1; i++){
			System.out.print(ary[i]);
		}
		System.out.println();
		//2  新循环  增强for循环  是企业级开发中比较常用的
		//此for循环  底层是使用迭代器实现的  因为迭代器支持各种框架
		for(int a : ary){
			System.out.print(a);
		}
		System.out.println();
		//3  使用数组自带的api   api：是人家java本身自带的 提供给你
		System.out.println(Arrays.toString(ary));
	}
}
