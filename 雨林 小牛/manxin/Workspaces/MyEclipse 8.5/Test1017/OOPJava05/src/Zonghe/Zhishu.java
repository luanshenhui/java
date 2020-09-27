package Zonghe;
import java.util.*;

public class Zhishu {

	/**
	 * 1.判断一个数是否是质数
	 * 质数：只能被1和它本身整除的数
	 * 
	 * 2.输出20以内的质数
	 */
	public static void main(String[] args) {
		// 1.
		Scanner scan = new Scanner(System.in);
		System.out.println("请输入一个数字：");
		int in = scan.nextInt();
		int count = 0;
		for(int i = 1; i <= in; i++){
			if(in % i == 0){
				count++;
			}
		}
		if(count == 2){
			System.out.println("您输入的是质数！");
		}else{
			System.out.println("您输入的不是质数！");
		}
		
		//2.
		int count1 = 0;
		for(int i = 1;i <= 20;i++){
			count1 = 0;
			for(int j = 1; j <= i; j++){
				if(i % j == 0){
					count1++;
				}
			}
			if(count1 == 2){
				System.out.println("20以内的质数：" + i);
			}
		}
		
	}

}
