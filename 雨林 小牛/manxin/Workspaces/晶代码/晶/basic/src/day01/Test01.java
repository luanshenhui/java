package day01;

import java.util.Scanner;

public class Test01 {
	public static void main(String[] args){
		Scanner con = new Scanner(System.in);
		System.out.println("��������������λ��");
		double s=con.nextInt();
		double t;
		double g = 9.8;
		t = Math.sqrt((2*s)/g);
		System.out.print("��������ʱ��"+t);
	}
}
