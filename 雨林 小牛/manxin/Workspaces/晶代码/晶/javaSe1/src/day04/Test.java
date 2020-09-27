package day04;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/*
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
 *  				String
 *  	 format.format|| format.parse(s)				
 *   				  ||
 *  	date.setime(l)      c.setime(d)
 *  long  ==>         date            calendar
 *        date.gettime       c.getime   
 *    
 *    
 */
public class Test {
	public static void main(String[] args) throws ParseException {
		String dateStr = "2013-08-25";
		Date date = new Date();
		Calendar rili = Calendar.getInstance();
		SimpleDateFormat diaoyong = 
			new SimpleDateFormat("yyyy-MM-dd");
		date = diaoyong.parse(dateStr);
		rili.setTime(date);
		rili.add(Calendar.DAY_OF_MONTH, 45);
		date = rili.getTime();
		dateStr = diaoyong.format(date);
		System.out.println(dateStr);

	}
}
