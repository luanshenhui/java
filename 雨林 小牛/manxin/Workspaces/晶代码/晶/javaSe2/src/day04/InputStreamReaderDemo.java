package day04;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * �ַ���������ȡ�ı��ļ�
 * @author Administrator
 *
 */
public class InputStreamReaderDemo {
	public static void main(String[] args)throws IOException {
		FileInputStream fis = 
			new FileInputStream("writer.txt");
		//������ȡ�ı��ļ����ַ�������
		InputStreamReader reader = 
			new InputStreamReader(fis,"GBK");
		//��ȡһ���ַ�������ȡ�����ļ�ĩβ������-1
		int c = -1;
		while(
				(c = reader.read()) != -1
		){
			System.out.print((char)c);
		}
		
		reader.close();
	}
}









