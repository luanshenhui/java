package com.yulin.am;

import java.util.Scanner;

public class game {
	public static void main(String[] args) {
		System.out.println("��ʼ��Ϸ");
		System.out.println("������");
		Scanner sc = new Scanner(System.in);// ����ɨ�蹤��
		String name = sc.next();//
		pet pt = new pet(name);
		pt.����();
		while (true) {// ��ѭ��
			System.out.println("`````````````````");
			System.out.println("Ҫ��ɶ");
			System.out.println("1ιʳ��;2ϴ��;3����;4�鿴��Ϣ;5��ˣ");
			int in = sc.nextInt();
			if (in == 1)
				pt.ιʳ();
			else if (in == 2)
				pt.ϴ��();

			else if (in == 3)
				pt.����();
			else if (in == 4)
				pt.����();
			else if (in == 5)
				pt.��ˣ();

			else {
				System.out.println("ûָ��");

			}
		}
	}
}
