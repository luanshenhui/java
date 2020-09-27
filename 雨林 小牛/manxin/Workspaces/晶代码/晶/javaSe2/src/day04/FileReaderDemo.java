package day04;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

/**
 * 用于读取文本文件的字节输入流
 * @author Administrator
 *
 */
public class FileReaderDemo {
	public static void main(String[] args)throws IOException {
		/**
		 * FileReader(File file)
		 * FileReader(String path)
		 */
//		File file = new File("CopyFile.java");
//		FileReader reader = new FileReader(file);
		/**
		 * FileReader不能修改编码级，只能按照当前系统
		 * 默认的编码集读取文本文件。
		 */
		FileReader reader 
				= new FileReader("CopyFile.java");
		
		/**
		 * 创建用于向文本文件中写字符的字符输出流
		 * 同样要注意，该输出流也不具备设定编码集的能力
		 */
		FileWriter writer 
				= new FileWriter("CopyFile_copy.java");
		
		int c = -1;
		while(
				(c = reader.read()) != -1
		){
//			System.out.print((char)c);
			writer.write(c);
		}
		reader.close();
		writer.close();
	}
}



