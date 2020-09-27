package cn.rkylin.apollo.common.util;

import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Locale;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateFormatUtils;

public class DateUtils extends cn.rkylin.core.utils.DateUtils {
	// 年月日格式串
	public static final String FORMAT_YMD = "yyyy-MM-dd";
	// 年月日时分秒格式串
	public static final String FORMAT_YMD_HMS = "yyyy-MM-dd HH:mm:ss";
	// 时分格式串
	public static final String FORMAT_HM = "HH:mm";

	/**
	 * 获取月的第一天
	 * 
	 * @param dateStr
	 *  yyyy-MM
	 * @return
	 */
	public static String getFirsDateStrOfMonth(String dateStr) {
		String result = null;
		try {
			Date date = parseDate(dateStr, DateUtils.FORMAT_YMD);
			Calendar cal = Calendar.getInstance();
			cal.setTime(date);
			cal.set(Calendar.DAY_OF_MONTH, 1);
			result = getFormatDateStr(cal.getTime(), DateUtils.FORMAT_YMD);
		} catch (ParseException e) {
			log.error(e);
		}
		return result;

	}

	/**
	 * 获取月的最后一天
	 * 
	 * @param dateStr
	 * yyyy-MM
	 * @return
	 */
	public static String getLastDateStrOfMonth(String dateStr) {
		String result = null;
		try {
			Date date = parseDate(dateStr, DateUtils.FORMAT_YMD);
			Calendar cal = Calendar.getInstance();
			cal.setTime(date);
			cal.set(Calendar.DAY_OF_MONTH, 1);
			cal.roll(Calendar.DATE, -1);
			result = getFormatDateStr(cal.getTime(), DateUtils.FORMAT_YMD);
		} catch (ParseException e) {
			log.error(e);
		}
		return result;
	}

	/**
	 * @description 【获取指定时间的下一个月】
	 * @param dateStr
	 * @return yyyy-MM-dd
	 * @throws Exception
	 * @createTime 2016-07-26 下午4:54:05
	 */
	public static String getNextMonthStr(String dateStr) throws Exception {
		if (dateStr == null || "".equals(dateStr)) {
			dateStr = getCurrentDateStr();
		}
		Date date = cn.rkylin.core.utils.DateUtils.parseDate(dateStr);
		Calendar calendar = cn.rkylin.core.utils.DateUtils.getCalendar(date);
		calendar.add(Calendar.MONTH, 1);
		return org.apache.commons.lang.time.DateFormatUtils.format(calendar.getTime(), "yyyy-MM-dd");
	}

	/**
	 * @description 【获取指定时间的上一个月】
	 * @param dateStr
	 * @return yyyy-MM-dd
	 * @throws Exception
	 * @createTime 2016-07-26 下午4:54:05
	 */
	public static String getPrevMonthStr(String dateStr) throws Exception {
		if (dateStr == null || "".equals(dateStr)) {
			dateStr = getCurrentDateStr();
		}
		Date date = cn.rkylin.core.utils.DateUtils.parseDate(dateStr);
		Calendar calendar = cn.rkylin.core.utils.DateUtils.getCalendar(date);
		calendar.add(Calendar.MONTH, -1);
		return org.apache.commons.lang.time.DateFormatUtils.format(calendar.getTime(), "yyyy-MM-dd");
	}

	/**
	 * 获取日期格式化后的字符串
	 * 
	 * @param date
	 * @param format
	 * @param addOrSubDays
	 * @return
	 * @createTime 2016-07-26 下午4:54:05
	 */
	public static String getFormatDateStr(Date date, String format, int addOrSubDays) {
		if (format == null) {
			format = DateUtils.FORMAT_YMD;
		}
		Date temp = new Date(date.getTime());
		if (addOrSubDays != 0) {
			temp.setTime(date.getTime() + addOrSubDays * 24 * 3600 * 1000);
		}
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		return sdf.format(temp);
	}

	/**
	 * 将时间转换成串格式
	 * 
	 * @param date
	 * @param format
	 * @return
	 * @createTime 2016-07-26 下午4:54:05
	 */
	public static String getFormatDateStr(Date date, String format) {
		if (format == null) {
			format = DateUtils.FORMAT_YMD;
		}
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		return sdf.format(date);
	}

