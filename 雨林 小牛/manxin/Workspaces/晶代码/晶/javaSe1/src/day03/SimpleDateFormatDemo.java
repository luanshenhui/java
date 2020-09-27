package day03;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * ���ڽ��ַ�����Date�໥ת������
 * java.text.SimpleDateFormat
 * @author Administrator
 *
 */
public class SimpleDateFormatDemo {
	public static void main(String[] args) throws ParseException {
		/**
		 * ����SimpleDateFormatʵ��ʱ��������Ҫ����һ��
		 * �ַ���������ַ�������������ת���ĸ�ʽ�ġ�
		 * 
		 * SimpleDateFormat�ڶ�Date��String�����໥ת��ʱ������
		 * ��һ����ʽ�ַ����ġ�
		 * ���ڸ�ʽ�ַ����﷨:
		 * y : ��     yyyy��λ���ֵ���    yy��λ���ֵ���
		 * M : ��     MM��λ���ֵ���       M:һλ���ֵ���(����)
		 * d : ��     dd��λ���ֵ���
		 * 
		 * h : Сʱ  12Сʱ��    hh��λ���ֵ�Сʱ
		 * H : Сʱ  24Сʱ��  
		 * m : ��    
		 * s : ��
		 * 
		 * a : ��/����
		 * E : ����
		 * 
		 * �����ڸ�ʽ�ַ����У�û������������ַ��Ͱ���ԭ�����
		 */
		long a = System.currentTimeMillis();
		DateFormat format = 
			new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		//java.util.Date
		Date now = new Date();//��ǰϵͳʱ��
		
		//��Dateת��Ϊ�ַ���
		String nowStr = format.format(now);
		
		System.out.println(nowStr);
		
		//����һ�������ַ���
		String dateStr = "09-20-1999 13:29:30";
		SimpleDateFormat format2 = 
			new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		
		/**
		 * ���ַ��������ڸ�ʽ�ַ�����Ҫ����н�����ת��Ϊ
		 * ��Ӧ��Date����
		 * ���ַ�������ת��Ϊdate����
		 */
		Date date = format2.parse(dateStr);
		System.out.println(date);
	}
}









