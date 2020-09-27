package com.yulin.pm;
import java.io.*;

public class CopyDemo3 {

	/**
	 * byte[]�����ļ� ���ǻ�����
	 * ���ʣ���ֽ�������1024���򴴽���������СΪ1024
	 * ���ʣ���ֽ���С��1024���򴴽���������СΪ��ʣ�ֽڵĴ�С
	 */
	public static void main(String[] args) {
		try {
			String path = "src/com/yulin/pm/IODemo1.java";
			File file1 = new File(path);
			File file2 = new File(file1.getName() + "_copy");
			file2.createNewFile();
			
			FileInputStream fis = new FileInputStream(file1);
			FileOutputStream fos = new FileOutputStream(file2);
			while(fis.available() > 0){
				byte[] buff;
				if(fis.available() >= 1024){
					buff = new byte[1024];
				}else{
					int in = fis.available();
					buff = new byte[in];
				}
				fis.read(buff);
				fos.write(buff);
				System.out.println("������ɣ�");
				fis.close();
				fos.close();		
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
