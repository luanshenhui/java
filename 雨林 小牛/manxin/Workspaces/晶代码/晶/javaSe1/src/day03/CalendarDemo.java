package day03;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * ������
 * ���ڼ���ʱ�����
 * @author Administrator
 *
 */
public class CalendarDemo {
	public static void main(String[] args) {
		/**
		 * java.util.Calendar
		 * ���ݵ�ǰϵͳ���ڵ���������Ӧ������ʵ��
		 * Ĭ�ϴ������������ʾ������Ϊ��ǰϵͳʱ��
		 */
		Calendar calendar = Calendar.getInstance();
//		Calendar cal = new GregorianCalendar();
		
		System.out.println(calendar);
		/**
		 * ��Calendarת��ΪDate
		 * Calendar.getTime()
		 * ��Calendar������ʱ��ת��Ϊһ��Date����
		 */
		Date date = calendar.getTime();
		SimpleDateFormat format = 
			new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		//���ת������ַ���
		System.out.println(format.format(date));
		/**
		 * ����������ʹ֮���� 2012-05-21
		 */
		calendar.set(Calendar.YEAR, 2012);
		/**
		 * ���Ǵ�0��ʼ�ġ�
		 */
		calendar.set(Calendar.MONTH, 12);
		/**
		 * Day Of Month
		 * Day of Week
		 * Day of Year
		 */
		calendar.set(Calendar.DAY_OF_MONTH, 32);
		date = calendar.getTime();
		System.out.println(format.format(date));
		
		/**
		 * ��ȡcalendar��ĳ��ʱ�䵥λ�ϵ�ֵ
		 */
		int year = calendar.get(Calendar.YEAR);
		int dayOfYear = calendar.get(Calendar.DAY_OF_YEAR);
		System.out.println(
				"������"+year+"��ĵ�"+dayOfYear+"��"
		);
		
		/**
		 * ��鿴����һ���ж�����
		 */
		calendar.set(Calendar.MONTH, 11);
		calendar.set(Calendar.DAY_OF_MONTH, 31);
		int max = calendar.get(Calendar.DAY_OF_YEAR);
		System.out.println(year+"����:"+max+"��");
		
		/**
		 * ��ȡ��ǰʱ�䵥λ���ܵ����ֵ
		 */
		Calendar now = Calendar.getInstance();
		/**
		 * ��ȡCalendar��ʾ��������������������
		 */
		System.out.println(

				"�������:" +
				now.getActualMaximum(Calendar.DAY_OF_YEAR)
		);
		/**
		 * ��ȡCalendar������������µ��������
		 */
		System.out.println(
				"�����������:"+
				now.getActualMaximum(Calendar.DAY_OF_MONTH)
		);
		/**
		 * 2���������
		 */
		now.set(Calendar.MONTH, 1);//�Ƚ���������Ϊ2��
		System.out.println(
				"2�����������:"+
				now.getActualMaximum(Calendar.DAY_OF_MONTH)
		);
	}
}







