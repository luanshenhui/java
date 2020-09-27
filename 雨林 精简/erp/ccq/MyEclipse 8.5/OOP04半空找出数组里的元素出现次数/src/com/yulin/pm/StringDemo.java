package com.yulin.pm;

import java.util.Arrays;
import java.util.Scanner;

public class StringDemo {
	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);

		String in = sc.next();
		char[] cho = new char[0];
		int[] count = new int[0];
		for (int i = 0; i < in.length(); i++) {
			char co = in.charAt(i);// 把字符取出来
			int index = check(cho, co);
			System.out.println("-----------------------");
			System.out.println("index"+index);
			System.out.println(Arrays.toString(cho));
			System.out.println(co);
			if (index != -1) {//index是下标
				count[index]++;
				System.out.println("!"+Arrays.toString(count));
			} else {
				System.out.println("qian:" + Arrays.toString(cho));
				// 将cho数组扩容(长度) 然后将数组中的数据重新导入
				cho = Arrays.copyOf(cho, cho.length + 1); // 扩容
				System.out.println("hou" + Arrays.toString(cho));
				//
				cho[cho.length - 1] = co;// 把后面的字符放到前面的数组里
				count = Arrays.copyOf(count, count.length + 1);
				count[count.length - 1] = 1;// 计算出来的次数,可以换别的数
				System.out.println("?"+Arrays.toString(count));
			}
		}
		for (int i = 0; i < cho.length; i++) {
			System.out.println(cho[i] + "出现了" + count[i] + "次");
		}
	}

	public static int check(char[] cs, char c) {
		// 返回c在cs中的下标
		for (int i = 0; i < cs.length; i++) {
			if (c == cs[i]) {
				return i;

				// System.out.println(Arrays.toString(c));
			}
		}
		return -1;// 如果cs中每有cs这个字符则返回-1
	}

	// public static void main1(String[] args) {
	// Scanner sc = new Scanner(System.in);
	//
	// String in = sc.next();
	// char[] ch = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' };
	// int[] count = new int[10];
	// for (int i = 0; i < in.length(); i++) {
	// char c = in.charAt(i);
	// // int a=(int)c-48;//等值转换
	// int a = Integer.parseInt(new String(new char[] { c }));// char[]cs=new
	// // char[]{c};//String
	// // s=new
	// // String(cs);//int
	// // a=Integer.parseInt(s);
	// count[a]++;
	// }
	// for (int i = 0; i < ch.length; i++) {
	// System.out.println(ch[i] + "出现了" + count[i] + "次");
	// }
	// }

}
