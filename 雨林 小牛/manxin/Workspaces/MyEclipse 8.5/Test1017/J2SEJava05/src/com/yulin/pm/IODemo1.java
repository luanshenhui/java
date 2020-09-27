package com.yulin.pm;
import java.io.*;

public class IODemo1 {

	/**
	 * IO 输入输出流
	 */
	public static void main(String[] args) {
		//输出流
		File file = new File("src/demo1.txt");
		try {
			if(!file.exists()){
				file.createNewFile();
			}
			
			//默认的书写格式是覆盖，第二个参数如果是true则变成追加
//			OutputStream os = new FileOutputStream(file,true);
			OutputStream os = new FileOutputStream(file);
			
			os.write(123);
			os.write('A');
			
			os.close();
			
			//输入流
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
