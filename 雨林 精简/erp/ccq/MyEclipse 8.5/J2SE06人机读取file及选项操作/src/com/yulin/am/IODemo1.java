package com.yulin.am;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class IODemo1 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		File file=new File("src/demo1.txt");
		try {
		if(!file.exists()){
			file.createNewFile();
		}
		FileReader fr=new FileReader(file);
		BufferedReader br=new BufferedReader(fr);
		while(br.ready()){
			String str=br.readLine();//��һ��
			System.out.println(str);
			/*
			 * �ӿ���̨�����������Ա�����
			 * ѭ��3�����룬д��demo1
			 * FileWriter bufferedWriter
			 * ����;1ÿ���������Ϣ����2��ȡ��Ϣ����̨���
			 * ��ѡ�����1¼������2��������
			 */
		}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

	}


