package com.yulin.am;
import java.io.*;

public class IODemo1 {

	/**
	 * 字符流，对象流
	 */
	public static void main(String[] args) {
		File file = new File("src/demo1.txt");
		//所有的高级IO流都是以低级流作为基础
		try {
			if(!file.exists()){
				file.createNewFile();
			}
//			FileInputStream fis = new FileInputStream(file);
			FileReader fr = new FileReader(file);
			BufferedReader br = new BufferedReader(fr);
			while(br.ready()){
				String str = br.readLine();	//读一行
				System.out.println(str);
			}
				
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}

}
