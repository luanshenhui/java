package com.yulin.Login;

import java.io.*;
import java.util.*;
/**
 * ��д
 */
public class FileUtil {
	//��
	public static ArrayList<String> read(String path) throws IOException{
		File file = new File(path);
		ArrayList<String> list = new ArrayList<String>();
		FileReader fr = new FileReader(file);
		BufferedReader br = new BufferedReader(fr);
		while(br.ready()){
			String in = br.readLine().trim();//trim()ȥ���ַ�����ͷ�Ŀո�
			list.add(in);
		}
		br.close();
		fr.close();
		return list;
	}
	
	/**
	 * @param path	�ļ���·��
	 * @param context	д�������
	 * @throws IOException
	 */
	public static void write(String path, String context) throws IOException{
		File file = new File(path);
		FileWriter fw = new FileWriter(file,true);
		BufferedWriter bw = new BufferedWriter(fw);
			bw.write(context);
			bw.newLine();
			bw.close();
			fw.close();				
	}
}
