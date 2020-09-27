package cn.lsh.web;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

/**
 * 日期工具�?
 * @author wzy
 *
 */
public class DateUtil {
    // 默认日期格式
	public static final String DATE_DEFAULT_FORMAT ="yyyy-MM-dd";
	
	// 默认日期时间格式
	public static final String DATETIME_DEFAULT_FORMAT = "yyyy-MM-dd HH:mm:ss";
	
	// 默认时间格式
	public static final String TIME_DEFAULT_FORMAT = "HH:mm:ss";
	
	public static final String yyyyMMddHHmmsssss = "yyyyMMddHHmmsssss";
	
	// 时间格式�?
	private static DateFormat dateFormat = null;
	private static DateFormat dateTimeFormat = null;
	private static DateFormat timeFormat = null;
	private static Calendar gregorianCalendar = null;
	
	static{
		dateFormat = new SimpleDateFormat(DATE_DEFAULT_FORMAT);
		dateTimeFormat = new SimpleDateFormat(DATETIME_DEFAULT_FORMAT);
		timeFormat = new SimpleDateFormat(TIME_DEFAULT_FORMAT);
		gregorianCalendar = new GregorianCalendar();
	}
	
	/**
	 * 获得当前日期
	 * @param date 字符串日期参�?
	 * @param format 格式化格�?
	 * @return
	 */
	public static Date newDate(){
		try {
			Calendar c = Calendar.getInstance();
			int yyyy = c.get(Calendar.YEAR);
			int MM = c.get(Calendar.MONTH)+1;
			int dd = c.get(Calendar.DATE);
			int hh = c.get(Calendar.HOUR_OF_DAY);
			int mm = c.get(Calendar.MINUTE);
			int ss = c.get(Calendar.SECOND);
			String dateStr = yyyy+"-"+MM+"-"+dd+" "+hh+":"+mm+":"+ss;
			return DateUtil.formatDate(dateStr,DATETIME_DEFAULT_FORMAT);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 自定义日期格式化yyyy-MM-dd
	 * @param date 字符串日期参�?
	 * @param format 格式化格�?
	 * @return
	 */
	public static Date formatDate(String date,String format){
		try {
			return new SimpleDateFormat(format).parse(date);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 日期格式化yyyy-MM-dd
	 * @param date 字符串日期参�?
	 * @return
	 */
	public static Date formatDate(String date){
		try {
			return dateFormat.parse(date);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 日期格式化yyyy-MM-dd HH:mm:ss 
	 * @param date 字符串日期参�?
	 * @return
	 */
	public static Date formatDateTime(String date){
		try {
			return dateTimeFormat.parse(date);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 日期格式化HH:mm:ss 
	 * @param date 字符串日期参�?
	 * @return
	 */
	public static Date formatTime(String date){
		try {
			return timeFormat.parse(date);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 获得当前日期格式化yyyy-MM-dd
	 * @return
	 */
	public static Date getNowDate(){
		try {
			return DateUtil.formatDate(dateFormat.format(new Date()),
					DATE_DEFAULT_FORMAT);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 获得当前日期格式化yyyy-MM-dd HH:mm:ss
	 * @return
	 */
	public static Date getNowDateTime(){
		try {
			return DateUtil.formatDate(dateTimeFormat.format(new Date()),
					DATETIME_DEFAULT_FORMAT);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 获得当前日期格式化HH:mm:ss
	 * @return
	 */
	public static Date getNowTime(){
		try {
			return DateUtil.formatDate(timeFormat.format(new Date()),
					TIME_DEFAULT_FORMAT);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 获得当前日期格式�?
	 * @return
	 */
	public static String DateToString(Date date,String format){
		if(null==date){
			return "";
		}
		SimpleDateFormat sdf=new SimpleDateFormat(format);  
		return sdf.format(date);
	}
	
	
	public static String getYYYYMMddHHmmssSSS() {
        DateFormat df = new SimpleDateFormat("yyyyMMddHHmmssSSS");
        Calendar now = Calendar.getInstance();
        return df.format(now.getTime());
    }
	
}
