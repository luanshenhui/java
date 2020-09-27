package day05;

import java.io.FileInputStream;
import java.io.ObjectInputStream;

/**
 * ObjectInputStream
 * 用于将对象反序列化
 * @author Administrator
 *
 */
public class ObjectInputStreamDemo {
	public static void main(String[] args)throws Exception {
		//创建用于读取文件的FIS
		FileInputStream fis = 
			new FileInputStream("point.obj");
		
		//创建用于反序列化的OOS
		ObjectInputStream oos = 
			new ObjectInputStream(fis);
		
		//反序列化对象
		Point p = (Point)oos.readObject();//这里还要捕获ClassNotFoundException
		
		System.out.println(p);
	}
}

