package cn.com.cgbchina.common.utils;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * 日期工具类
 * 
 * @author JieXin Li
 * @since 1.0
 */
public class BatchDateUtil {

	/** 日期格式 */
	public static final String FMT_DATE = "yyyyMMdd";
	/** 时间格式 */
	public static final String FMT_TIME = "HHmmss";
	/** 日期时间格式 */
	public static final String FMT_DATE_TIME = FMT_DATE + FMT_TIME;
	/** 日期格式_中国 */
	public static final String FMT_DATE_CN = "yyyy-MM-dd";
	/** 时间格式_中国 */
	public static final String FMT_TIME_CN = "HH:mm:ss";
	/** 日期时间格式_中国 */
	public static final String FMT_DATE_TIME_CN = FMT_DATE_CN + " " + FMT_TIME_CN;

	/** 默认日期格式 */
	public static final String DEFAULT_PATTERN = FMT_DATE;
	/** 日期时间格式 */
	public static final String DATE_TIME_PATTERN = "yyyy-MM-dd HH:mm:ss";

	// 防止实例化
	private BatchDateUtil() {
	};

	/**
	 * 获取昨天日期 格式yyyyMMdd
	 * 
	 * @return
	 */
	public static Date getLastDay(String date) {
		return addDay(parseDate(date), -1);
	}

	/**
	 * 获取一周前的日期 即七天 格式yyyyMMdd
	 * 
	 * @return
	 */
	public static Date getLastWeek(String date) {
		return addDay(parseDate(date), -7);
	}

	/**
	 * 获取一个月前的日期 格式yyyyMMdd
	 * 
	 * @return
	 */
	public static Date getLastMonth(String date) {
		return addMonth(parseDate(date), -1);
	}

	/**
	 * 格式化时间
	 * <p>
	 * 按照指定格式，格式化时间对象
	 * 
	 * <pre>
	 * 1. DateUtils.format(null, null) = null
	 * 2. DateUtils.format(null, "any") = null
	 * 3. DateUtils.format(any, null) = null
	 * </pre>
	 * 
	 * @param format
	 * @param date
	 * @return
	 */
	public static String format(Date date, String format) {
		if (date == null)
			return null;
		return new SimpleDateFormat(format).format(date);
	}

	/**
	 * 格式化时间： [yyyyMMdd]
	 * <p>
	 * 
	 * @param date
	 * @return
	 */
	public static String fmtDate(Date date) {
		return format(date, FMT_DATE);
	}

	/**
	 * 格式化时间： [HHmmss]
	 * <p>
	 * 
	 * @param date
	 * @return
	 */
	public static String fmtTime(Date date) {
		return format(date, FMT_TIME);
	}

	/**
	 * 格式化时间： [yyyyMMddHHmmss]
	 * <p>
	 * 
	 * @param date
	 * @return
	 */
	public static String fmtDateTime(Date date) {
		return format(date, FMT_DATE_TIME);
	}

	/**
	 * 格式化时间： [yyyy-MM-dd]
	 * <p>
	 * 
	 * @param date
	 * @return
	 */
	public static String fmtCnDate(Date date) {
		return format(date, FMT_DATE_CN);
	}

	/**
	 * 将默认格式yyyyMMdd的日期格式化成： [yyyy-MM-dd]
	 * <p>
	 * 
	 * @param date
	 * @return
	 */
	public static String fmtCnDate(String date) {
		return BatchDateUtil.fmtCnDate(BatchDateUtil.parseDate(date));
	}

	/**
	 * 格式化时间：[HH:mm:ss]
	 * <p>
	 * 
	 * @param date
	 * @return
	 */
	public static String fmtCnTime(Date date) {
		return format(date, FMT_TIME_CN);
	}

	/**
	 * 格式化时间： [yyyy-MM-dd HH:mm:ss]
	 * <p>
	 * 
	 * @param date
	 * @return
	 */
	public static String fmtCnDateTime(Date date) {
		return format(date, FMT_DATE_TIME_CN);
	}

	/**
	 * 使用默认的格式yyyyMMdd格式化日期
	 * 
	 * @param date 待格式化的日期
	 * 
	 * @return 格式化后的日期字符串
	 */
	public static String format(Date date) {
		SimpleDateFormat sdf = new SimpleDateFormat(DEFAULT_PATTERN);
		return sdf.format(date);
	}

