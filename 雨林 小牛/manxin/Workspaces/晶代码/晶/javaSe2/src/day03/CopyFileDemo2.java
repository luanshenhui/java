package day03;

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
		//����ѩ д
		FileOutputStream fs = new FileOutputStream("jvm.txt");
		BufferedOutputStream bs = new BufferedOutputStream(fs);
		bs.write('A');
		bs.close();
		//�㿴
		FileInputStream fis 
					= new FileInputStream("jvm.txt");
		BufferedInputStream bis 
					= new BufferedInputStream(fis);
		//��д
		FileOutputStream fos 
					= new FileOutputStream("jvm_copy.txt");
		
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










