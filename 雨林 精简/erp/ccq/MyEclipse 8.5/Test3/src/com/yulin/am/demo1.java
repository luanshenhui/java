package com.yulin.am;

import java.util.*;

public class demo1 {
	public static void main(String[] args) {
		for (int kc =50;kc>0;)
			for(int cc =20;cc>0;)
				for(int fc =60;fc>0;)
		{
			System.out.println("麦当劳卖甜筒，4元一杯，第二杯半价!");
			System.out.println("库存"+kc+cc+fc);
			System.out.println("请问你需要什么味？");
			Scanner sc = new Scanner(System.in);
			int in = sc.nextInt();
			in=kc;System.out.print("你要多少杯");
			if(in > kc){
				System.out.println("没那么多..");
			}else{
				int all = (in % 2 == 0) ? (in / 2 * 6) : (in / 2 * 6 + 4);
				System.out.println("你一共购买了；"+in+"杯"+"总价"+all+"元");
				kc-=in;
			}
		}System.out.print("货已经卖完，下班回家");
	}
	}