package day04;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;

/**
 * �ַ������
 * ���ַ�Ϊ��λд����
 * �ַ����Ǹ߼���
 * ���Է����д�ַ�
 * @author Administrator
 *
 */
public class OutputStreamWriterDemo {
	public static void main(String[] args)throws IOException {
		//��������д�ļ���FOS
		FileOutputStream fos = 
			new FileOutputStream("writer.txt");
	
		//����д�ַ����ַ������
//		OutputStreamWriter writer = 
//			new OutputStreamWriter(fos);
		/**
		 * �ַ��������ʵ������ʱ�����ָ���ַ���
		 * ����ָ�����ַ������ַ�ת��Ϊ�ֽں������
		 */
		OutputStreamWriter writer = 
			new OutputStreamWriter(fos,"GBK");
		
		
		
		//д��һ���ַ���
		writer.write("�Ұ�java");
		
		char[] data = {'��','��','��','��'};
		//��һ��char�����е����ݶ�д��
		writer.write(data);
		
		//д����Ĳ�������
		writer.write(data,2,2);
		
		writer.close();
	}
}









