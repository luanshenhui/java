package day05;

import java.io.FileInputStream;
import java.io.ObjectInputStream;

/**
 * ObjectInputStream
 * ���ڽ��������л�
 * @author Administrator
 *
 */
public class ObjectInputStreamDemo {
	public static void main(String[] args)throws Exception {
		//�������ڶ�ȡ�ļ���FIS
		FileInputStream fis = 
			new FileInputStream("point.obj");
		
		//�������ڷ����л���OOS
		ObjectInputStream oos = 
			new ObjectInputStream(fis);
		
		//�����л�����
		Point p = (Point)oos.readObject();//���ﻹҪ����ClassNotFoundException
		
		System.out.println(p);
	}
}

