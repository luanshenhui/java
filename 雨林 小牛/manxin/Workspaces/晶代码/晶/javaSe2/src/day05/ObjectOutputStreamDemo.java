package day05;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

/**
 * ObjectOutputStream
 * ���ڽ��������л��������
 * @author Administrator
 *
 */
public class ObjectOutputStreamDemo {
	public static void main(String[] args)throws IOException, ClassNotFoundException {
		//����һ������
		Point p = new Point(1,2);
		/**
		 * ��Point�������л���д���ļ���
		 * 
		 * 1  ��������д�ļ����ֽ������FOS
		 * 2  ��FOSת��Ϊһ������д�����ObjectOutputStream
		 * 3  ������д��
		 * 4  �ر���
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
		
//		//���������л�
//		FileInputStream fis = 
//			new FileInputStream("point.obj");
//		
//		ObjectInputStream ois = 
//			new ObjectInputStream(fis);
//		
//		Point p1 = (Point)ois.readObject();
//		
//		System.out.println("��ͬһ������ô?"+(p==p1));
//		System.out.println("p:"+p);
//		System.out.println("p1:"+p1);
//		
//		ois.close();
	}
}







