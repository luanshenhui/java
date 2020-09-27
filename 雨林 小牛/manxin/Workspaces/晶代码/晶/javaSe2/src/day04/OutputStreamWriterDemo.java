package day04;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;

/**
 * 字符输出流
 * 以字符为单位写数据
 * 字符流是高级流
 * 可以方便的写字符
 * @author Administrator
 *
 */
public class OutputStreamWriterDemo {
	public static void main(String[] args)throws IOException {
		//创建用于写文件的FOS
		FileOutputStream fos = 
			new FileOutputStream("writer.txt");
	
		//用于写字符的字符输出流
//		OutputStreamWriter writer = 
//			new OutputStreamWriter(fos);
		/**
		 * 字符输出流在实例化的时候可以指定字符集
		 * 按照指定的字符集将字符转换为字节后再输出
		 */
		OutputStreamWriter writer = 
			new OutputStreamWriter(fos,"GBK");
		
		
		
		//写出一个字符串
		writer.write("我爱java");
		
		char[] data = {'我','是','数','组'};
		//将一个char数组中的数据都写出
		writer.write(data);
		
		//写数组的部分内容
		writer.write(data,2,2);
		
		writer.close();
	}
}









