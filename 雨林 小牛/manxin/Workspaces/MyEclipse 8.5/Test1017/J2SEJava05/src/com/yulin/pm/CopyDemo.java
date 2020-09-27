package com.yulin.pm;
import java.io.*;

public class CopyDemo {

	/**
	 * �����ļ�
	 */
	public static void main(String[] args) {
		try {
			String path1 = "src/com/yulin/pm/IODemo1.java";
			File file1 = new File(path1);
			
			String path2 = "src/com/yulin/pm/IODemo1_copy.java";
			File file2 = new File(path2);
			file2.createNewFile();
		
			FileInputStream fis = new FileInputStream(file1);
			FileOutputStream fos = new FileOutputStream(file2);
			while(fis.available() > 0){	//��û��ȡ�����ݳ���
				int in = fis.read();
				fos.write(in);
			}
			System.out.println("������ɣ�");
			fis.close();
			fos.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		//�ҵ�һ��20MB���ϵ��ļ�����������Ŀ�ļ�����
		
	}
}
