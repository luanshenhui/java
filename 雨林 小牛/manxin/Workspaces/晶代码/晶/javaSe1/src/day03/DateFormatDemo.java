package day03;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * DateFormat��SimpleDateFormat�ĸ���
 * ��ָ�� �����ڸ�ʽ���    yyyy-MM-dd  yyyy/MM/dd
 * @author Administrator
 *
 */
public class DateFormatDemo {
	public static void main(String[] args) {
		//������ǰϵͳʱ��
		Date now = new Date();
		/**
		 * getDateInstance(int format,Locale locale)
		 * ����1:ת��Ϊ�ַ��������Ϣ��ʽ
		 * ����2:��Ӧ�ĵ���
		 * 
		 * ����1��ӦDateFormat�ĳ���
		 *     SHORT:��Ϣ������
		 *     MEDIUM:��Ϣ���е�  ͨ��ʹ������
		 *     LONG:��Ϣ����
		 */
		DateFormat df1 
					= DateFormat
					.getDateInstance(DateFormat.MEDIUM,Locale.JAPAN);
		//�����ڶ���ת��Ϊ�ַ���  �˷���һ����ס
		//ͨ��dateformat�������format���� �����ڶ���ת��Ϊ�ַ���
		//��long���͵Ķ���ת��ΪString���� ��ô����
		
		String str = df1.format(now);
		System.out.println(str);
		long a = System.currentTimeMillis();
		//��date����ת��Ϊ�ַ�������  
		/*
		 * ������һ��long����   ��long����ת��Ϊdate  date--��string
		 * ���ܽ�������ʲô���ͣ�����ʱ��ģ�����ת��Ϊstring��ô
		 * ��͵��뷽�跨�Ľ��Ǹ�����ת��Ϊdate
		 */
	}
}










