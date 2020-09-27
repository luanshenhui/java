package com.yulin.am;

import java.util.Scanner;

public class game {
	public static void main(String[] args) {
		System.out.println("开始游戏");
		System.out.println("输入民");
		Scanner sc = new Scanner(System.in);// 创建扫描工具
		String name = sc.next();//
		pet pt = new pet(name);
		pt.亮相();
		while (true) {// 死循环
			System.out.println("`````````````````");
			System.out.println("要干啥");
			System.out.println("1喂食物;2洗澡;3打人;4查看信息;5玩耍");
			int in = sc.nextInt();
			if (in == 1)
				pt.喂食();
			else if (in == 2)
				pt.洗澡();

			else if (in == 3)
				pt.打人();
			else if (in == 4)
				pt.亮相();
			else if (in == 5)
				pt.玩耍();

			else {
				System.out.println("没指令");

			}
		}
	}
}
