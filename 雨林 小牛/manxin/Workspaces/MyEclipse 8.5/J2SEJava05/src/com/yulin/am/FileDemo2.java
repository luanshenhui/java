package com.yulin.am;
import java.io.*;
import java.text.*;
import java.util.*;

public class FileDemo2 {


	/**
	 * @param args
	 */
	public static void main(String[] args) {
		String path = "J2SEJava05/demo";
		File file = new File(path);
//		file.mkdirs();
		System.out.println("�������");
		
		//1.��鵱ǰĿ¼���Ƿ���demoĿ¼
		System.out.println("�Ƿ��и��ļ���" + file.exists());
		
		//2.���û��demo���򴴽�demoĿ¼
		try {
			file.createNewFile();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		//3.��demoĿ¼�£�����test1.txt��test2.txt
			try {
				File.createTempFile("text1", ".txt", file);
				File.createTempFile("text2", ".txt", file);
			} catch (IOException e) {
				e.printStackTrace();
			}	
		//4.��ʾdemoĿ¼�µ������ļ�
		
		//5.��ʾtest1.txt���ļ�����
		file.length();
		//6.��ʾtest1.txt������޸�ʱ��
		long time = file.lastModified();
		System.out.println("����޸ĵ�ʱ�䣺" + file.lastModified());
		
		
		//7.��ʾtest1.txt�����·���;���·��
		
		//8.ɾ��test2.txt�ļ�
		
		//9.��test1.txt������Ϊtext.txt
	
	}

}
