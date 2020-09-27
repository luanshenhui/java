package com.yulin.am;
import java.io.*;
import java.util.*;
public class FileUtil {
	public static ArrayList<String> read(String path)throws IOException{
		File file = new File(path);
		ArrayList<String> list = new ArrayList<String>();
		FileReader fr = new FileReader(file);
		BufferedReader br = new BufferedReader(fr);
		while(br.ready()){
			String in = br.readLine().trim();//trim��ȥ���ַ�����ͷ�Ŀո�
			list.add(in);
		}
		br.close();
		fr.close();
		return list;
	}
	/**
	 * @param path �ļ���·��
	 * @param context д�������
	 * @throws IOException
	 */
	public static void write(String path, String context)throws IOException{
		File file = new File(path);
		FileWriter fw = new FileWriter(file, true);
		PrintWriter pw = new PrintWriter(fw);
		pw.println(context);
		pw.close();
		fw.close();
	}
}



