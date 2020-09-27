package centling.util;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class BlDateUtil {
	
	/**
	 * 在指定的日期上加天数
	 * @param date 指定的日期
	 * @param num 添加的天数
	 * @return 计算后的日期
	 */
	public static Date addDay(Date date, int num) {
		Calendar startDT = Calendar.getInstance();
		startDT.setTime(date);
		startDT.add(Calendar.DAY_OF_MONTH, num);
		return startDT.getTime();
	}
	
	/**
	 * 在指定的日期上加月数
	 * @param date 指定的日期
	 * @param num 添加的月数
	 * @return 计算后的日期
	 */
	public static Date addMonth(Date date, int num) {
		Calendar startDT = Calendar.getInstance();
		startDT.setTime(date);
		startDT.add(Calendar.MONTH, num);
		return startDT.getTime();
	}
	
	/**
	 * 在指定的日期上添加工作日天数
	 * @param date 指定的日期
	 * @param num 工作日天数
	 * @return 计算后的日期
	 */
	public static Date addWorkDay(Date date, int num) {
		Calendar startDT = Calendar.getInstance();
		startDT.setTime(date);
		for (int i=0; i<num; i++) {
			startDT.add(Calendar.DAY_OF_MONTH, 1);
			// 判断是否为周日，如果是，则日期顺延一天
			if (startDT.get(Calendar.DAY_OF_WEEK) == 1) {
				startDT.add(Calendar.DAY_OF_MONTH, 1);
			}
		}
		return startDT.getTime();
	}
	
	/**
	 * 得到指定日期为周几
	 * @param date 指定的日期
	 * @return 周日到周六的取值依次为1-7
	 */
	public static int getWeekDay(Date date) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		return calendar.get(Calendar.DAY_OF_WEEK);
	}
	
	/**
	 * 得到指定日期为一个月的第几天
	 * @param date 指定的日期
	 * @return
	 */
	public static int getMonthDay(Date date) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		return calendar.get(Calendar.DAY_OF_MONTH);
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
	
	/**
	 * 将字符串转换为指定格式的日期
	 * @param strDate 待转换的日期字符串
	 * @param format 转换格式
	 * @return 转换后的日期
	 * @throws Exception
	 */
	public static Date parseDate(String strDate, String format) throws Exception {
		DateFormat df = new SimpleDateFormat(format);
		return df.parse(strDate);
	}
	
	/**
	 * 获取上月时间
	 * @return
	 */
	public static Date getLastMonthDate() {
		Calendar c = Calendar.getInstance();
		c.add(Calendar.MONTH, -1);
		return c.getTime();
	}
	
	public static Date getTheFirstDateOfLastMonth(Date date) throws Exception{
		date = BlDateUtil.addMonth(date, -1);
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		int year = calendar.get(Calendar.YEAR);
		int month = calendar.get(Calendar.MONTH);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String str = year+"-"+(month+1)+"-"+"01 00:00:00";
		return sdf.parse(str);
	}
	
	public static Date getTheLastDateOfLastMonth(Date date) throws Exception{
		date = BlDateUtil.addMonth(date, -1);
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		int year = calendar.get(Calendar.YEAR);
		int month = calendar.get(Calendar.MONTH);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:m:ss");
		String str = year+"-"+(month+1)+"-"+getDaysOfMonth(year, month+1)+" 23:59:59";
		return sdf.parse(str);
	}

	public static String getTheFirstDateOfLastMonthStr(Date date) throws Exception{
		date = BlDateUtil.addMonth(date, -1);
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		int year = calendar.get(Calendar.YEAR);
		int month = calendar.get(Calendar.MONTH);
		return year+"-"+(month+1)+"-"+"01 00:00:00";
	}
	
	public static String getTheLastDateOfLastMonthStr(Date date) throws Exception{
		date = BlDateUtil.addMonth(date, -1);
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		int year = calendar.get(Calendar.YEAR);
		int month = calendar.get(Calendar.MONTH);
		return year+"-"+(month+1)+"-"+getDaysOfMonth(year, month+1)+" 23:59:59";
	}
	
	public static Date getLastTimeOfTheDay(Date date) throws Exception{
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.set(Calendar.HOUR_OF_DAY, 23);
		calendar.set(Calendar.MINUTE, 59);
		calendar.set(Calendar.SECOND, 59);
		return calendar.getTime();
	}
	
	private static String getDaysOfMonth(int year, int month){
		String returnVal="";
		switch(month){
			case 1: returnVal="30";break;
			case 2: returnVal=isLeapYear(year)?"29":"28";break;
			case 3: returnVal="31";break;
			case 4: returnVal="30";break;
			case 5: returnVal="31";break;
			case 6: returnVal="30";break;
			case 7: returnVal="31";break;
			case 8: returnVal="31";break;
			case 9: returnVal="30";break;
			case 10: returnVal="31";break;
			case 11: returnVal="30";break;
			case 12: returnVal="31";break;
		}
		return returnVal;
	}
	private static boolean isLeapYear(int year){  
		 if((year%4==0&&year%100!=0)||year%400==0)   
			 return true;  
		 else   
			 return false; 
	 }
}