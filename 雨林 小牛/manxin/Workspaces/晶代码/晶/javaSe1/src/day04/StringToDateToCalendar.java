package day04;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * String Date Calendar֮���ת��
 * @author Administrator
 *
 */
public class StringToDateToCalendar {
	public static void main(String[] args) throws ParseException {
		/**
		 * ����:
		 * 	����һ�������ַ��������ظ��ַ���������ʱ���
		 *  45���Ժ������
		 * String dateStr = "2013-08-25";
		 * ˼·:
		 *  ����������ҪCalendar������Ҫ���ַ���ת��Ϊ
		 *  CalendarȻ�����ʱ�䣬�ڽ���ת�����ַ��������
		 * 
		 * ����:
		 *  1:��������ת���ַ�����Date��SimpleDateFormat
		 *    ���ƶ����ڸ�ʽ�ַ���
		 *  2:�������������ַ���ת��ΪDate����
		 *  3:����Calendar��ʵ��
		 *  4:��ת����Date�������õ�Calendar�У�ʹCalendar��
		 *    ʵ������Date����������
		 *  5:ͨ��Calendarʵ������45��������
		 *  6:ͨ��Calendar��ȡDate������������45��������
		 *  7:��Date����ͨ��SimpleDateFormatת��Ϊ�ַ��������     
		 */
		String dateStr = "2013-08-25";
		SimpleDateFormat format = 
				new SimpleDateFormat("yyyy-MM-dd");
		Date date = format.parse(dateStr);
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.DAY_OF_YEAR, 45);
		date = calendar.getTime();
		dateStr = format.format(date);
		System.out.println(dateStr);
		
	}
}






