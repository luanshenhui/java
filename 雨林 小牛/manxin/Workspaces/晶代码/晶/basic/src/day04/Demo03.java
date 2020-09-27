package day04;

import java.util.Random;
import java.util.Scanner;

/**
 * 猜数字游戏
 * 
 * 数据分析的前提是业务规则
 * 
 * 数据分析：
 *    num 是被猜测数字
 *    answer 是用户猜的答案
 *    count 猜测的次数
 * 
 * 计算方法（计算过程）：
 *    1) 随机生成 num 范围 1~100 
 *    2) 提示用户猜测数据
 *    3) 得到猜测答案 answer
 *    4) 比较用户answer 和 num
 *       4.1 计分 count++ 
 *       4.2 如果相等就结束 游戏
 *       4.3 提示大/小  
 *    5) 返回 (2) 
 *    王勇
 */
public class Demo03 {
	public static void main(String[] args) {
		int num;
		int answer;
		int count = 0;
		Scanner in = new Scanner(System.in);
		//验证码  他的生成 使用random
		Random random = new Random();
		//1是在哪个数开始   100 范围
		num = random.nextInt(100)+1;
		System.out.println("亲，欢迎使用猜数字游戏！(*_^)");
		for(;;){
			System.out.print("猜吧：");
			answer = in.nextInt();
			count++;
			if(num==answer){
				System.out.println("(@_@)对了！分"+count);	
				break;
			}
			if(answer > num){
				System.out.println("猜大了！次数："+count);
			}else{
				System.out.println("猜小了！次数："+count);
			}
		}
	}
}











