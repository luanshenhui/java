package day03;

import java.util.Scanner;

/**
 * switch ... case  语句演示
 * switch: 开关
 * case: 在...情况下
 * break: 打断
 */
public class Demo03 {
	public static void main(String[] args) {	
		Scanner in = new Scanner(System.in);
		System.out.print("输入百分制分数：");
		//从控制台输入分数
		int score = in.nextInt();//85;
		String level;//级别
		//switch()里放的整型表达式
		switch(score/10){//10 ~ 0
		//case 整型
		case 10:
		case 9: level = "中等"; break;
		case 8: level = "良好"; break;
		case 7: level = "中等"; break;
		case 6: level = "及格"; break;
		default: level = "不及格";
		}
		System.out.println("级别："+level); 
	}
}





