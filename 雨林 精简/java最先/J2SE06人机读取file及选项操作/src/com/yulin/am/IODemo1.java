package com.yulin.am;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class IODemo1 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		File file=new File("src/demo1.txt");
		try {
		if(!file.exists()){
			file.createNewFile();
		}
		FileReader fr=new FileReader(file);
		BufferedReader br=new BufferedReader(fr);
		while(br.ready()){
			String str=br.readLine();//读一行
			System.out.println(str);
			/*
			 * 从控制台输入姓名，性别，年龄
			 * 循环3次输入，写入demo1
			 * FileWriter bufferedWriter
			 * 升级;1每次输入的信息保存2读取信息控制台输出
			 * 请选择操作1录入数据2擦看数据
			 */
		}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

	}


