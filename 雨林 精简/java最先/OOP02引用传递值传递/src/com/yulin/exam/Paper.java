package com.yulin.exam;

import java.util.Scanner;

public class Paper {
	private Choice[] 选择题;
	private String[] 用户答案;

	public Paper() {

	}

	public Paper(Choice[] 选择题) {
		this.选择题 = 选择题;
		this.用户答案 = new String[选择题.length];// 用户答案的个数等于选择题的个数

	}

	public void show() {// 利用循环显示选择题
		for (int i = 0; i < 选择题.length; i++) {
			选择题[i].显示();
			用户答案[i] = 答题2();
		}

	}

	public void 答题() {
		Scanner sc = new Scanner(System.in);
		for (int i = 0; i < 用户答案.length; i++) {
			用户答案[i] = sc.next();
		}
	}

	public String 答题2() {
		System.out.print("你的答案是；");
		Scanner sc = new Scanner(System.in);
		return sc.next();
		// 用户答案[i]=sc.next();
	}

	private int score = 0;

	public int 交卷() {// 交卷b

		for (int i = 0; i < 选择题.length; i++) {
			if (选择题[i].判断正确(用户答案[i])) {
				score += 选择题[i].get得分();
			}
		}
		return score;
	}

	public void 显示得分() {
		System.out.println("你最后的得分是；" + score);
	}
}

// 显示；利用循环显示选择题
// 答题，利用Scanner获得用户答案
// 交卷，判断用户答案正确与否
// 显示得分；
