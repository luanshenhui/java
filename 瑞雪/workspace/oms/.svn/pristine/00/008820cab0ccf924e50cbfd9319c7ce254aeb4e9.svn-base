package cn.rkylin.core.utils;

import java.lang.reflect.Method;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateFormatUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class DateUtils extends org.apache.commons.lang.time.DateUtils {

	public static final Log log = LogFactory.getLog(DateUtils.class);
	public static String[] MONTH_ENAME = { "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV",
			"DEC" };

	public static String[] DAY_CNAME = { "周日", "周一", "周二", "周三", "周四", "周五", "周六" };

	private static final String[] parsePatterns = { "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd", "HH:mm", "yyyy/MM/dd HH:mm:ss",
			"yyyy/MM/dd", "HHmm", "ddMMMyy", "yyyyMMddHHmmss" };

	public static String getMonthEnameNum(String monthEname, int length) {
		int j = 0;
		for (int i = 0; i < MONTH_ENAME.length; i++) {
			if (MONTH_ENAME[i].equals(monthEname)) {
				break;
			}
			j++;
		}
		String monthEnameNum = String.valueOf(j);
		if ((length == 2) && (monthEnameNum.length() < length)) {
			monthEnameNum = "0" + monthEnameNum;
		}
		return monthEnameNum;
	}

	public static Date parseFlightDate(String dateStr, String format) {
		String yearStr = dateStr.substring(dateStr.length() - 2);
		return parseFlightDate(yearStr, dateStr, "0000", format);
	}

	public static long getTime(Date date, boolean isEnd) {
		return resetTime(date, isEnd).getTime() / 1000L;
	}

	public static Date resetTime(Date date, boolean isEnd) {
		Calendar c = getCalendar(date);
		c.set(11, 0);
		c.set(12, 0);
		c.set(13, 0);
		return c.getTime();
	}

	public static Date parseFlightDate(String yearStr, String dateStr, String timeStr, String format) {
		Calendar c = null;
		int year = -1;
		String monthCode = dateStr.substring(2, 5);
		int month = Integer.parseInt(getMonthEnameNum(monthCode, 1));
		int curMonth = -1;
		if (StringUtils.isEmpty(yearStr)) {
			c = getCalendar(new Date());
			year = c.get(1);
			curMonth = c.get(2);
			if (month < curMonth)
				year++;
		} else {
			year = Integer.parseInt(yearStr);
		}
		String dayStr = dateStr.substring(0, 2);
		if (dayStr.startsWith("0")) {
			dayStr = dayStr.substring(1, 2);
		}
		String hourStr = timeStr.substring(0, 2);
		if (hourStr.startsWith("0")) {
			hourStr = hourStr.substring(1, 2);
		}
		String minuteStr = null;
		minuteStr = timeStr.substring(2, 4);
		if (minuteStr.startsWith("0")) {
			minuteStr = minuteStr.substring(1, 2);
		}
		Date flightDate = null;
		try {
			flightDate = getDate(year, monthCode, Integer.parseInt(dayStr), Integer.parseInt(hourStr),
					Integer.parseInt(minuteStr), 0);
		} catch (Exception e) {
			log.error("", e);
		}
		return flightDate;
	}

	public static Date parseDate(String str) throws ParseException {
		return parseDate(str, parsePatterns);
	}

	public static Date parseDate(String str, String parsePattern) throws ParseException {
		return parseDate(str, new String[] { parsePattern });
	}

	public static Calendar getCalendar(Date date) {
		if (date == null)
			return null;
		Calendar c = new GregorianCalendar();
		c.setTime(date);
		return c;
	}

	public static Date addMonth(Calendar c, int months) {
		if (c == null)
			return null;
		c.add(2, months);
		return c.getTime();
	}

	public static Date addDay(Calendar c, int days) {
		if (c == null)
			return null;
		c.add(5, days);
		return c.getTime();
	}

	public static Date addMinutes(Calendar c, int minutes) {
		if (c == null)
			return null;
		c.add(12, minutes);
		return c.getTime();
	}

	public static Date addHours(Calendar c, int hours) {
		if (c == null)
			return null;
		c.add(11, hours);
		return c.getTime();
	}

	public static Date addHoursAndMin(Calendar c, int hours, int minutes) {
		if (c == null)
			return null;
		c.add(11, hours);
		c.add(12, minutes);
		return c.getTime();
	}

	public static int getDayOfWeek(Date date) {
		Calendar c = getCalendar(date);

		int dayOfWeek = c.get(7) - 1;

		if (dayOfWeek == 0)
			dayOfWeek = 7;
		return dayOfWeek;
	}

	public static String getDayOfWeekCn(Date date) {
		if (date == null) {
			return null;
		}

		int t = getDayOfWeek(date);
		if (t == 7)
			t = 0;
		return DAY_CNAME[t];
	}

	public static String getDayOfWeekCn() {
		return getDayOfWeekCn(new Date());
	}

	public static Date getDate(String monthCode, int day) {
		if (monthCode == null)
			return null;
		Calendar c = getCalendar(new Date());

		int i = 0;
		for (String monthStr : MONTH_ENAME) {
			if (monthStr.equalsIgnoreCase(monthCode)) {
				break;
			}
			i++;
		}
		c.set(2, i);
		c.set(5, day);
		return c.getTime();
	}

	public static Date getDate(int year, String monthCode, int day) {
		if (monthCode == null)
			return null;
		Calendar c = getCalendar(new Date());

		int i = 0;
		for (String monthStr : MONTH_ENAME) {
			if (monthStr.equalsIgnoreCase(monthCode)) {
				break;
			}
			i++;
		}
		c.set(year, i, day);
		return c.getTime();
	}

	public static Date getDate(int year, String monthCode, int day, int hourOfDay, int minute, int second) {
		if (monthCode == null)
			return null;
		Calendar c = new GregorianCalendar();

		int i = 0;
		for (String monthStr : MONTH_ENAME) {
			if (monthStr.equalsIgnoreCase(monthCode)) {
				break;
			}
			i++;
		}

		c.setTimeInMillis(0L);
		c.set(year, i, day, hourOfDay, minute, second);
		return c.getTime();
	}

	public static Date getCalendarDate(int day, int month, int year) {
		Calendar calendar = Calendar.getInstance();
		calendar.set(year, month, day);
		Date date = calendar.getTime();
		return date;
	}

	public static boolean isLeapYear(int year) {
		GregorianCalendar gc = new GregorianCalendar();
		return gc.isLeapYear(year);
	}

	public static Timestamp utilDate2SqlDate(Date date) {
		if (date == null)
			return null;
		Calendar c = getCalendar(date);
		Timestamp sqlDate = new Timestamp(c.getTimeInMillis());
		return sqlDate;
	}

	public static Timestamp getTimestamp(Object value) {
		if (value == null)
			return null;
		Timestamp timestamp = null;
		if ((value instanceof Timestamp)) {
			timestamp = (Timestamp) value;
		} else {
			Class clz = value.getClass();
			Method m = null;
			try {
				m = clz.getMethod("timestampValue", null);
				timestamp = (Timestamp) m.invoke(value, null);
			} catch (Exception e) {
				log.error("", e);
			}
		}
		return timestamp;
	}

	public static double getIntervalMinutes(Date minDate, Date maxDate) {
		double days = 0.0D;
		if ((minDate == null) || (maxDate == null))
			return days;
		try {
			long interval = maxDate.getTime() - minDate.getTime();
			days = Double.valueOf(interval).doubleValue() / 1000.0D / 60.0D;
		} catch (Exception e) {
			log.error("", e);
		}
		return days;
	}

	public static double getIntervalHours(Date minDate, Date maxDate) {
		double days = 0.0D;
		if ((minDate == null) || (maxDate == null))
			return days;
		try {
			days = getIntervalMinutes(minDate, maxDate) / 60.0D;
		} catch (Exception e) {
			log.error("", e);
		}
		return days;
	}

	public static boolean checkIsIntervalDay(String startTime, String endTime, String format) {
		boolean isIntervalDay = false;
		if ((parsePatterns[2].equals(format)) && ("00:00".compareTo(endTime) < 0) && ("12:00".compareTo(endTime) >= 0)
				&& ("12:00".compareTo(startTime) < 0) && ("23:59".compareTo(startTime) >= 0))
			isIntervalDay = true;
		else if ((parsePatterns[5].equals(format)) && ("0000".compareTo(endTime) < 0)
				&& ("1200".compareTo(endTime) >= 0) && ("1200".compareTo(startTime) < 0)
				&& ("2359".compareTo(startTime) >= 0))
			isIntervalDay = true;
		else {
			log.error(startTime + " " + endTime + " " + format);
		}
		return isIntervalDay;
	}

	public static double getIntervalDays(Date minDate, Date maxDate) {
		double days = 0.0D;
		if ((minDate == null) || (maxDate == null))
			return days;
		try {
			days = getIntervalHours(minDate, maxDate) / 24.0D;
		} catch (Exception e) {
			log.error("", e);
		}
		return days;
	}

	public static void main(String[] args) {
		Calendar c = getCalendar(new Date());
		int dayOfWeek = c.get(7) - 1;

		Calendar gc = new GregorianCalendar();
		Date tomorrow = addDay(gc, 1);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date tomorrow2 = null;
		try {
			tomorrow2 = sdf.parse(sdf.format(tomorrow));
		} catch (ParseException e) {
			log.error("", e);
		}
	}

	public static Date getCurrentDate() {
		Date date = new Date();
		try {
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

	public static Date getCurrentDate(String format) throws ParseException {
		return String2Date(getCurrentDateStr(format), format);
	}

	public static String getCurrentDateStr() {
		String format = "yyyy-MM-dd";
		return getCurrentDateStr(format);
	}

	public static String getCurrentTimeStr() {
		String format = "HH:mm:ss";
		return getCurrentDateStr(format);
	}

	public static String getCurrentDateStr(String format) {
		return DateFormatUtils.format(new Date(), format);
	}

	public static Date String2Date(String dateStr) throws ParseException {
		String format = "yyyy-MM-dd HH:mm:ss";
		return String2Date(dateStr, format);
	}

	public static Date String2Date(String dateStr, String format) throws ParseException {
		if (StringUtils.isEmpty(dateStr)) {
			return null;
		}

		SimpleDateFormat sdf = new SimpleDateFormat(format);
		Date date = sdf.parse(dateStr);

		return date;
	}

	public static Timestamp Date2Timestamp(String dateStr) throws ParseException {
		if (StringUtils.isEmpty(dateStr)) {
			return null;
		}

		String format = "yyyy-MM-dd HH:mm:ss";
		Date date = String2Date(dateStr, format);

		return Date2Timestamp(date);
	}

	public static Timestamp Date2Timestamp(Date date) {
		if (date == null) {
			return null;
		}

		String dateStr = DateFormatUtils.format(date, "yyyy-MM-dd HH:mm:ss");
		return Timestamp.valueOf(dateStr.toString());
	}

	public static List<Date> getDatePeriod(int type) {
		List list = new ArrayList();

		Date nowDate = getCurrentDate();

		Calendar calendar = getCalendar(nowDate);
		calendar.set(11, 23);
		calendar.set(12, 59);
		calendar.set(13, 59);

		Date startTime = null;

		Date endTime = null;
		switch (type) {
		case 1:
			endTime = calendar.getTime();
			startTime = calendar.getTime();
			break;
		case 2:
			endTime = calendar.getTime();
			startTime = addDay(calendar, -3);
			break;
		case 3:
			int dayOfWeek = getDayOfWeek(nowDate);
			int endDateNum = 7 - dayOfWeek;
			endTime = addDay(calendar, endDateNum);
			startTime = addDay(calendar, -6);
			break;
		case 4:
			endTime = calendar.getTime();
			startTime = addMonth(calendar, -1);
			break;
		case 5:
			endTime = calendar.getTime();
			startTime = addMonth(calendar, -3);
			break;
		case 6:
			endTime = calendar.getTime();
		}

		list.add(startTime);
		list.add(endTime);
		return list;
	}

	public static String getFutureDay(Date date, String format, int days) {
		String future = "";
		try {
			Calendar calendar = Calendar.getInstance();
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format);
			calendar.setTime(date);
			calendar.add(5, days);
			date = calendar.getTime();
			future = simpleDateFormat.format(date);
		} catch (Exception localException) {
		}
		return future;
	}

	public static Date getFutureDate(Date date, int days) {
		try {
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(date);
			calendar.add(5, days);
			date = calendar.getTime();
		} catch (Exception localException) {
		}
		return date;
	}

	public static String getNextDay(Date date, String format, int days) {
		String future = "";
		try {
			Calendar calendar = Calendar.getInstance();
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format);
			calendar.setTime(date);
			date = calendar.getTime();
			future = simpleDateFormat.format(date);
		} catch (Exception localException) {
		}
		return future;
	}

	public static Date getDayEndTime(Date date) {
		if (date == null) {
			date = DateUtils.getCurrentDate();
		}
		Calendar c = new GregorianCalendar();
		c.setTime(date);
		c.set(11, 23);
		c.set(13, 59);
		c.set(12, 59);
		return c.getTime();
	}

	public static Date getDayStartTime(Date date) {
		if (date == null) {
			date = DateUtils.getCurrentDate();
		}
		Calendar c = new GregorianCalendar();
		c.setTime(date);
		c.set(11, 0);
		c.set(13, 0);
		c.set(12, 0);
		return c.getTime();
	}

}
