
package day04;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;

/**
 * 缓冲字符输出流
 * @author Administrator
 *
 */
public class PrintWriterDemo {
	public static void main(String[] args)throws IOException {
		/**
		 * 向文件中写字符串
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
		
		writer.println("大家好!");
		writer.println("才是真的好!");
		
		writer.close();
		
		System.out.println("大家好才是真的好!");
	}
}






