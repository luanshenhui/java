package day02;

import java.util.Scanner;

public class Test1 {
	public static void main(String[] args) {
		Scanner sc = new Scanner(System.in);
		int score = sc.nextInt();
		if (score / 10 > 9) {
			System.out.println("����");
		} else if (score / 10 > 8) {
			System.out.println("����");
		} else if (score / 10 > 6) {
			System.out.println("����");
		} else if (score / 10 < 6) {
			System.out.println("������");
		}
	}
}
