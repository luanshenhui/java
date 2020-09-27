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
		System.out.println("黄英使用");
		Scanner sc = new Scanner(System.in);

		//String str = sc.next();
		System.out.println("请输入悬着");
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
				System.out.print((map.get(room) != null) ? "已经住" : room + ""
						+ "");
			}
			System.out.println();
		}

	}

	private static void tui() {
		// TODO Auto-generated method stub

		System.out.println("情书热如退房号");
		int room = sc.nextInt();
		if (map.remove(room) != null)
			System.out.println("土方成功");

		else
			System.out.println("fang间每人");
	}

	static Map<Integer, String> map = new HashMap<Integer, String>();
	static Scanner sc = new Scanner(System.in);

	private static void add() {
		// TODO Auto-generated method stub

		System.out.println("请输入姓名");
		String name = sc.next();
		System.out.println("请输入房间号");
		int room = sc.nextInt();
		map.put(room, name);

	}

}