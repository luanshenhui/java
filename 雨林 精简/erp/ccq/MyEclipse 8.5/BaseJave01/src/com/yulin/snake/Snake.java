package com.yulin.snake;

import java.util.Arrays;
import java.util.Random;
import java.util.Scanner;

public class Snake {
	/** 属性：高、宽、蛇、方向 */
	private int w = 30;
	private int h = 15;
	private int[][] snake = { { 10, 5 }, { 9, 5 }, { 8, 5 }, { 7, 5 },
			{ 6, 5 }, { 6, 4 }, { 6, 3 }, { 5, 3 }, { 4, 3 }, { 3, 3 }, };
	private int dir = 1; // 1：右; -1:左；10:下；-10:上

	int[][] foods = new int[5][2];

	int food=0;//记录事物当前的数量
	
	
	/** 功能：显示、移动、改变方向 */
	public void show() {
		for (int y = 0; y < h; y++) {
			for (int x = 0; x < w; x++) {
				if (y == 0 || y == h - 1 || x == 0 || x == w - 1) {
					System.out.print("+");
				} else if (snake[0][0] == x && snake[0][1] == y) {
					System.out.print("●");
				} else if (check(x, y)) {
					System.out.print("○");
				} else if (checkFood(x, y)) {
					System.out.print("@");
				} else {
					System.out.print(" ");
				}
			}
			System.out.println();
		}
	}

	private boolean check(int x, int y) {
		// 检测蛇身上的某个关节是否在这个x,y坐标上
		for (int i = 0; i < snake.length; i++) {
			/*
			 * 把二维数组当成一维数组来用 snake[i][0]为第i个点的x坐标， snake[i][1]为第i个点的y坐标。
			 */
			if (snake[i][0] == x && snake[i][1] == y) {
				return true;
			}
		}
		return false;
	}

	public void move() {
		if (isEat()) {
			snake = Arrays.copyOf(snake, snake.length + 1);
			snake[snake.length - 1] = new int[2];
		}
		for (int i = snake.length - 1; i > 0; i--) {
			snake[i][0] = snake[i - 1][0];
			snake[i][1] = snake[i - 1][1];
		}
		// 数组中的每一个元素都向后挪一位。

		/* 生成一个新的蛇头 */// 1：右; -1:左；10:下；-10:上
		int x = dir % 10; // x方向的移动
		int y = dir / 10; // y方向的移动
		snake[0][0] += x;
		snake[0][1] += y;
		// isEat();//每次移动之后都需要判断是否吃到食物。
	}

	public void change() {
		/*
		 * 根据输入的字符“w,a,s,d”改变方向dir 改变方向时，不能直接调头
		 */
		Scanner sc = new Scanner(System.in);
		String str = sc.nextLine();
		if ("w".equals(str)) {
			dir = (dir != 10) ? -10 : 10;
		} else if ("s".equals(str)) {
			dir = (dir != -10) ? 10 : -10;
		} else if ("a".equals(str)) {
			dir = (dir != 1) ? -1 : 1;
		} else if ("d".equals(str)) {
			dir = (dir != -1) ? 1 : -1;
		} else if ("q".equals(str)) {
			System.err.println("#退出游戏#");
			System.exit(0);
		}
	}

	public void createFood() {
		food=5; //	初始化事物的数量//////
		Random rd = new Random();
		for (int i = 0; i < foods.length; i++) {
			int x = rd.nextInt(28) + 1;// 1~28 避免食物在墙上
			int y = rd.nextInt(13) + 1;// 1~13

			/* 将随机出的x,y坐标赋给食物 */
			foods[i][0] = x;
			foods[i][1] = y;
		}
	}

	private boolean checkFood(int x, int y) {
		for (int i = 0; i < foods.length; i++) {
			if (foods[i][0] == x && foods[i][1] == y) {
				return true;
			}
		}
		return false;
	}

	private boolean isEat() {
		for (int i = 0; i < foods.length; i++) {
			if (foods[i][0] == snake[0][0] && foods[i][1] == snake[0][1]) {
				foods[i][0] = -1;
				foods[i][1] = -1;
				// 让食物消失。
				food--;
				if(food<=0){////
					createFood();
				}
				return true;
			}
		}
		return false;
	}
}
