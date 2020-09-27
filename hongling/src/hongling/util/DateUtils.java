package hongling.util;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * order DateUtils.java
 * 
 * author :鞠兴良 date :2014-4-28 time :下午3:53:30
 */
public class DateUtils {
	public static final String yyyyMMddhhmmss= "yyyyMMddhhmmss";
	/**
	 * 得到指定日期为周几
	 * 
	 * @param date
	 *            指定的日期
	 * @return 周日到周六的取值依次为1-7
	 */
	public static int getWeekDay(Date date) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		return calendar.get(Calendar.DAY_OF_WEEK);
	}

	/** 
	* @Description: 日期做加法 
	* @param date 日期
	* @param amount 天数
	* @date 2014-5-19 上午10:32:59
	* @return Date    返回类型  
	*/ 
	public static Date dateAddDay(Date date, int amount) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.DAY_OF_MONTH, amount);
		return calendar.getTime();
	}
	
	public static Date dateAddHours(Date date, int amount) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.HOUR_OF_DAY, amount);
		return calendar.getTime();
	}
	
	/**
	 * 将日期转换为指定类型的字符串
	 * @param date 待转换的日期
	 * @param fromat 格式
	 * @return 转换好的日期
	 */
	public static String formatDate(Date date, String format) {
		DateFormat df = new SimpleDateFormat(format);
		return df.format(date);
	}
	
	public static Date parse(String dateStr, String format){
		DateFormat df = new SimpleDateFormat(format);
		try {
			return df.parse(dateStr);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
}
