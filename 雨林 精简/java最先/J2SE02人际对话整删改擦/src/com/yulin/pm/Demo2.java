package com.yulin.pm;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

import com.yulin.emp.Emp;

public class Demo2 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		System.out.println("��Ӣʹ��");
		Scanner sc = new Scanner(System.in);

		//String str = sc.next();
		System.out.println("����������");
		int in = sc.nextInt();
		while (2 > 1) {
			switch (in) {
			case 1:
				add();
				break;
			case 2:
				tui();
				break;
			case 3:
				cha();
				break;
			case 4:
				System.err.println();
				System.exit(0);
				break;
			default:
				System.out.println("shur cuowu");
			}
		}
	}

	// list.add(in);

	//	
	private static void cha() {
		// TODO Auto-generated method stub
		for (int i = 0; i < 4; i++) {
			for (int j = 0; j < 5; j++) {
				int room = i * 100 + j;
				System.out.print((map.get(room) != null) ? "�Ѿ�ס" : room + ""
						+ "");
			}
			System.out.println();
		}

	}

	private static void tui() {
		// TODO Auto-generated method stub

		System.out.println("���������˷���");
		int room = sc.nextInt();
		if (map.remove(room) != null)
			System.out.println("�����ɹ�");

		else
			System.out.println("fang��ÿ��");
	}

	static Map<Integer, String> map = new HashMap<Integer, String>();
	static Scanner sc = new Scanner(System.in);

	private static void add() {
		// TODO Auto-generated method stub

		System.out.println("����������");
		String name = sc.next();
		System.out.println("�����뷿���");
		int room = sc.nextInt();
		map.put(room, name);

	}

}