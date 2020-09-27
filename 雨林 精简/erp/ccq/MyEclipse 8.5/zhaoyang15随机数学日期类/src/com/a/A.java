package com.a;
import java.lang.*;
import java.util.Random;
public class A {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// 1java的基础语法
		/* 2java的面向对象
		 * 3java的应用程序接口
		 * 
		 */
		//1String
		//调用本报的类可以直接调用,外包的需要import
		String str="倪红";//java会自动调用java.lang.*下面的包,但子文件夹它不会导入(public)'
		System.out.println(str);
		
		//Math数学工具类
		/*
		 * 
		 */
		System.out.println(Math.PI);
		System.out.println("绝对值"+Math.abs(-2));
		System.out.println("最大值"+Math.max(2, 3));
		System.out.println("最小值"+Math.min(2, 3));
		System.out.println("4蛇5如"+Math.round(1.3F));
		System.out.println("4蛇5如"+Math.round(1.3));
		
		
		//Random随机数类
		
		Random r=new Random();
		for(int i=0;i<50;i++){
			System.out.println(r.nextInt());//生成随机的int整数
			//指定区间
			System.out.println(r.nextInt(10));//0~9的随机数
			//题：
			System.out.println(r.nextInt(6)+5);//5~10
		}
		

	}

}
