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
 * �����ַ�������
 * �ص㣺
 * ����Ϊ��λ��ȡ�ַ���
 * @author Administrator
 *
 */
public class BufferedReaderDemo {
	public static void main(String[] args) throws IOException {
		FileOutputStream fos = new FileOutputStream("ss.txt");
		OutputStreamWriter osw = new OutputStreamWriter(fos);
		BufferedWriter bw = new BufferedWriter(osw);
		bw.write("ssdfddsfsdffsdfjlsdkfjklsdfjlkzs������");
		bw.close();
		/**
		 * ��ȡjavaԴ����
		 * src/day01/test4.java
		 */
		//1 �ȴ������ڶ�ȡ�ļ���FIS
		FileInputStream fis = 
			new FileInputStream(
					"src" + File.separator +
					"day01" + File.separator +
					"test4.java"
			);
		//2 ���ֽ���ת��Ϊ�ַ���
		InputStreamReader reader = 
			new InputStreamReader(fis);
		//3 ���ж�ȡ�ַ������ַ������� 
		BufferedReader br = 
			new BufferedReader(reader);
		String str = null;
		/**
		 * String readLine()
		 * ������ȡ�ַ���ֱ����ȡ�����з�Ϊֹ��
		 * �����з�֮ǰ���ַ�����ַ�������
		 * ������ֵΪnullʱ��˵��EOF
		 */
		while(
				(str = br.readLine()) != null
		){
			System.out.println(str);
		}
		
		br.close();
	}
}	




