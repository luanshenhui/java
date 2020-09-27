package com.yulin.am;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;

public class IODemo2 {

	/**
	 * 从控制台输入个人信息：姓名、性别、年龄
	 * 将输入的信息写入demo1.txt
	 * FileWriter BufferedWriter
	 * 升级：
	 * 1.将每次输入的信息保存
	 * 2.将所有的信息读取并且在控制台打印输出
	 * 请选择您的操作：
	 * 1.录入数据
	 * 2.查看数据
	 */
	private static File file = new File("src/demo1.txt");
	public static void main(String[] args) {
		while(true){
			System.out.println("请选择您的操作：");
			System.out.println("1.录入信息");
			System.out.println("2.查看信息");
			
			Scanner scan = new Scanner(System.in);
			int in = scan.nextInt();	//*****
			if(in == 1){
				try {
					input();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}else if(in == 2){
				try {
					output();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

	}
	
	private static void input() throws IOException {
		//输入信息
		FileWriter fw = new FileWriter(file,true);
		BufferedWriter bw = new BufferedWriter(fw);
		Scanner scan = new Scanner(System.in);
		System.out.println("请输入您的姓名:");
		String str = scan.nextLine();
		bw.write(str);
		bw.newLine();//另起一行
		System.out.println("请输入您的性别");
		str = scan.nextLine();
		bw.write(str);
		bw.newLine();//另起一行
		System.out.println("请输入您的年龄");
		str = scan.nextLine();
		bw.write(str);
		bw.newLine();//另起一行
		bw.close();
		fw.close();
		//打开流，从低级到高级，关闭流，从高级到低级
	}
	private static void output() throws IOException{
		// 查看信息
		FileReader fr = new FileReader(file);
		BufferedReader br = new BufferedReader(fr);
		while(br.ready()){
			System.out.println("姓名：" + br.readLine());
			System.out.println("性别：" + br.readLine());
			System.out.println("年龄：" + br.readLine());
			System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
		}
		br.close();
		fr.close();
	}

}
