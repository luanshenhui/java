package day04;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * ���ڻ����������ݶ�д���������������
 * @author Administrator
 *
 */
public class DateInputStreamAndOutputStreamDemo {
	public static void main(String[] args) throws IOException {
		//���������ļ���д�ĵͼ���fis  fos
		FileOutputStream fos = 
			new FileOutputStream("data.dat");
		//�߼���  java.io.DataOutputStream
		DataOutputStream dos = 
			new DataOutputStream(fos);
		//д������������
		dos.writeInt(123123);
		dos.writeDouble(123.123);
		dos.writeUTF("���д�����ְ�");
		//�ر���
		dos.close();
		//�������ڶ�ȡ�ļ���������
		FileInputStream fis = 
			new FileInputStream("data.dat");
		//�������Զ�ȡ�����������ݵ�DateInputStream
		DataInputStream dis = 
			new DataInputStream(fis);
		//��ȡ������������
		int i = dis.readInt();
		double d = dis.readDouble();
		String str = dis.readUTF();
		System.out.println("int="+i);
		System.out.println("double="+d);
		System.out.println("String="+str);
		dis.close();
		
		
		
		
		
		
		
		
	}
}





