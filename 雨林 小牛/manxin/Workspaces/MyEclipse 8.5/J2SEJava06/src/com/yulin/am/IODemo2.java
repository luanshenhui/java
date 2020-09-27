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
	 * �ӿ���̨���������Ϣ���������Ա�����
	 * ���������Ϣд��demo1.txt
	 * FileWriter BufferedWriter
	 * ������
	 * 1.��ÿ���������Ϣ����
	 * 2.�����е���Ϣ��ȡ�����ڿ���̨��ӡ���
	 * ��ѡ�����Ĳ�����
	 * 1.¼������
	 * 2.�鿴����
	 */
	private static File file = new File("src/demo1.txt");
	public static void main(String[] args) {
		while(true){
			System.out.println("��ѡ�����Ĳ�����");
			System.out.println("1.¼����Ϣ");
			System.out.println("2.�鿴��Ϣ");
			
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
		//������Ϣ
		FileWriter fw = new FileWriter(file,true);
		BufferedWriter bw = new BufferedWriter(fw);
		Scanner scan = new Scanner(System.in);
		System.out.println("��������������:");
		String str = scan.nextLine();
		bw.write(str);
		bw.newLine();//����һ��
		System.out.println("�����������Ա�");
		str = scan.nextLine();
		bw.write(str);
		bw.newLine();//����һ��
		System.out.println("��������������");
		str = scan.nextLine();
		bw.write(str);
		bw.newLine();//����һ��
		bw.close();
		fw.close();
		//�������ӵͼ����߼����ر������Ӹ߼����ͼ�
	}
	private static void output() throws IOException{
		// �鿴��Ϣ
		FileReader fr = new FileReader(file);
		BufferedReader br = new BufferedReader(fr);
		while(br.ready()){
			System.out.println("������" + br.readLine());
			System.out.println("�Ա�" + br.readLine());
			System.out.println("���䣺" + br.readLine());
			System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
		}
		br.close();
		fr.close();
	}

}
