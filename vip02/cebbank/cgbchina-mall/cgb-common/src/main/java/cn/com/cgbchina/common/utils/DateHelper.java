package cn.com.cgbchina.common.utils;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * Created by zhangshiqiang on 2016/4/29.
 */
public class DateHelper {
	// 定义日期格式 add by zhangshiqiang
	public static final String ENG_DATE_FROMAT = "EEE, d MMM yyyy HH:mm:ss z";
	public static final String YYYY_MM_DD_HH_MM_SS = "yyyy-MM-dd HH:mm:ss";
	public static final String YYYY_MM_DD_HH_MM = "yyyy-MM-dd HH:mm";
	public static final String YYYY_MM_DD = "yyyy-MM-dd";
    public static final String YYYY_MM = "yyyy-MM-dd";
	public static final String YYYY = "yyyy";
	public static final String MM = "MM";
	public static final String DD = "dd";

	/**
	 * 获取前一天日期yyyyMMdd
	 *
	 * @return
	 */
	public static String getYestoday() {
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.DATE, -1);
		return new SimpleDateFormat("yyyy-MM-dd").format(calendar.getTime());
	}

	/**
	 * 获取当前的日期yyyyMMdd
	 */
	public static String getCurrentDate() {
		return new SimpleDateFormat("yyyy-MM-dd").format(new Date());
	}

	/**
	 * 获取当前的时间yyyyMMddHHmmss
	 */
	public static String getCurrentTime() {
		return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
	}

	/**
	 * 获取当前的时间(毫秒)yyyyMMddHHmmss
	 */
	public static String getCurrentTimess() {
		return new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());
	}

	/**
	 * String类型转化成Date类型，并格式化
	 * 
	 * @param dateString
	 * @param formatString
	 * @return
	 */
	public static Date string2Date(String dateString, String formatString) {
		Date formatDate = null;
		DateFormat format = new SimpleDateFormat(formatString);
		try {
			formatDate = format.parse(dateString);
		} catch (ParseException e) {
			return null;
		}
		return formatDate;
	}

	/**
	 * Date类型转String类型，并格式化
	 * 
	 * @param date
	 * @param formatStr
	 * @return
	 */
	public static String date2string(Date date, String formatStr) {
		String strDate = "";
		SimpleDateFormat sdf = new SimpleDateFormat(formatStr);
		strDate = sdf.format(date);
		return strDate;
	}

	// public static void main(String arg[]){
	// Date date = string2Date("2016-02-02",YYYY_MM_DD);
	// System.out.print(date);
	// }

    public static String getyyyyMMdd(Date date) {
//		return yyyyMMddFormat.format(date);
        return new SimpleDateFormat("yyyyMMdd").format(date);
    }

    /**
     * 返回当前日期格式yyyyMMdd
     *
     * @return
     */
    public static String getyyyyMMdd() {
//		return yyyyMMddFormat.format(new Date());
        return new SimpleDateFormat("yyyyMMdd").format(new Date());
    }

    /**
     * 返回当前时间
     *
     * @return
     */
    public static String getHHmmss() {
//		return HHmmssFormat.format(new Date());
        return new SimpleDateFormat("HHmmss").format(new Date());
    }

	/**
	 * 返回当前日期格式yyyyMM
	 *
	 * @return
	 */
	public static String getyyyyMM(Date date) {
		return new SimpleDateFormat("yyyyMM").format(date);
	}
	/**
	 * 返回传入时间的时分秒
	 *
	 * @return
	 */
	public static String getHHmmss(Date date) {
		return new SimpleDateFormat("HHmmss").format(date);
	}
}
