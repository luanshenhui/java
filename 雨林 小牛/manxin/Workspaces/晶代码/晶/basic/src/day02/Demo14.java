package day02;

import java.util.Scanner;

/**
 * 闰年的判断公式为：
 * 1 年份能被4整除，且不能被100整除的是闰年。
 * 2 年份能被400整除的是闰年。
 * int year;
 */
public class Demo14 {
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		boolean isLeapYear;
		System.out.print("输入年份：");
		int year = in.nextInt();//2000
		isLeapYear = ( year%4==0 && !(year%100==0)) ||
			(year%400 == 0);
		if(isLeapYear){
			System.out.println(year+"是闰年");
		}else{
			System.out.println(year+"不是闰年");
		}
	}
}






