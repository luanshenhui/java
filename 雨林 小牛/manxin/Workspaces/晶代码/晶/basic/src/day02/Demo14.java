package day02;

import java.util.Scanner;

/**
 * ������жϹ�ʽΪ��
 * 1 ����ܱ�4�������Ҳ��ܱ�100�����������ꡣ
 * 2 ����ܱ�400�����������ꡣ
 * int year;
 */
public class Demo14 {
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		boolean isLeapYear;
		System.out.print("������ݣ�");
		int year = in.nextInt();//2000
		isLeapYear = ( year%4==0 && !(year%100==0)) ||
			(year%400 == 0);
		if(isLeapYear){
			System.out.println(year+"������");
		}else{
			System.out.println(year+"��������");
		}
	}
}






