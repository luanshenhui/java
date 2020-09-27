package day03;

import java.util.Scanner;

/**
 * while和do while的区别：
 * dao。。。  while（rst。next（））
 * 
 * while（布尔表达式）｛
 * 	方法体
 * ｝
 * while 循环
 * 
 * while(循环条件(布尔表达式)(1)){
 *   //循环体(2)
 * } 
 * (3)
 * while 的执行流程
 * {(1)-true->(2)}->{(1)-true->(2)}->(1)-false->结束(3)
 * 
 * while循环"一般用在"与次数无关的循环
 * 案例：保证控制台输入的分数在 0~100 之间
 */
public class Demo12 {
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		int score = -1;/*0*/
		while(score <0 || score>100/*1*/){
			System.out.print("输入分数（0~100）：");
			score = in.nextInt();/*2*/
		}
		System.out.println("分数："+score);/*3*/
//(0 socre=-1)->{(1 -1<0||-1>100)-true->(2 score=120)}->
//{(1 120<0||120>100)-true->(2 score=-3)}->
//{(1 -3<0||-1>100)-true->(2 score=85)}->
//(1 85<0||85>100)-false->(3 println(85))  
	}
}





