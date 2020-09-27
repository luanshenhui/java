package com.yulin.com;

public class T {
	public static void main(String[] args) {

		// public void m1(int a) {
		// TODO Auto-generated method stub
		int index = 0;
		for (int i = 2; i < 100; i++) {

			for (int j = 0; j < i; j++) {
				if (i % j == 0) {
					System.out.println("a");
					index++;
				}
				// if (index == 2) {
				// System.out.println(index);
			}
		}
	}

}
