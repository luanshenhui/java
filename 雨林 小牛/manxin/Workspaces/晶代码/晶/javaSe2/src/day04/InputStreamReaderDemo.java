package day04;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * 字符输入流读取文本文件
 * @author Administrator
 *
 */
public class InputStreamReaderDemo {
	public static void main(String[] args)throws IOException {
		FileInputStream fis = 
			new FileInputStream("writer.txt");
		//创建读取文本文件的字符输入流
		InputStreamReader reader = 
			new InputStreamReader(fis,"GBK");
		//读取一个字符，若读取到了文件末尾，返回-1
		int c = -1;
		while(
				(c = reader.read()) != -1
		){
			System.out.print((char)c);
		}
		
		reader.close();
	}
}









