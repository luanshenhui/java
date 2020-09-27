package com.yulin.am;
import java.util.*;

public class ExceptionDemo {

	/**
	 * 异常处理
	 */
	static String[] is = new String[5];
	public static void main(String[] args) throws Exception{
		while(true){
			try{
				Scanner scan = new Scanner(System.in);
				int i = scan.nextInt();
				System.out.println("您输入的是：" + i);
				break;
			}catch(InputMismatchException ime){
//				throw new Exception("输入的信息有误！");
				ime.printStackTrace();	//打印错误信息
				continue;
			}
		}
		System.out.println("程序结束！");
	}

}
