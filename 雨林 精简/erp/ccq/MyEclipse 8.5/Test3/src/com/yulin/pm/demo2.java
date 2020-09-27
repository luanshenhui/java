package com.yulin.pm;
import java.awt.*;
import java.util.*;
public class demo2 {
	public static void main(String[] args) {

		//Scanner sc = new Scanner(System.in);
		//int in = sc.nextInt();

		// if(in%4!=0||in%4==0||in%400==0){ System.out.print(in+"是闰年");}

		/*
		 * int a = 0, b = 1, c; for(int i=0;i<20;i++){ c=a+b;
		 * System.out.println(c); a=b; b=c; } a=0;b=1; for(int i=0;i<10;i++){
		 * a=a+b; System.out.println(a); b=a+b; System.out.println(b); }
		 */

		
		for (int i = 1; i <=20; i++) {
			int count = 0;
			for(int j = 0 ;j<i;j++){
			if (j % i == 0) {
				count++;
				//in++;
				}
				//count=0;
			}
			//System.out.println(in);
		
		if (count == 2) {
			System.out.println(i+"是质数");
			//count=0;

		} else {
			System.out.println(i+"不是质数");
			//count =0;
		}
		}
	}
}
