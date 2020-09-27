package day04;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;

/**
 * 缓冲字符输入流
 * 特点：
 * 以行为单位读取字符串
 * @author Administrator
 *
 */
public class BufferedReaderDemo {
	public static void main(String[] args) throws IOException {
		FileOutputStream fos = new FileOutputStream("ss.txt");
		OutputStreamWriter osw = new OutputStreamWriter(fos);
		BufferedWriter bw = new BufferedWriter(osw);
		bw.write("ssdfddsfsdffsdfjlsdkfjklsdfjlkzs锋来看");
		bw.close();
		/**
		 * 读取java源程序
		 * src/day01/test4.java
		 */
		//1 先创建用于读取文件的FIS
		FileInputStream fis = 
			new FileInputStream(
					"src" + File.separator +
					"day01" + File.separator +
					"test4.java"
			);
		//2 将字节流转换为字符流
		InputStreamReader reader = 
			new InputStreamReader(fis);
		//3 按行读取字符串的字符输入流 
		BufferedReader br = 
			new BufferedReader(reader);
		String str = null;
		/**
		 * String readLine()
		 * 连续读取字符，直到读取到换行符为止。
		 * 将换行符之前的字符组成字符串返回
		 * 当返回值为null时，说明EOF
		 */
		while(
				(str = br.readLine()) != null
		){
			System.out.println(str);
		}
		
		br.close();
	}
}	




