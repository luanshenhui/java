package com.yulin.pm;
import java.util.Random;
public class Demo1 {
	public static void main(String[]args){
		Random rd = new Random();
		//int in =rd.nextInt(10)+1;//1~10Ëæ»úÊı       
		int in =rd.nextInt(2)*2-1;
		System.out.println(in);
	}

}
