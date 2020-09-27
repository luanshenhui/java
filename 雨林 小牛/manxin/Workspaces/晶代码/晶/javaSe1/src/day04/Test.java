package day04;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/*
 * 需求:
 * 	给定一个日期字符串，返回该字符串描述的时间的
 *  45天以后的日期
 * String dateStr = "2013-08-25";
 * 思路:
 *  计算日期需要Calendar，所以要将字符串转换为
 *  Calendar然后计算时间，在将其转换回字符串输出。
 * 
 * 步骤:
 *  1:创建用于转换字符串到Date的SimpleDateFormat
 *    并制定日期格式字符串
 *  2:将给定的日期字符串转换为Date对象
 *  3:创建Calendar的实例
 *  4:将转换的Date对象设置到Calendar中，使Calendar的
 *    实例代表Date描述的日期
 *  5:通过Calendar实例计算45天后的日期
 *  6:通过Calendar获取Date对象用于描述45天后的日期
 *  7:将Date对象通过SimpleDateFormat转换为字符串并输出 
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
