package demo;

import java.util.Scanner;

public class BirthDate {
	public static void main(String[] args) {
		System.out.println("请输入您的身份证号:");
		Scanner can = new Scanner(System.in);
		String ID = can.nextLine();
		System.out.println("ID:" + ID);
		while(ID.length() != 18){
			System.out.println("输入有误！");
			ID = can.nextLine();
		}
		String birthdayYear = ID.substring(6, 10);
		String birthdayMon = ID.substring(10, 12);
		String birthdayDay = ID.substring(12, 14);
		System.out.println("您的生日是:" + birthdayYear + "年" + birthdayMon + "月" + birthdayDay + "日");
	}
}
