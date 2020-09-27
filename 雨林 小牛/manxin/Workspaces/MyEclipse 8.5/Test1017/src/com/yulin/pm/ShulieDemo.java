package com.yulin.pm;
import java.util.*;

public class ShulieDemo {

	/**
	 * 预热：输入一个年份，判断是否是闰年
	 * 闰年：能被4整除，不能被100整除，但是可以被400整除
	 * 
	 * 练习一：输出费布拉奇数列的前20位
	 * 0,1,1,2,3,5,8,13，21......
	 * 前两位已知，数列从第三位开始
	 * 
	 * 练习二：判断一个数是否是质数
	 * 质数：只能被1和它本身整除的数
	 */
	public static void main(String[] args) {
		//预热
		/*Scanner scan = new Scanner(System.in);
		while(true){
			System.out.print("请输入一个年份：");
			int year=scan.nextInt();
			if(year%4==0 && year%100!=0 || year%400==0){
				System.out.println("闰年！");
				break;
			}
			else{
				System.out.println("不是,请重新输入：");
			}
		}*/
		
		//练习1
	/*	int a=0,b=1,c;//方法1
		for(int i=0;i<20;i++){
			c=a+b;
			System.out.println(c);
			a=b;
			b=c;
		}*/
		
		/*int a=0,b=1;//方法2
		for(int i=0;i<10;i++){
			a=a+b;
			System.out.println(a);
			b=b+a;
			System.out.println(b);
		}*/
			
		
		//练习2
		/*Scanner scan = new Scanner(System.in);
		System.out.print("请输入一个数字：");
		int number=scan.nextInt();
		int count=0;
		for(int i=1;i<=number;i++)
		{
			if(number%i==0){
				count++;				
			}		
		}
		if(count==2){
			System.out.println("您输入的是质数！");
		}else{
			System.out.println("您输入的不是质数");
		}*/
		
		//输出20以内所有的质数
	
		
		int count=0;
		for(int i=1;i<=20;i++){
			count = 0;
			for(int j=1;j<=i;j++)
			{
				if(i%j==0){
					count++;				
				}		
			}
			if(count==2){
				System.out.println("质数:"+i);
			}
		}
		
		
		

	}

}
