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
			char co = in.charAt(i);// ���ַ�ȡ����
			int index = check(cho, co);
			System.out.println("-----------------------");
			System.out.println("index"+index);
			System.out.println(Arrays.toString(cho));
			System.out.println(co);
			if (index != -1) {//index���±�
				count[index]++;
				System.out.println("!"+Arrays.toString(count));
			} else {
				System.out.println("qian:" + Arrays.toString(cho));
				// ��cho��������(����) Ȼ�������е��������µ���
				cho = Arrays.copyOf(cho, cho.length + 1); // ����
				System.out.println("hou" + Arrays.toString(cho));
				//
				cho[cho.length - 1] = co;// �Ѻ�����ַ��ŵ�ǰ���������
				count = Arrays.copyOf(count, count.length + 1);
				count[count.length - 1] = 1;// ��������Ĵ���,���Ի������
				System.out.println("?"+Arrays.toString(count));
			}
		}
		for (int i = 0; i < cho.length; i++) {
			System.out.println(cho[i] + "������" + count[i] + "��");
		}
	}

	public static int check(char[] cs, char c) {
		// ����c��cs�е��±�
		for (int i = 0; i < cs.length; i++) {
			if (c == cs[i]) {
				return i;

				// System.out.println(Arrays.toString(c));
			}
		}
		return -1;// ���cs��ÿ��cs����ַ��򷵻�-1
	}

	// public static void main1(String[] args) {
	// Scanner sc = new Scanner(System.in);
	//
	// String in = sc.next();
	// char[] ch = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' };
	// int[] count = new int[10];
	// for (int i = 0; i < in.length(); i++) {
	// char c = in.charAt(i);
	// // int a=(int)c-48;//��ֵת��
	// int a = Integer.parseInt(new String(new char[] { c }));// char[]cs=new
	// // char[]{c};//String
	// // s=new
	// // String(cs);//int
	// // a=Integer.parseInt(s);
	// count[a]++;
	// }
	// for (int i = 0; i < ch.length; i++) {
	// System.out.println(ch[i] + "������" + count[i] + "��");
	// }
	// }

}