	/**
	 * 获取日期格式化后的字符串
	 * 
	 * @param dateStr
	 * @param format
	 * @param addOrSubDays
	 * @return
	 * @createTime 2016-07-26 下午4:54:05
	 */
	public static String getFormatDateStr(String dateStr, String format, int addOrSubDays) {
		if (format == null) {
			format = DateUtils.FORMAT_YMD;
		}
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		Date date = null;
		try {
			date = sdf.parse(dateStr);
		} catch (ParseException e) {
		}

		if (addOrSubDays != 0) {
			// date.setTime(date.getTime()+addOrSubDays*24*3600*1000);
			Calendar calendar = Calendar.getInstance(Locale.CHINA);
			calendar.setTime(date);
			calendar.add(calendar.DAY_OF_MONTH, addOrSubDays);
			date = calendar.getTime();
		}
		return sdf.format(date);
	}

	/**
	 * 根据日期获取星期 周日为1,周一为2,周六为7
	 * 
	 * @param d
	 * @return
	 * @createTime 2016-07-26 下午4:54:05
	 */
	public static int getCalendarWeek(String d) {
		Calendar cal = Calendar.getInstance(Locale.CHINA);
		cal.set(Integer.parseInt(d.substring(0, 4)), Integer.parseInt(d.substring(5, 7)) - 1,
				Integer.parseInt(d.substring(8, 10)));

		return cal.get(Calendar.DAY_OF_WEEK);
	}

	/**
	 * 取得两个时间段的时间间隔 return t2 与t1的间隔天数 throws ParseException
	 * 如果输入的日期格式不是0000-00-00 格式抛出异常
	 * 
	 * @param t1
	 * @param t2
	 * @return
	 * @throws ParseException
	 * @createTime 2016-07-26 下午4:54:05
	 */
	public static int getBetweenDays(String t1, String t2) throws ParseException {
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		int betweenDays = 0;
		Date d1 = format.parse(t1);
		Date d2 = format.parse(t2);
		Calendar c1 = Calendar.getInstance();
		Calendar c2 = Calendar.getInstance();
		c1.setTime(d1);
		c2.setTime(d2);
		// 保证第二个时间一定大于第一个时间
		if (c1.after(c2)) {
			c1 = c2;
			c2.setTime(d1);
		}
		int betweenYears = c2.get(Calendar.YEAR) - c1.get(Calendar.YEAR);
		betweenDays = c2.get(Calendar.DAY_OF_YEAR) - c1.get(Calendar.DAY_OF_YEAR);
		for (int i = 0; i < betweenYears; i++) {
			c1.set(Calendar.YEAR, (c1.get(Calendar.YEAR) + 1));
			betweenDays += c1.getMaximum(Calendar.DAY_OF_YEAR);
		}

		return betweenDays;
	}

	/**
	 * @description 【取得当前日期】 默认格式 yyyy-MM-dd HH:mm:ss,如果格式错误,直接返回new Date
	 * @return String
	 * @createTime 2016-07-26 下午4:54:05
	 */
	public static Date getCurrentDate() {
		// 当前时间
		Date date = new Date();
		try {
			// 默认格式
			String format = "yyyy-MM-dd HH:mm:ss";
			SimpleDateFormat sdf = new SimpleDateFormat(format);

			String dateStr = DateFormatUtils.format(new Date(), format);
			date = sdf.parse(dateStr);
		} catch (ParseException e) {

			log.error("", e);
			date = new Date();
		}
		return date;
	}

	/**
	 * @description 【取得当前日期】
	 * @param format
	 * @return
	 * @createTime 2016-07-26 下午4:54:05
	 * @throws ParseException
	 */
	public static Date getCurrentDate(String format) {
		// 默认格式 yyyy-MM-dd
		Date date = null;
		try {
			date = String2Date(getCurrentDateStr(format), format);

		} catch (Exception e) {
			log.error("", e);
		}
		return date;
	}

