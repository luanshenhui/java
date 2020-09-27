package com.yulin.am;
import java.io.*;

public class IODemo1 {

	/**
	 * �ַ�����������
	 */
	public static void main(String[] args) {
		File file = new File("src/demo1.txt");
		//���еĸ߼�IO�������Եͼ�����Ϊ����
		try {
			if(!file.exists()){
				file.createNewFile();
			}
//			FileInputStream fis = new FileInputStream(file);
			FileReader fr = new FileReader(file);
			BufferedReader br = new BufferedReader(fr);
			while(br.ready()){
				String str = br.readLine();	//��һ��
				System.out.println(str);
			}
				
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}

}
