package day02;

import java.io.UnsupportedEncodingException;
import java.util.Arrays;
/**
 * �ַ�������
 * ���ַ�������ָ�����ַ������б��롣
 * @author Administrator
 * ��gbk������ һ������ռ�����ֽ� 
 * ��utf-8��һ������ռ�����ֽ�
 * һ����ĸռһ���ֽ�
 */
public class StringEnCoding {
	public static void main(String[] args) 
	throws UnsupportedEncodingException {
		String str = "�Ұ�java";
		/**
		 * �÷���Ҫ������߱��벶��һ���쳣
		 * ����쳣�ǣ�û������ַ���
		 * �������ַ�����д���ַ������ƴ���ʱ�ᱨ�������
		 */
		byte[] data = str.getBytes("gbk");
		System.out.println(Arrays.toString(data));
		byte[] utfdata = str.getBytes("utf-8");
		System.out.println(Arrays.toString(utfdata));
		/**
		 * ��2��������ת��Ϊ�ַ���
		 * �ַ������Ʋ����ִ�Сд
		 */
		
		String decodeStr = new String(utfdata,"UTF-8");
		
		System.out.println("�����:"+decodeStr);
		String s = "jss";
		String s1 = new String(s.getBytes("iso8859-1"), "utf-8");
		
	}
}







