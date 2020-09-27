package com.yulin.pm;

import java.io.*;

public class CopyDemo2 {

	/**
	 * byte[]�����ļ�
	 */
	public static void main(String[] args) {
		try {
			String path1 = "F:/java/servlet�ʼ�.txt";
			File file1 = new File(path1);
			File file2 = new File(file1.getName() + "_copy");
			file2.createNewFile();
			
			FileInputStream fis = new FileInputStream(file1);
			FileOutputStream fos = new FileOutputStream(file2);
			
			while(fis.available() > 0){
				byte[] buff = new byte[1024];
				fis.read(buff);
				fos.write(buff);
			}
			System.out.println("������ɣ�");
			fis.close();
			fos.close();
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
