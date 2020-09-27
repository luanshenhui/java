package day01;

import java.util.Scanner;

public class Test01 {
	public static void main(String[] args){
		Scanner con = new Scanner(System.in);
		System.out.println("请输入物体下落位移");
		double s=con.nextInt();
		double t;
		double g = 9.8;
		t = Math.sqrt((2*s)/g);
		System.out.print("物体下落时间"+t);
	}
}
