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

		System.out.println("��ѡ����Ĳ���");
		System.out.println("1¼����Ϣ");
		System.out.println("2������Ϣ");
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
			System.out.println("����"+br.readLine());
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
		System.out.println("�������������");
		String str = sc.nextLine();
		bw.write(str);
		bw.newLine();// ����һ��
		System.out.println("����������ձ�");
		str = sc.nextLine();
		
		bw.write(str);
		bw.newLine();
		System.out.println("�������������");
		str = sc.nextLine();
		
		bw.write(str);
		bw.newLine();
		bw.close();
		fw.close();

	}

}
