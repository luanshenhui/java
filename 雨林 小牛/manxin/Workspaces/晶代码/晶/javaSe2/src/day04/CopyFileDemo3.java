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
 * ʹ�û����ַ���������������ı��ļ�
 * @author Administrator
 *
 */
public class CopyFileDemo3 {
	public static void main(String[] args) throws IOException {
		//�������ڶ�ȡԴ�ļ���FIS
		FileInputStream fis = 
			new FileInputStream(
					"src" + File.separator +
					"day01" + File.separator +
					"CopyFile.java"
			);
		//���������ַ�������
		BufferedReader reader = 
			new BufferedReader(
					new InputStreamReader(fis)
			);
		
		//����һ������д�ļ���FOS
		FileOutputStream fos = 
			new FileOutputStream("CopyFile.java");
		
		//���ֽ����������ַ������
		OutputStreamWriter writer = 
			new OutputStreamWriter(fos);
		
		//���ַ��������̻����ַ������
		//�����Ϳ�������Ϊ��λд�ַ�����
		BufferedWriter br = 
			new BufferedWriter(writer);
		
		String str = null;
		/**
		 * ��Դ�ļ��ж�ȡһ���ַ�����Ȼ��д��Ŀ���ļ���
		 * �Ӷ��ﵽ�����ı��ļ���Ŀ��
		 */
		while(
				(str = reader.readLine()) != null
		){
			br.write(str);//һ�ν�һ���ַ���д��
			br.newLine();//���һ������
		}
		
		br.close();
		reader.close();
	}
}






