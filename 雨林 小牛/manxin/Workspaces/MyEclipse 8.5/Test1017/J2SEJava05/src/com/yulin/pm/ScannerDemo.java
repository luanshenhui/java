package com.yulin.pm;

import java.util.*;
import java.io.*;

public class ScannerDemo {

	/**
	 * �ӿ���̨���뱣�棬���
	 */
	public static void main(String[] args) {
		File file1 = new File("src/com/yulin/pm/ScannerDemo1.txt");
		try {
			Scanner scan = new Scanner(System.in);
			System.out.println("�����룺");
			byte[] buff = scan.nextLine().getBytes();
			file1.createNewFile();
			FileOutputStream fos = new FileOutputStream(file1);
			FileInputStream fis = new FileInputStream(file1);
			fos.write(buff);
			while(fis.available() > 0){
				int buff1 = fis.read();				
				System.out.println((char)buff1);
			}
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
