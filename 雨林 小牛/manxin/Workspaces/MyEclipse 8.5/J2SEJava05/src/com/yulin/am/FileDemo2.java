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
		System.out.println("创建完成");
		
		//1.检查当前目录下是否有demo目录
		System.out.println("是否有该文件：" + file.exists());
		
		//2.如果没有demo，则创建demo目录
		try {
			file.createNewFile();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		//3.在demo目录下，创建test1.txt和test2.txt
			try {
				File.createTempFile("text1", ".txt", file);
				File.createTempFile("text2", ".txt", file);
			} catch (IOException e) {
				e.printStackTrace();
			}	
		//4.显示demo目录下的所有文件
		
		//5.显示test1.txt的文件长度
		file.length();
		//6.显示test1.txt的最后修改时间
		long time = file.lastModified();
		System.out.println("最后修改的时间：" + file.lastModified());
		
		
		//7.显示test1.txt的相对路径和绝对路径
		
		//8.删除test2.txt文件
		
		//9.讲test1.txt重命名为text.txt
	
	}

}
