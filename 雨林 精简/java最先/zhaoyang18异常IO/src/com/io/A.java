package com.io;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.BufferedInputStream;
import java.io.FileReader;
import java.io.IOException;

//java23�����ģʽ֮  װ��ģʽ
/*
 * һ:java�� I/O
 * 1)�ֽ��������ֽڵķ�ʽ��д
 *     �ֽ�������InputStream(��)���ֽ������(д)  OutputStream//ȫ�ǳ�����
 * 2)�ַ������������ķ�ʽ��д
 *     �ַ�������Reader���ַ������Writer//ȫ�ǳ�����
 *     
 * ����    ��ȡ�ļ���д���ļ�������
 */
public class A {
	public static void main(String[] args) {
		FileReader in = null;
		BufferedReader bu=null;
		
		try {
			File file = new File("f:\\file.txt");// ����һ���ļ�����
			 in = new FileReader(file);// �����ļ��ֽ�������
			 bu = new BufferedReader(in);// ���������ַ�������(�ַ�)
			// ���ж�ȡ�ı�
			String str = "";
			while ((str = bu.readLine()) != null) {
				System.out.println(str);
			}
			//�ر�io��

		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("����ļ�·���쳣");
		} catch (IOException e) {
			e.printStackTrace();
		}finally{
			try {
				bu.close();
				in.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}

	}

}
