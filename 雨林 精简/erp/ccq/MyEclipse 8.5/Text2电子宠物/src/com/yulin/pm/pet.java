package com.yulin.pm;

import java.util.*;

public class pet {

	String name;
	int age;
	int 经验 = -100;
	int level;
	int 饥饿 = 10;
	int 清洁 = 10;
	int 心情 = 10;
	int 叛逆 = 10;

	// 洗澡；减少饥饿增加清洁，玩耍增加心情将少清洁和饥饿挨打会增加叛逆减少心情
	public pet(String name) {// 宠物初始化 把输入的名字给它
		this.name = name;
		// age=0;
		System.out.println("我贪生了");
		成长();

	}

	private void 成长() {
		new Timer().schedule(new TimerTask() {
			@Override
			public void run() {
				经验 += 10;

				if (经验 >= 100) {
					age += 1;
					经验 = 0;
				}
				饥饿 -= 1;
				if (饥饿 <= 0) {
					System.out.println("下辈子不做狗");
					System.out.print("game over");
					System.exit(0);
				}
				清洁 -= 10;
				if (清洁 == 0) {
					System.out.print("我要洗澡");
				}

			}
		}, 3000, 1000);
	}

	public void 亮相() {
		System.out.println("名字" + name);
		System.out.println("年龄" + age);
		System.out.println("饥饿" + 饥饿);
		System.out.println("清洁" + 清洁);
		System.out.println("心情" + 心情);
		System.out.println("叛逆" + 叛逆);
	}

	public void 洗澡() {
		清洁 += 20;
		饥饿 -= 800;
		if (清洁 > 100) {
			清洁 = 100;

			System.out.print("洗澡去");

		}
	}

	public void 打人() {
		System.out.print("生气找打");
	}

	public void 玩耍() {
		心情 += 20;
		清洁 -= 2000;
	}

	public void 喂食() {
		饥饿 += 30;//
		if (饥饿 >= 100) {
			饥饿 = 100;
			System.out.print(name + "再喂就疯了");
		} else {
			System.out.print(name + "吧唧");
		}

	}

}