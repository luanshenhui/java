package day04;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

/**
 * ���ļ��ж�ȡ���ݵ�FileInputStream
 * @author Administrator
 *
 */
public class FileInputStreamDemo {
	public static void main(String[] args) throws IOException {
		File file = new File("fos.dat");
		FileInputStream fis = new FileInputStream(file);
		
		char a = (char)fis.read();//��ȡһ���ֽ�
		char b = (char)fis.read();
		
		System.out.println(a);
		System.out.println(b);
		
		fis.close();
	}
}




