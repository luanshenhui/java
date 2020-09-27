package com.yulin.pm;

public class Demo1 {
	public static void main(String[] args) {
		for (int i = 1; i <=9; i++) {
			for (int a = 1; a <= i; a++) {
				
				System.out.print(i+"x"+a+"="+a*i+"\t");
			}
			System.out.println();
		}
	}

}
