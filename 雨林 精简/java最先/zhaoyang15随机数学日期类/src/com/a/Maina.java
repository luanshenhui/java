package com.a;

public class Maina {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		m1(100);

	}

	private static void m1(int i) {
		// TODO Auto-generated method stub
		for (i = 0; i < 100; i++) {
			if (m2(i)) {
				System.out.println(i);
				;
			}

		}
	}

	private static boolean m2(int i) {
		// TODO Auto-generated method stub
		return false;
	}

}
