package com.yulin.pm;

public class StringDemo {

	/**
	 * 字符串拼接
	 * StringBuffer 和  StringBuilder
	 */
	public static void main(String[] args) {
		String str1 = "";
		StringBuffer sb1 = new StringBuffer();
		StringBuilder sb2 = new StringBuilder();
		long time1 = System.nanoTime();
		for(int i = 0; i < 10; i++){
			str1 += i;
		}
		long time2 = System.nanoTime();
		for(int i = 0; i < 10; i++){
			sb1.append(i);
		}
		long time3 = System.nanoTime();
		for(int i = 0; i < 10; i++){
			sb2.append(i);
		}
		long time4 = System.nanoTime();
		System.out.println("String用’+‘号拼接时间:" + (time2 - time1) + " ，拼接的字符串：" + str1);
		System.out.println("StringBuffer时间:" + (time3 - time2) + " ，拼接的字符串：" + sb1);
		System.out.println("StringBuilder时间:" + (time4 - time3) + " ，拼接的字符串：" + sb2.toString());
	}

}
