package day02;

import java.util.Scanner;

/**
 * 分页：真分页 假分页 查询了数据库的部分数据
 * 假如一共有12条数据 那么一页有5条 一共有三页
 * 变量名字  输入的 rows   一页有size 10 
 * 一共有多少也  pages  
 * 
 * 
 * 
 * 根据查询结果数量和页面大小计算分页数量。 
 *   int rows = 34; 查询结果数量 在控制台上输入的
 *   int size = 10; 页面大小
 *   int pages = ? // 4
 *   
 *   如果整除（余数是0）就用整除结果，否则 整除+1
 */
public class Demo10 {
	public static void main(String[] args) {
//		Scanner in = new Scanner(System.in);
//		System.out.print("输入行数：");
//		int rows = in.nextInt();
//		int size = 10;
//		int pages;
//		if(rows%size == 0){
//			pages = rows/size;
//		}else{
//			pages = rows/size+1;
//		}
//		//pages = rows%size == 0 ? rows/size : rows/size+1;
//		System.out.println("分页数量："+pages);
		Scanner sc = new Scanner(System.in);
		int rows = sc.nextInt();
		int size = 10;
		//?号前面的是一个布尔表达式相当于if（）里面的东西
		//冒号前面的值是当布尔表达式成立的时候的值
		//冒号后面的值是当布尔表达式不成立的时候的值
		//三目运算符
		int pages = rows%size ==0?rows/size:rows/size+1;
//		if(rows%size ==0){
//			pages=rows/size;
//		}else{
//			pages = rows/size+1;
//		}
		//输出语句尽量不要有业务逻辑
		//+是java中唯一一个重载运算符号
		//+号两端如果有一端是字符串  那么结果就是一个字符串类型
		System.out.println(pages);
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}





