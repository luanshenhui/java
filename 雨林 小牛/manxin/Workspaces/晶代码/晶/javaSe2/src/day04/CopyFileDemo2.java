package day04;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * ���ڻ��������и����ļ��Ĳ���
 * @author Administrator
 *
 */
public class CopyFileDemo2 {
	public static void main(String[] args)throws IOException {
		FileInputStream fis 
					= new FileInputStream("jvm.bmp");
		
		BufferedInputStream bis 
					= new BufferedInputStream(fis);
		
		FileOutputStream fos 
					= new FileOutputStream("jvm_copy.bmp");
		
		BufferedOutputStream bos 
					= new BufferedOutputStream(fos);
		
		int d = -1;
		
		while(
				(d = bis.read()) != -1
		){
			bos.write(d);
		}
		
		System.out.println("�������");
		/**
		 * �ر�����ʱ��ֻ��Ҫ�������ĸ߼�������
		 * �߼����ڹر�ǰ���Ὣ����������ȹرպ�Ž��Լ��ر�
		 */
		bos.close();
		bis.close();
		
		
	}
}