	/**
	 * @description 【取得当前日期】 默认格式 yyyy-MM-dd HH:mm:ss
	 * @return String
	 * @createTime 2016-07-26 下午4:54:05
	 */
	public static String getCurrentDateStr() {
		// 默认格式 yyyy-MM-dd
		String format = "yyyy-MM-dd";
		return getCurrentDateStr(format);
	}

	/**
	 * @description 【得到当前的时间】精确到毫秒，格式为：hh:mm:ss
	 * @return Date
	 * @createTime 2016-07-26 下午4:54:05
	 */
	public static String getCurrentTimeStr() {
		// 默认格式 yyyy-MM-dd
		String format = "HH:mm:ss";
		return getCurrentDateStr(format);
	}

	/**
	 * @description 【取得当前日期】
	 * @return String
	 * @createTime 2016-07-26 下午4:54:05
	 */
	public static String getCurrentDateStr(String format) {
		// 按格式取得时间
		return DateFormatUtils.format(new Date(), format);
	}

	/**
	 * @description 【取得昨天日期】
	 * @return String
	 * @createTime 2016-07-26 下午4:54:05
	 */
	public static String getYesterDay() {
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1);
		return new SimpleDateFormat("yyyy-MM-dd ").format(cal.getTime());
	}

	/**
	 * @description 【字符转化为时间】
	 * @param dateStr
	 * @param format
	 * @return
	 * @createTime 2016-07-26 下午4:54:05
	 * @throws ParseException
	 */
	public static Date String2Date(String dateStr) throws ParseException {
		// 默认格式
		String format = "yyyy-MM-dd HH:mm:ss";
		return String2Date(dateStr, format);
	}

	/**
	 * @description 【字符转化为时间】
	 * @param dateStr
	 * @param format
	 * @return
	 * @createTime 2016-07-26 下午4:54:05
	 * @throws ParseException
	 */
	public static Date String2Date(String dateStr, String format) throws ParseException {
		if (StringUtils.isEmpty(dateStr))
			return null;

		// 格式化时间
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		Date date = sdf.parse(dateStr);

		return date;
	}

	/**
	 * @description 【转化为Timestamp】
	 * @param dateStr
	 * @return
	 * @createTime 2016-07-26 下午4:54:05
	 * @throws ParseException
	 */
	public static Timestamp Date2Timestamp(String dateStr) throws ParseException {
		if (StringUtils.isEmpty(dateStr))
			return null;
		// 转化为日期格式后转化为转化为Timestamp
		String format = "yyyy-MM-dd HH:mm:ss";
		Date date = String2Date(dateStr, format);

		return Date2Timestamp(date);
	}

	/**
	 * @description 【转化为Timestamp】
	 * @param date
	 * @return
	 * @createTime 2016-07-26 下午4:54:05
	 */
	public static Timestamp Date2Timestamp(Date date) {
		if (null == date)
			return null;
		// 格式化日期 精确到秒
		String dateStr = DateFormatUtils.format(date, "yyyy-MM-dd HH:mm:ss");
		return Timestamp.valueOf(dateStr.toString());
	}

	/**
	 * @description 【获取日期区间】
	 * @param type
	 * @return
	 * @createTime 2016-07-26 下午4:54:05
	 */
	public static List<Date> getDatePeriod(int type) {
		// 返回时间段
		List<Date> list = new ArrayList<Date>();
		// 当前时间
		Date nowDate = DateUtils.getCurrentDate();
		// 获取当前时间日历
		Calendar calendar = DateUtils.getCalendar(nowDate);
		calendar.set(Calendar.HOUR_OF_DAY, 23);
		calendar.set(Calendar.MINUTE, 59);
		calendar.set(Calendar.SECOND, 59);
		// 开始时间
		Date startTime = null;
		// 结束时间
		Date endTime = null;
		switch (type) {
		// 当天
		case 1:
			endTime = calendar.getTime();
			startTime = calendar.getTime();
			break;
		// 前三天
		case 2:
			endTime = calendar.getTime();
			startTime = DateUtils.addDay(calendar, -3);
			break;

		// 本周内
		case 3:
			int dayOfWeek = DateUtils.getDayOfWeek(nowDate);
			int endDateNum = 7 - dayOfWeek;
			endTime = DateUtils.addDay(calendar, endDateNum);
			startTime = DateUtils.addDay(calendar, -6);
			break;
		// 最近一个月
		case 4:
			endTime = calendar.getTime();
			startTime = DateUtils.addMonth(calendar, -1);
			break;
		// 最近三个月
		case 5:
			endTime = calendar.getTime();
			startTime = DateUtils.addMonth(calendar, -3);
			break;
		// 最近1年
		case 6:
			endTime = calendar.getTime();
			startTime = DateUtils.addYears(nowDate, -1);
			break;
		}
		list.add(startTime);
		list.add(endTime);
		// System.out.println(list.get(0));
		// System.out.println(list.get(1));
		return list;
	}

	public static void main(String[] args) {
		/*
		 * DateUtils.getDatePeriod(2); System.out.println(getYesterDay());
		 */
		/*try {
			DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			String curDatetime = "2010-05-24 14:33:22";

			Date date = formatter.parse(curDatetime);
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(date);
			calendar.add(Calendar.DATE, 1);

			String datetime = formatter.format(calendar.getTime());
			System.out.println(datetime);
		} catch (Exception e) {
			log.error("", e);
		}*/

		/*
		 * Calendar cal = Calendar.getInstance(); cal.add(Calendar.DATE, 7);
		 * String aa= new SimpleDateFormat("yyyy-MM-dd ").format(cal.getTime());
		 * 
		 * System.out.println(aa);
		 */
		
		System.out.println(getFormatDateStr(new Date(), "yyyyMMddHHmmss"));
	}

	/**
	 * 用于返回指定日期格式的日期增加指定天数的日期
	 * 
	 * @param date
	 *            指定日期
	 * @param format
	 *            指定日期格式
	 * @param days
	 *            指定天数
	 * @return 指定日期格式的日期增加指定天数的日期
	 */
	public static String getFutureDay(Date date, String format, int days) {
		String future = "";
		try {
			Calendar calendar = GregorianCalendar.getInstance();
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format);
			calendar.setTime(date);
			calendar.add(Calendar.DATE, days);
			date = calendar.getTime();
			future = simpleDateFormat.format(date);
		} catch (Exception e) {

		}
		return future;
	}

	/**
	 * @param date
	 *            指定日期
	 * @param days
	 *            指定天数
	 * @param date
	 * @param days
	 * @return
	 * @serialData 2013-2-1
	 * @author gf
	 */
	public static Date getFutureDay(Date date, int days) {
		Date future = null;
		Calendar calendar = GregorianCalendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.DATE, days);
		future = calendar.getTime();
		return future;
	}

	/**
	 * @description 【date加days日】 如果要想直接用date对象，请这样调用 addDay(getCalendar(Date
	 *              date), int days)
	 * @param c
	 * @param days
	 * @return
	 * @createTime 2016-07-26 下午4:54:05
	 */
	public static Date addDay(Calendar c, int days) {
		if (c == null)
			return null;
		c.add(Calendar.DAY_OF_MONTH, days);
		return c.getTime();
	}

	/**
	 * @description 【date加分钟】 如果要想直接用date对象，请这样调用 addMinutes(getCalendar(Date
	 *              date), int minutes)
	 * @param c
	 * @param minutes
	 * @return
	 * @createTime 2016-07-26 下午4:54:05
	 */
	public static Date addMinutes(Calendar c, int minutes) {
		if (c == null)
			return null;
		c.add(Calendar.MINUTE, minutes);
		return c.getTime();
	}

	/**
	 * @description 【date加小时】 如果要想直接用date对象，请这样调用 addHours(getCalendar(Date
	 *              date), int hours)
	 * @param c
	 * @param minutes
	 * @return
	 * @createTime 2016-07-26 下午4:54:05
	 */
	public static Date addHours(Calendar c, int hours) {
		if (c == null)
			return null;
		c.add(Calendar.HOUR_OF_DAY, hours);
		return c.getTime();
	}

	/**
	 * @description 【date加小时,分钟】 如果要想直接用date对象，请这样调用
	 *              addHoursAndMin(getCalendar(Date date), int hours,int
	 *              minutes)
	 * @param c
	 * @param hours
	 * @param imnutes
	 * @return
	 * @createTime 2016-07-26 下午4:54:05
	 */
	public static Date addHoursAndMin(Calendar c, int hours, int minutes) {
		if (c == null)
			return null;
		c.add(Calendar.HOUR_OF_DAY, hours);
		c.add(Calendar.MINUTE, minutes);
		return c.getTime();
	}

	/**
	 * 获得某年某月的最后一天
	 * 
	 * @param year
	 * @param month
	 * @return
	 */
	public static String getLastDayOfMonth(int year, int month) {
		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.YEAR, year);
		cal.set(Calendar.MONTH, month);
		// cal.set(Calendar.DAY_OF_MONTH,cal.getActualMaximum(Calendar.DATE));
		cal.set(Calendar.DAY_OF_MONTH, 1);
		cal.add(Calendar.DAY_OF_MONTH, -1);
		return new SimpleDateFormat("yyyy-MM-dd ").format(cal.getTime());
	}

	/**
	 * 获得某年某月的最后一天
	 * 
	 * @param year
	 * @param month
	 * @return
	 */
	public static String getLastDayOfMonth2(Date date) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DATE));
		return new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
	}

	/**
	 * 获得某年某月的第一天
	 * 
	 * @param year
	 * @param month
	 * @return
	 */
	public static String getFirstDayOfMonth(int year, int month) {
		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.YEAR, year);
		cal.set(Calendar.MONTH, month);
		cal.set(Calendar.DAY_OF_MONTH, cal.getMinimum(Calendar.DATE));
		return new SimpleDateFormat("yyyy-MM-dd ").format(cal.getTime());
	}

	/**
	 * 比较时间字符串的大小
	 * 
	 * @param dateSartStr
	 * @param dateEndStr
	 * @param format
	 * @return
	 * @throws ParseException
	 */
	public static int compareDateStr(String dateSartStr, String dateEndStr, String format) {
		int result = 0;
		if (StringUtils.isBlank(format)) {
			format = DateUtils.FORMAT_YMD;
		}
		try {
			Date dateStart = parseDate(dateSartStr, format);
			Date dateEnd = parseDate(dateEndStr, format);
			if (dateStart.after(dateEnd)) {
				result = 1;
			} else if (dateStart.before(dateEnd)) {
				result = -1;
			} else {
				result = 0;
			}
		} catch (ParseException e) {
			log.error("", e);
		}
		return result;
	}

	/**
	 * @description 【获取日期格式化后的字符串】
	 * @param date
	 * @param format
	 * @param addOrSubMins
	 *            增加或减少的分钟数
	 * @return
	 * @createTime 2016-07-26 下午4:54:05
	 */
	public static String getFormatDateStr(Date date, String format, long addOrSubMins) {
		if (format == null) {
			format = DateUtils.FORMAT_YMD;
		}
		if (addOrSubMins != 0) {
			date.setTime(date.getTime() + addOrSubMins * 60 * 1000);
		}
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		return sdf.format(date);
	}

	/**
	 * @description 【获取日期格式化后的字符串】
	 * @param date
	 * @param format
	 * @param addOrSubMins
	 *            增加或减少的分钟数
	 * @return
	 * @createTime 2016-07-26 下午4:54:05
	 */
	public static String getFormatDateStr1(Date date, String format, long addOrSubmins) {
		if (format == null) {
			format = DateUtils.FORMAT_YMD;
		}
		Date new_date = new Date();
		if (addOrSubmins != 0) {
			new_date.setTime(date.getTime() + addOrSubmins * 60 * 1000);
		}
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		return sdf.format(new_date);
	}
	
	//开始时间格式为：（2016-07-28 00:00:00）
	public static String getFormatDateBeginSeconds(String beginDt) {
		return beginDt + " " + "00:00:00";
	}
	//开始时间格式为：（2016-07-28 23:59:59）
	public static String getFormatDateEndSeconds(String endDt) {
		return endDt + " " + "23:59:59";
	}

}
