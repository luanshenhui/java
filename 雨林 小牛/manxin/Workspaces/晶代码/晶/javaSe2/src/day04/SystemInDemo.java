package day04;

import java.io.BufferedReader;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;

/**
 * 获取键盘输入的信息
 * @author Administrator
 *
 */
public class SystemInDemo {
	public static void main(String[] args)throws IOException {
		//获取到了键盘信息的输入流
		InputStream in = System.in;
		
		//转化为字符流
		InputStreamReader reader = 
			new InputStreamReader(in);
		
		//转化为缓冲字符输入流 按行读取
		BufferedReader br = 
			new BufferedReader(reader);
		
		//将键盘读取到的信息写入文件
		FileOutputStream fos = 
			new FileOutputStream("systemin.txt");
		
		//将字节输出流变为缓冲字符输出流
		PrintWriter writer =
			new PrintWriter(fos);
		
		String str = null;
		while(
				(str = br.readLine())!=null
		){
			if("exit".equals(str)){
				break;
			}
			writer.println(str);
		}
		
		writer.close();
//		br.close();  //这里不要close()因为会关闭键盘的输入流
	}
}







