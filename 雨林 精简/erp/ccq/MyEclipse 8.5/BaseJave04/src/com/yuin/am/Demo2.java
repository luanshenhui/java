package com.yuin.am;

public class Demo2 {
	public static void main(String[] args) {

		// int[][] snake = new int[10][2];
		int[][] snake = { 
				{ 10, 5 }, 
				{ 9, 5 }, 
				{ 8, 5 }, 
				{ 7, 5 }, 
				{ 6, 5 },
				{ 5, 5 }, 
				{ 5, 4 }, 
				{ 5, 3 }, 
				{ 4, 3 }, 
				{ 3, 3 }, 
				};
		for (int y = 0; y < 10; y++) {
			for (int x = 0; x < 20; x++) {
				if (y == 0 || y == 9 || x == 0 || x == 19) {
					System.out.print("+");
				} else if (snake[0][0] == x && snake[0][1] == y) {
					System.out.print("G");
				} else if (check(snake, x, y)) {
					System.out.print("o");
				} else {
					System.out.print(" ");
				}
			}
			System.out.println();
		}

	}

	public static boolean check(int[][] ins, int z, int h) {//		创造蛇的数列变量以便直接引用结果
		for (int i = 0; i < ins.length; i++) {

			if (ins[i][0] == z && ins[i][1] == h) {
				return true;
			}

		}
		return false;

	}
}
