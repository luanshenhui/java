package com.io;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.BufferedInputStream;
import java.io.FileReader;
import java.io.IOException;

//java23种设计模式之  装饰模式
/*
 * 一:java的 I/O
 * 1)字节流：以字节的方式读写
 *     字节输入流InputStream(读)，字节输出流(写)  OutputStream//全是抽象类
 * 2)字符流：以字流的方式读写
 *     字符输入流Reader，字符输出流Writer//全是抽象类
 *     
 * 二：    读取文件和写入文件的例子
 */
public class A {
	public static void main(String[] args) {
		FileReader in = null;
		BufferedReader bu=null;
		
		try {
			File file = new File("f:\\file.txt");// 创建一个文件对象
			 in = new FileReader(file);// 创建文件字节输入流
			 bu = new BufferedReader(in);// 创建缓冲字符输入流(字符)
			// 按行读取文本
			String str = "";
			while ((str = bu.readLine()) != null) {
				System.out.println(str);
			}
			//关闭io流

		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("检测文件路径异常");
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
