package day02;

import java.util.Scanner;

/**
 * ʹ�� if else ʵ�� ��� abc�������� 
 * 
 *   a  b  c   
 * 1) max = a;
 * 2) b > max -> true 
 *     max = b
 * 3) c > max -> true
 *     max = c 
 */
public class Demo15 {
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		int a,b,c,max;
		System.out.print("���� a b c:");
		a = in.nextInt();
		b = in.nextInt();
		c = in.nextInt();
		max = a;
		if(b>max){
			max = b;
		}
		if(c>max){
			max = c;
		}
		System.out.println("MAX:"+max);
	}
}





