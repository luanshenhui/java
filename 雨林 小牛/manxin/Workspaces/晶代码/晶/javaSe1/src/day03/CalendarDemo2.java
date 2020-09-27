package day03;

import java.util.Calendar;
import java.util.GregorianCalendar;

/**
 * 使用Calendar计算时间
 * @author Administrator
 *
 */
public class CalendarDemo2 {
	public static void main(String[] args) {
		Calendar calendar = new GregorianCalendar();
		
		//将月份加一个月
		calendar.add(Calendar.MONTH, 1);
		
		//对日加1
		calendar.add(Calendar.DAY_OF_MONTH, 1);
		
		//减两年
		calendar.add(Calendar.YEAR, -2);
		
		System.out.println(calendar.getTime());
		
	}
}





