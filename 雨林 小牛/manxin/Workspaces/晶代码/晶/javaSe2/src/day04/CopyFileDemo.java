package day04;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * ʹ���ļ���������������ļ��ĸ��Ʋ���
 * @author Administrator
 *
 */
public class CopyFileDemo {
	public static void main(String[] args) throws IOException {
		FileInputStream fis 
					= new FileInputStream("jvm.bmp");
		
		FileOutputStream fos 
					= new FileOutputStream("jvm_copy.bmp");
		
		/**
		 * ���ֽڶ�д  Ч�ʵ�
		 */
//		int d = -1;
//		while(
//				(d = fis.read()) != -1
//		){
//			fos.write(d);
//		}
		/**
		 * ʹ�û��巽ʽ��д Ч�ʸ�
		 */
		byte[] buf = new byte[1024*10];
		int sum = 0;
		while(
				(sum = fis.read(buf)) > 0
		){
			fos.write(buf,0,sum);
		}
		
		
		System.out.println("�������");
		
		fis.close();
		fos.close();
	}
}






