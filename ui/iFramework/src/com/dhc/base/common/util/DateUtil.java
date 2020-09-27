package com.dhc.base.common.util;

import java.util.*;
import java.text.*;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Title: DateUtil Description: 处理日期对象的工具类
 * 
 */
public class DateUtil {
	private static Log log = LogFactory.getLog(DateUtil.class);
	private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	/** 获取当天的日期 */
	public static Date today() {
		return new Date(System.currentTimeMillis());
	}

	/**
	 * 转换日期的格式到yyyy-MM-dd HH:mm:ss
	 */
	public static String stringDateTime(Date date) {
		if (date == null)
			return "";
		else
			return dateFormat.format(date);
	}

	/**
	 * 按格式转换日期的格式到固定格式的时间 <br>
	 * 转换时格式的字符必须符合要求.
	 * 
	 * @param date
	 *            待转换的日期.
	 * @param format
	 *            转换格式. 格式必须符合: <br>
	 *            yyyy, 输出四位年 yy, 输出两位年 <br>
	 *            MM, 月 <br>
	 *            dd, 日期 <br>
	 *            HH, 小时24小时制 <br>
	 *            mm, 分钟 <br>
	 *            ss, 秒 <br>
	 *            中间间隔符号按照需要填写. 如: yyyy--MM--dd
	 */
	public static String stringDateTime(Date date, String format) {

		if (date == null)
			return null;

		SimpleDateFormat subDateFormat = new SimpleDateFormat(format);
		return subDateFormat.format(date);
	}

	/**
	 * 为 sql 里直接通过result.getObject获取日期型变量准备的方法.
	 * 
	 * @param date
	 * @return 输出格式为"yyyy-MM-dd HH:mm:ss"
	 */
	public static String stringDateTime(Object date) {
		return stringDateTime((java.util.Date) date);
	}

	/**
	 * 为 sql 里直接通过result.getObject获取日期型变量准备的方法. 按格式转换日期的格式到固定格式的时间 <br>
	 * 转换时格式的字符必须符合要求.
	 * 
	 * @param date
	 *            待转换的日期.
	 * @param format
	 *            转换格式. 格式必须符合: <br>
	 *            yyyy, 输出四位年 yy, 输出两位年 <br>
	 *            MM, 月 <br>
	 *            dd, 日期 <br>
	 *            HH, 小时 <br>
	 *            mm, 分钟 <br>
	 *            ss, 秒 <br>
	 *            中间间隔符号按照需要填写. 如: yyyy--MM--dd
	 */
	public static String stringDateTime(Object date, String format) {
		return stringDateTime((java.util.Date) date, format);
	}

	/**
	 * 将固定格式字符串转化为日期"
	 * 
	 * @param strDate
	 *            格式为:"yyyy-MM-dd HH:mm:ss"
	 * @return
	 */
	public static Date dateString(String strDate) {
		try {
			return dateFormat.parse(strDate);
		} catch (ParseException e) {
			log.error("trans '" + strDate + "' to Date:" + e.getMessage());
			return null;
		}
	}

	/**
	 * 将日期型的对象进行运算.
	 * 
	 * @param date
	 *            待计算的日期
	 * @param field
	 *            待计算的项目 Calendar.YEAR, Calendar.MONTH, Calendar.DAY_OF_MONTH,
	 *            <br>
	 *            Calendar.HOUR, Calendar.MINUTE, Calendar.SECOND
	 * @param amount
	 *            待计算的数量. 负数表示减.
	 */
	public static Date dateAdd(Date date, int field, int amount) {

		if (date == null)
			return null;

		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(field, amount);
		return calendar.getTime();
	}

	/**
	 * 计算某天所在月的第一天
	 */
	public static Date monthlyFirstDate(Date date) {
		if (date == null)
			return null;

		String strDate = stringDateTime(date, "yyyy-MM");
		return dateString(strDate + "-01 00:00:00");
	}

	/**
	 * 当月第一天
	 */
	public static Date monthlyFirstDate() {
		return monthlyFirstDate(today());
	}

	/**
	 * 计算某天所在月的最后一天
	 */
	public static Date monthlyEndDate(Date date) {
		if (date == null)
			return null;
		Date nextMonth = dateAdd(date, Calendar.MONTH, 1);
		String strDate = stringDateTime(nextMonth, "yyyy-MM");
		strDate += "-01 23:59:59";
		return dateAdd(dateString(strDate), Calendar.DATE, -1);
	}

	/**
	 * 当月最后一天。
	 */
	public static Date monthlyEndDate() {
		return monthlyEndDate(today());
	}
}