	/**
	 * 使用默认的格式yyyyMMdd把字符串转换为日期
	 * 
	 * @param dateStr 日期字符串表示
	 * @return 转换后的日期
	 * @throws ParseException 如果输入参数有误
	 */
	public static Date parseDate(String dateStr) {
		return parseDate(dateStr, DEFAULT_PATTERN);
	}

	/**
	 * 使用指定的格式解释日期字符串为Date对象
	 * 
	 * @param dateStr 日期字符串
	 * @param pattern 格式
	 * @return A Date parsed from the string.
	 */
	public static Date parseDate(String dateStr, String pattern) {
		if (dateStr == null) {
			return null;
		}
		if (dateStr.length() != pattern.length()) {
			throw new IllegalArgumentException("参数输入不正确,日期:" + dateStr + " 格式:" + pattern);
		}
		SimpleDateFormat sdf = new SimpleDateFormat(pattern);
		try {
			sdf.setLenient(false);// 严格按照指定格式来解释
			return sdf.parse(dateStr);
		} catch (Exception e) {
			throw new IllegalArgumentException(e);
		}
	}

	/**
	 * 返回加i小时后的日期
	 * 
	 * @param date 日期
	 * @param i 小时数
	 * @return
	 */
	public static Date addHour(Date date, int i) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.HOUR_OF_DAY, i);
		return calendar.getTime();
	}

	/**
	 * 返回加减i天后的日期，传入整数为加，负数为减
	 * 
	 * <pre>
	 * 这里使用字符串表示时间：
	 * DateUtils.addDay(null, 1)  =  null ;
	 * DateUtils.addDay("2010-01-01", 0)  =  "2010-01-01" ;
	 * DateUtils.addDay("2010-01-01", 1)  =  "2010-01-02" ;
	 * DateUtils.addDay("2010-01-01", -1)  =  "2009-12-31" ;
	 * </pre>
	 */
	public static Date addDay(Date date, int i) {
		if (date == null) {
			return null;
		}
		if (i == 0) {
			return date;
		}
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.DATE, i);
		return calendar.getTime();
	}

	/**
	 * 返回加减i天后的日期字符串[yyyyMMdd]，传入整数为加，负数为减
	 * 
	 * <pre>
	 * 这里使用字符串表示时间：
	 * DateUtils.addDay(null, 1)  =  null ;
	 * DateUtils.addDay("20100101", 0)  =  "20100101" ;
	 * DateUtils.addDay("20100101", 1)  =  "20100102" ;
	 * DateUtils.addDay("20100101", -1)  =  "20091231" ;
	 * </pre>
	 */
	public static String addDay(String day, int i) {
		return format(addDay(parseDate(day), i));
	}

	/**
	 * 使用指定的格式解释时间字符串，并对其进行天数的加减操作
	 * 
	 * <pre>
	 * 这里使用字符串表示时间：
	 * DateUtils.addDay(null, 1)  =  null ;
	 * DateUtils.addDay("20100101", 0, 'yyyyMMdd')  =  "20100101" ;
	 * DateUtils.addDay("20100101", 1, 'yyyyMMdd')  =  "20100102" ;
	 * DateUtils.addDay("20100101", -1, 'yyyyMMdd')  =  "20091231" ;
	 * </pre>
	 */
	public static String addDay(String day, int i, String pattern) {
		return format(addDay(parseDate(day, pattern), i), pattern);
	}

	/**
	 * 返回加减i月后的日期，传入整数为加，负数为减
	 * 
	 * @param date
	 * @param i
	 * @return 加减i月后的日期
	 */
	public static Date addMonth(Date date, int i) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.MONTH, i);
		return calendar.getTime();
	}

	/**
	 * 判断日期字符串是否合法
	 * 
	 * @param date
	 * @return 如果是yyyyMMdd格式日期则返回true,否则返回false;
	 */
	public static boolean isDate(String date) {
		try {
			parseDate(date);
			return true;
		} catch (Exception e) {
			return false;
		}
	}

	/**
	 * 判断日期字符
	 * 
	 * @param date
	 * @param pattern
	 * @return
	 */
	public static boolean isDate(String date, String pattern) {
		try {
			parseDate(date, pattern);
			return true;
		} catch (Exception e) {
			return false;
		}

	}

	/**
	 * 返回当前年的最后一天
	 * 
	 * @return 当前年的最后一天
	 */
	public static Date getLastDayOfYear() {
		Calendar calendar = Calendar.getInstance();
		int day = calendar.getActualMaximum(Calendar.DAY_OF_YEAR);
		calendar.set(Calendar.DAY_OF_YEAR, day);
		return calendar.getTime();
	}

	/**
	 * 返回当前年的最后一天
	 * 
	 * @param year
	 * @return 当前年的最后一天
	 */
	public static Date getLastDateOfYear(int year) {
		Calendar calendar = Calendar.getInstance();
		calendar.set(Calendar.YEAR, year);
		int day = calendar.getActualMaximum(Calendar.DAY_OF_YEAR);
		calendar.set(Calendar.DAY_OF_YEAR, day);
		return calendar.getTime();
	}

	/**
	 * 返回当前年的最后一天
	 * 
	 * @param year
	 * @return 当前年的最后一天
	 */
	public static Date getLastDateOfYear(Date date) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		int day = calendar.getActualMaximum(Calendar.DAY_OF_YEAR);
		calendar.set(Calendar.DAY_OF_YEAR, day);
		return calendar.getTime();
	}

	/**
	 * 返回加减yy年mm月dd日后的日期，传入整数为加，负数为减
	 * 
	 * @param date 日期
	 * @param yy 年
	 * @param mm 月
	 * @param dd 日
	 * @return 加减yy年mm月dd日后的日期
	 */
	public static Date addYear(Date date, int yy, int mm, int dd) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.YEAR, yy);
		calendar.add(Calendar.MONTH, mm);
		calendar.add(Calendar.DATE, dd);
		return calendar.getTime();
	}

	/**
	 * 使用指定年、月、日和当前时、分、秒解析为Date对象
	 * 
	 * @param year
	 * @param month
	 * @param date
	 * @return
	 */
	public static Date parseDate(int year, int month, int date) {
		Calendar c = Calendar.getInstance();
		c.set(Calendar.YEAR, Integer.valueOf(year));
		c.set(Calendar.MONTH, Integer.valueOf(month) - 1);
		c.set(Calendar.DAY_OF_MONTH, Integer.valueOf(date));
		return c.getTime();
	}

	/**
	 * 使用指定的格式解释日期字符串为Timestamp对象
	 * 
	 * @param dateStr
	 * @param pattern
	 * @return
	 */
	public static Timestamp parseTimestamp(String dateStr, String pattern) {
		return new Timestamp(parseDate(dateStr, pattern).getTime());
	}

	/**
	 * 使用yyyyMMdd格式解释日期字符串为Timestamp对象
	 * 
	 * @param dateStr
	 * @return
	 */
	public static Timestamp parseTimestamp(String dateStr) {
		return parseTimestamp(dateStr, DEFAULT_PATTERN);
	}

	/**
	 * 解释日期为Timestamp对象
	 * 
	 * @param date
	 * @return
	 */
	public static Timestamp parseTimestamp(Date date) {
		return new Timestamp(date.getTime());
	}

	/**
	 * 获取上个月的第一天
	 * 
	 * @param dateStr 格式为yyyyMMdd
	 * @return
	 */
	public static Date getFirstDayOfLastMonth(String dateStr) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(parseDate(dateStr));
		calendar.add(Calendar.MONTH, -1);
		int i = calendar.getActualMinimum(Calendar.DAY_OF_MONTH);
		calendar.set(Calendar.DAY_OF_MONTH, i);
		return calendar.getTime();
	}

	/**
	 * 获取上个月的最后一天
	 * 
	 * @param dateStr 格式为yyyyMMdd
	 * @return
	 */
	public static Date getLastDayOfLastMonth(String dateStr) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(parseDate(dateStr));
		calendar.add(Calendar.MONTH, -1);
		int i = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
		calendar.set(Calendar.DAY_OF_MONTH, i);
		return calendar.getTime();
	}

	/**
	 * 返回当前月的几号
	 * 
	 * @return
	 */
	public static int getDayOfMonth() {
		Calendar calendar = Calendar.getInstance();
		return calendar.get(Calendar.DAY_OF_MONTH);
	}

	/**
	 * 返回输入日期为当年的几月
	 * 
	 * @param date
	 * @return
	 */
	public static int getMonthOfYear(Date date) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		// 月份从0开始
		return calendar.get(Calendar.MONTH) + 1;
	}

	/**
	 * 返回指定日期为月的几号
	 * 
	 * @return
	 */
	public static int getDayOfMonth(Date date) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		return calendar.get(Calendar.DAY_OF_MONTH);
	}

}
