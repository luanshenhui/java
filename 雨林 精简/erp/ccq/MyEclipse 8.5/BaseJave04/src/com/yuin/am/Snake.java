package com.yuin.am;

import java.util.*;

public class Snake {
	public int k1(int[] ran, int[] inpu) {
		int count = 0;
		for (int i = 0; i < ran.length; i++) {
			for (int j = 0; j < inpu.length; j++) {
				if (ran[i] == inpu[j]) {
					count++;
					break;

				}
			}
		}
		return count;
	}

	public int k2(int[] rand, int[] input) {
		int count = 0;
		for (int i = 0; i < input.length; i++) {
			if (rand[i] == input[i]) {
				count++;
			}
		}
		return count;
	}

	public int[] sz() {
		Random rd = new Random();
		int[] rand2 = new int[4];
		for (int i = 0; i < 4; i++) {
			rand2[i] = rd.nextInt(10);

		}
		return rand2;
	}

	public int[] sr() {
		Scanner sc = new Scanner(System.in);
		int[] input2 = new int[4];
		System.out.println("please set in");
		int in = sc.nextInt();

		for (int i = 3; i > 0; i--) {
			input2[i] = in % 10;
			in /= 10;
		}
		return input2;
	}

	public void star() {
		int[] a = sz();
		int[] b = sr();
		int count = 1;
		while (2 > 1) {
			int c = k1(a, b);
			int d = k2(a, b);
			System.out.println(c + "," + d);
			if (d == 4) {
				System.out.println("game over");
				System.out.print("totle are" + count);
				break;
			} else {
				count++;
				System.out.println("ceshi");
				a= sz();
			}
		}
	}

	public static void main(String[] args) {
		Snake gn = new Snake();
		gn.star();
	}
}