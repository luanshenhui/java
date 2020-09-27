package com.yulin.am;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.InputMismatchException;
import java.util.Scanner;

public class IODemo2 {
	public static File file = new File("src/lianxi1.doc");

	public static void main(String[] args) {

		System.out.println("请选择你的操作");
		System.out.println("1录入信息");
		System.out.println("2擦看信息");
		Scanner sc = new Scanner(System.in);
		int in=sc.nextInt();
		if (in == 1)
			try {
				input();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		else if (in == 2)
			try {
				output();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

	}

	private static void output()throws IOException{
		// TODO Auto-generated method stub
		FileReader fr=new FileReader(file);
		BufferedReader br = new BufferedReader(fr);
		while(br.ready()){
			System.out.println("姓名"+br.readLine());
			System.out.println("xingbie"+br.readLine());
			System.out.println("nianling"+br.readLine());
			System.out.println("~~~~~~~~~");
		}
		br.close();
		fr.close();

	}

	private static void input()throws IOException {
		// TODO Auto-generated method stub
		FileWriter fw = new FileWriter(file,true);
		BufferedWriter bw = new BufferedWriter(fw);
		// FileInputStream is=new FileInputStream(file);
		Scanner sc = new Scanner(System.in);
		System.out.println("请输入你的姓名");
		String str = sc.nextLine();
		bw.write(str);
		bw.newLine();// 另起一行
		System.out.println("请输入你的姓别");
		str = sc.nextLine();
		
		bw.write(str);
		bw.newLine();
		System.out.println("请输入你的年龄");
		str = sc.nextLine();
		
		bw.write(str);
		bw.newLine();
		bw.close();
		fw.close();

	}

}
