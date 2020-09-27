package day04;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * 基于基本类型数据读写的输入流和输出流
 * @author Administrator
 *
 */
public class DateInputStreamAndOutputStreamDemo {
	public static void main(String[] args) throws IOException {
		//创建基于文件读写的低级流fis  fos
		FileOutputStream fos = 
			new FileOutputStream("data.dat");
		//高级流  java.io.DataOutputStream
		DataOutputStream dos = 
			new DataOutputStream(fos);
		//写基本类型数据
		dos.writeInt(123123);
		dos.writeDouble(123.123);
		dos.writeUTF("随便写点文字吧");
		//关闭流
		dos.close();
		//创建用于读取文件的输入流
		FileInputStream fis = 
			new FileInputStream("data.dat");
		//创建可以读取基本类型数据的DateInputStream
		DataInputStream dis = 
			new DataInputStream(fis);
		//读取基本类型数据
		int i = dis.readInt();
		double d = dis.readDouble();
		String str = dis.readUTF();
		System.out.println("int="+i);
		System.out.println("double="+d);
		System.out.println("String="+str);
		dis.close();
		
		
		
		
		
		
		
		
	}
}





