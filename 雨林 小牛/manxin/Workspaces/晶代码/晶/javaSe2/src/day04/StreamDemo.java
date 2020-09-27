package day04;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * �߼�������߼������Ե���Ч��
 * @author Administrator
 *
 */
public class StreamDemo {
	public static void main(String[] args)throws IOException {
		/**
		 * ���ȣ���������д�ļ��ĵͼ���FOS
		 */
		FileOutputStream fos = 
			new FileOutputStream("stream.dat");
		
		/**
		 * ��FOS���BOS�������������ӻ���Ч�������
		 * дЧ��
		 */
		BufferedOutputStream bos = 
			new BufferedOutputStream(fos);
		
		/**
		 * ���Է����д�����������ݵ���DOS
		 */
		DataOutputStream dos = 
			new DataOutputStream(bos);
		
		
		/**
		 * ��������������ת��Ϊ��Ӧ���ֽ�����
		 * ���ϵĹ���---�����������ݵ����л�
		 * 
		 * ����Щ�ֽ�����д�����ļ����г��ڱ���
		 * ���ϵĹ���---���ݳ־û�
		 */
		dos.writeInt(123);
		
		
		
//		/**
//		 * flush()�������ǽ����л���Ч�������Ļ���������һ��
//		 * ǿ��д��������
//		 */
//		dos.flush();
		/**
		 * ����close()����Ч�������
		 * 1:����ջ�������һ��ǿ����д���������ⶪ����
		 * 2:����ǰ�߼�����������ȹر�
		 * 3:������ر�
		 */
		dos.close();
		System.out.println("д�����");
		
		/**
		 * �������ڶ�ȡ�ļ���FIS
		 */
		FileInputStream fis = 
			new FileInputStream("stream.dat");
		
		/**
		 * �������л��幦�ܵ�BIS
		 */
		BufferedInputStream bis = 
			new BufferedInputStream(fis);
		
		/**
		 * �������Զ�ȡ�����������ݵ�DIS
		 */
		DataInputStream dis = 
			new DataInputStream(bis);
		
		
		/**
		 * ���ֽ�����ת��Ϊ��Ӧ�Ļ�����������
		 * ���ϵĹ���---�����������ݷ����л�
		 */
		int i = dis.readInt();
		System.out.println("int="+i);
		
		dis.close();
	}
}







