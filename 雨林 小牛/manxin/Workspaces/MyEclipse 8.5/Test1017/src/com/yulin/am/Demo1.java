package com.yulin.am;
import java.util.*;

public class Demo1 {

	/**
	 * 甜筒库50个  第二杯半价
	 * 超出库存 显示没那么多  重新输入
	 * 全部卖完 下班
	 */
	public static void main(String[] args) {
		for(int kc=50;kc>0;){
			System.out.println("甜筒，4元一个，第二杯半价！");
			System.out.println("库存还剩："+kc);
			Scanner scan = new Scanner(System.in);
			System.out.println("需要几个?");
			int in = scan.nextInt();
			if(in>kc){
				System.out.println("没有那么多~！");
			}else{
				int sum = 0;
				sum=in/2*6+in%2*4;
				System.out.println("一共购买了："+in+"个，一共:"+sum+"元");
				kc-=in;
			}
		}
		System.out.println("已经卖完了，可以下班了~");
		
	}

}
