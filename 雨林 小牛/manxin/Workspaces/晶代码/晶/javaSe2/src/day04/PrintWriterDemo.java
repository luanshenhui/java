
package day04;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;

/**
 * �����ַ������
 * @author Administrator
 *
 */
public class PrintWriterDemo {
	public static void main(String[] args)throws IOException {
		/**
		 * ���ļ���д�ַ���
		 */
//		//1 
//		File file = new File("pw.txt");
//		PrintWriter writer = new PrintWriter(file);
//		
//		//2
//		writer = new PrintWriter("pw.txt");
		
		//3
		FileOutputStream fos 
						= new FileOutputStream("pw.txt");	
		
		PrintWriter writer = new PrintWriter(fos);
		
		writer.println("��Һ�!");
		writer.println("������ĺ�!");
		
		writer.close();
		
		System.out.println("��Һò�����ĺ�!");
	}
}






