package day03;

import java.util.Calendar;
import java.util.GregorianCalendar;

/**
 * ʹ��Calendar����ʱ��
 * @author Administrator
 *
 */
public class CalendarDemo2 {
	public static void main(String[] args) {
		Calendar calendar = new GregorianCalendar();
		
		//���·ݼ�һ����
		calendar.add(Calendar.MONTH, 1);
		
		//���ռ�1
		calendar.add(Calendar.DAY_OF_MONTH, 1);
		
		//������
		calendar.add(Calendar.YEAR, -2);
		
		System.out.println(calendar.getTime());
		
	}
}





