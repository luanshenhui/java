package com.yulin.am;
import java.util.*;

public class WhileDemo {

	public static void main(String[] args) {
		/**while 练习：从控制台进行输入操作，输入任意数，并且输出，当输入为0时，结束输入
		 * 		升级版：从控制台输入任意多个整数，当输入为0时，结束输入，输出最大值
		 */
		/*Scanner scan = new Scanner(System.in);
		System.out.println("请输入一个整数：");
		int a=1;
		int max=a;
		while(a!=0){
			a=scan.nextInt();
			if(a>max){
				max=a;
				
			}
			//System.out.println("您输入的整数为:"+a);
		}
		System.out.println("您输入的最大整数为:"+max);*/
		
		/**do while
		 * 练习同上
		 */
	/*	Scanner scan = new Scanner(System.in);
		System.out.println("请输入一个整数:");
		int a=0;
		int max=0;
		do{
			//定义变量可以放在do里面
			a=scan.nextInt();
			if(a>max){
				max=a;
			}
		//	System.out.println("请您输入的整数是:"+a);
		}while(a!=0);
		System.out.println("您输入最大的整数是："+max);*/
		
		/**for 请输入一个数，如果输入的是奇数则继续输入，如果输入的是偶数则跳出循环*/
		/*Scanner scan = new Scanner(System.in);
		int in=-1;
		for(System.out.println("请输入一个数字：");in%2!=0;System.out.println("请再输入一个数字：")){
			in=scan.nextInt();
			System.out.println("您输入的数字是："+in);
		}*/
		/**for 输出图形 实心矩形，三角，倒三角，等腰*/
	/*	for(int i=0;i<4;i++){//矩形
			for(int j=0;j<5;j++){
				System.out.print("*");
			}
			System.out.println();
		}*/
		
	/*	for(int i=0;i<4;i++){//三角形
			for(int j=0;j<=i;j++)
			{
				System.out.print("*");
			}
			System.out.println();
		}*/
		
	/*	for(int i=0;i<4;i++){//倒三角
			for(int j=0;j<4-i;j++){
				System.out.print("*");
			}
			System.out.println();
		}*/
		
/*		for(int i=0;i<4;i++){//反方向倒三角
			for(int j=0;j<=i;j++){
				System.out.print(" ");
			}
			for(int j=0;j<4-i;j++){
				System.out.print("*");
			}
			System.out.println();
		}*/
		
/*		for(int i =0;i<4;i++){//等腰三角
			for(int j=0;j<4-i;j++){
				System.out.print(" ");
			}
			for(int j=0;j<2*i+1;j++){
				System.out.print("*");
			}
			System.out.println();
		}*/
		
		/**乘法表
		 */
		for(int i=1;i<=9;i++){
			for(int j=1;j<=i;j++){
				System.out.print(j+"×"+i+"="+(i*j)+"\t");
			}
			System.out.println();
		}
		
		/**			*
		 * 		   * *
		 * 		  *	  *
		 * 		 *******
		 * 		* *   * *				未完成
		 * 	   *   * *   *
		 * 	  *************
		 */
	/*	for(int i=0;i<7;i++){
			for(int j=0;j<7-i;j++){
				System.out.print(".");
			}
			for(int j=0;j<2*i+1;j++){
				if(j==0 || i==6 || j==2*i){
					System.out.print("*");
				}else{
					System.out.print(" ");
				}
			}
			System.out.println();*/
		/*	for(int j=0;j<3;j++){//倒的空心等腰
			for(int a=0;a<=j+1;a++){
				System.out.print(".");
			}
			for(int a=0;a<5-2*j;a++){
				if(a==0 || a==4-(2*j) || j==0)
				{
					System.out.print("*");
				}else{
					System.out.print(" ");
				}
			}
			System.out.println();
	//	}*/
	
//		}
		
	}

}
