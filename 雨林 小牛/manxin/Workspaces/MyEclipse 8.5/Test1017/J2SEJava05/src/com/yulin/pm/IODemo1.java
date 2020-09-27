package com.yulin.pm;
import java.io.*;

public class IODemo1 {

	/**
	 * IO ���������
	 */
	public static void main(String[] args) {
		//�����
		File file = new File("src/demo1.txt");
		try {
			if(!file.exists()){
				file.createNewFile();
			}
			
			//Ĭ�ϵ���д��ʽ�Ǹ��ǣ��ڶ������������true����׷��
//			OutputStream os = new FileOutputStream(file,true);
			OutputStream os = new FileOutputStream(file);
			
			os.write(123);
			os.write('A');
			
			os.close();
			
			//������
			FileInputStream is = new FileInputStream(file);
			int in = is.read();
			int in2 = is.read();
			System.out.println((char)in);
			System.out.println((char)in2);
			is.close();
		} catch (IOException e) {
				e.printStackTrace();
		}
		
		
	}

}
