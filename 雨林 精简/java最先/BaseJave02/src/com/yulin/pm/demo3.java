package com.yulin.pm;
import java.util.*;
public class demo3 {
	public static void main(String[] args){
		// Scanner sc=new Scanner(System.in);
		for(int i= 100;i<1000;i++){
			int a =i%10;
			//i/=10;
			int b=(i/10)%10;
			//i/=10;
			int c=(i/100)%10;
			if(i==a*a*a+b*b*b+c*c*c){
				System.out.println(i);
			}
		}
	}

}
