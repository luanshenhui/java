package com.yulin.pm;

public class StringDemo {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String str1 = " ";
		StringBuffer sb1 = new StringBuffer();
		StringBuilder sb2 = new StringBuilder();
		long time1 = System.nanoTime();
		for (int i = 0; i < 10; i++) {
			str1 += i;//字符串相加就是拼接阿=a+b+c'
		}
		long time2 = System.nanoTime();
		for (int i = 0; i < 10; i++) {
			sb1.append(i);
		}
		long time3 = System.nanoTime();
		for (int i = 0; i < 10; i++) {
			sb2.append(i);

		}
		long time4 = System.nanoTime();
		System.out.println(time2-time1+":"+str1);
		System.out.println(time3-time2+":"+sb1);
		System.out.println(time4-time3+":"+sb2.toString());
	}
}