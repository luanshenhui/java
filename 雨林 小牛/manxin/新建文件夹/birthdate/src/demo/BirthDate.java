package demo;

import java.util.Scanner;

public class BirthDate {
	public static void main(String[] args) {
		System.out.println("�������������֤��:");
		Scanner can = new Scanner(System.in);
		String ID = can.nextLine();
		System.out.println("ID:" + ID);
		while(ID.length() != 18){
			System.out.println("��������");
			ID = can.nextLine();
		}
		String birthdayYear = ID.substring(6, 10);
		String birthdayMon = ID.substring(10, 12);
		String birthdayDay = ID.substring(12, 14);
		System.out.println("����������:" + birthdayYear + "��" + birthdayMon + "��" + birthdayDay + "��");
	}
}
