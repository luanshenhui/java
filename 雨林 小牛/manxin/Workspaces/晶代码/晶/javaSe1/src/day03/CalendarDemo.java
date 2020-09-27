package day03;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * 日历类
 * 用于计算时间的类
 * @author Administrator
 *
 */
public class CalendarDemo {
	public static void main(String[] args) {
		/**
		 * java.util.Calendar
		 * 根据当前系统所在地区创建对应的子类实现
		 * 默认创建的日历类表示的日期为当前系统时间
		 */
		Calendar calendar = Calendar.getInstance();
//		Calendar cal = new GregorianCalendar();
		
		System.out.println(calendar);
		/**
		 * 将Calendar转换为Date
		 * Calendar.getTime()
		 * 将Calendar描述的时间转换为一个Date对象。
		 */
		Date date = calendar.getTime();
		SimpleDateFormat format = 
			new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		//输出转换后的字符串
		System.out.println(format.format(date));
		/**
		 * 设置日历类使之描述 2012-05-21
		 */
		calendar.set(Calendar.YEAR, 2012);
		/**
		 * 月是从0开始的。
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
		 * 获取calendar的某个时间单位上的值
		 */
		int year = calendar.get(Calendar.YEAR);
		int dayOfYear = calendar.get(Calendar.DAY_OF_YEAR);
		System.out.println(
				"现在是"+year+"年的第"+dayOfYear+"天"
		);
		
		/**
		 * 想查看今年一共有多少天
		 */
		calendar.set(Calendar.MONTH, 11);
		calendar.set(Calendar.DAY_OF_MONTH, 31);
		int max = calendar.get(Calendar.DAY_OF_YEAR);
		System.out.println(year+"年有:"+max+"天");
		
		/**
		 * 获取当前时间单位可能的最大值
		 */
		Calendar now = Calendar.getInstance();
		/**
		 * 获取Calendar表示的日期所处年的最大天数
		 */
		System.out.println(

				"最大天数:" +
				now.getActualMaximum(Calendar.DAY_OF_YEAR)
		);
		/**
		 * 获取Calendar表的日期所处月的最大天数
		 */
		System.out.println(
				"月中最大天数:"+
				now.getActualMaximum(Calendar.DAY_OF_MONTH)
		);
		/**
		 * 2月最大天数
		 */
		now.set(Calendar.MONTH, 1);//先将日历设置为2月
		System.out.println(
				"2月中最大天数:"+
				now.getActualMaximum(Calendar.DAY_OF_MONTH)
		);
	}
}







