package day05;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

/**
 * ObjectOutputStream
 * 用于将对象序列化的输出流
 * @author Administrator
 *
 */
public class ObjectOutputStreamDemo {
	public static void main(String[] args)throws IOException, ClassNotFoundException {
		//创建一个对象
		Point p = new Point(1,2);
		/**
		 * 将Point对象序列化后写入文件。
		 * 
		 * 1  创建用于写文件的字节输出流FOS
		 * 2  将FOS转换为一个可以写对象的ObjectOutputStream
		 * 3  将对象写出
		 * 4  关闭流
		 */
		//1
		FileOutputStream fos = 
			new FileOutputStream("point.obj");
		
		//2
		ObjectOutputStream oos = 
			new ObjectOutputStream(fos);
		
		//3
		oos.writeObject(p);
		
		//4
		oos.close();
		
//		//将对象反序列化
//		FileInputStream fis = 
//			new FileInputStream("point.obj");
//		
//		ObjectInputStream ois = 
//			new ObjectInputStream(fis);
//		
//		Point p1 = (Point)ois.readObject();
//		
//		System.out.println("是同一个对象么?"+(p==p1));
//		System.out.println("p:"+p);
//		System.out.println("p1:"+p1);
//		
//		ois.close();
	}
}







