package com.lsh.chinarc.common;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

public class DateUtil {
    // Ĭ�����ڸ�ʽ
	public static final String DATE_DEFAULT_FORMAT ="yyyy-MM-dd";
	
	// Ĭ������ʱ���ʽ
	public static final String DATETIME_DEFAULT_FORMAT = "yyyy-MM-dd HH:mm:ss";
	public static final String DATETIME_DEFAULT_FORMAT_GL="yyyy-MM-dd'T'HH:mm:ssX";
	
	// Ĭ��ʱ���ʽ
	public static final String TIME_DEFAULT_FORMAT = "HH:mm:ss";
	
	public static final String yyyyMMddHHmmsssss = "yyyyMMddHHmmsssss";
	
	// ʱ���ʽ��
	private static DateFormat dateFormat = null;
	private static DateFormat dateTimeFormat = null;
	private static DateFormat timeFormat = null;
	@SuppressWarnings("unused")
	private static Calendar gregorianCalendar = null;
	
	static{
		dateFormat = new SimpleDateFormat(DATE_DEFAULT_FORMAT);
		dateTimeFormat = new SimpleDateFormat(DATETIME_DEFAULT_FORMAT);
		timeFormat = new SimpleDateFormat(TIME_DEFAULT_FORMAT);
		gregorianCalendar = new GregorianCalendar();
	}
	
	/**
	 * ��õ�ǰ����
	 * @param date �ַ������ڲ���
	 * @param format ��ʽ����ʽ
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
	 * �Զ������ڸ�ʽ��yyyy-MM-dd
	 * @param date �ַ������ڲ���
	 * @param format ��ʽ����ʽ
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
	 * ���ڸ�ʽ��yyyy-MM-dd
	 * @param date �ַ������ڲ���
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
	 * ���ڸ�ʽ��yyyy-MM-dd HH:mm:ss 
	 * @param date �ַ������ڲ���
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
	 * ���ڸ�ʽ��HH:mm:ss 
	 * @param date �ַ������ڲ���
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
	 * ��õ�ǰ���ڸ�ʽ��yyyy-MM-dd
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
	 * ��õ�ǰ���ڸ�ʽ��yyyy-MM-dd HH:mm:ss
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
	 * ��õ�ǰ���ڸ�ʽ��HH:mm:ss
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
	 * ��õ�ǰ���ڸ�ʽ��
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
	
	/**��ȡ��ǰ��*/
	public static int getNowYYYY(){
        Calendar now = Calendar.getInstance();  
        return now.get(Calendar.YEAR);
	}
	
	/**��ȡ��ǰ��*/
	public static int getNowMM(){
        Calendar now = Calendar.getInstance();  
        return (now.get(Calendar.MONTH) + 1);
	}
	
	/**��ȡ��ǰ��*/
	public static int getNowDD(){
        Calendar now = Calendar.getInstance();  
        return now.get(Calendar.DAY_OF_MONTH);
	}
	
	/**
	 * ��ȡʱ��
	 * @param min
	 * @return
	 */
	public static Date addMinutes(int min){
		
		Calendar c = Calendar.getInstance();
		c.add(Calendar.MINUTE, min);
		return c.getTime();
		
	}
	
	/**
	 * ����ʱ���ʽ��
	 * @param s
	 * @return
	 */
	public static String DateString2formatString(String s)  {  
	    String str="";  
	    try  
	    {  
	        SimpleDateFormat sdf=new SimpleDateFormat(DATETIME_DEFAULT_FORMAT);  
	        SimpleDateFormat sd=new SimpleDateFormat(DATETIME_DEFAULT_FORMAT_GL);  
	        Date date=sd.parse(s);  
	        str=sdf.format(date);  
	    }  
	    catch(Exception e)  
	    {  
	        System.out.println(e.getMessage());  
	        return str;  
	    }  
	    return str;  
	}   
}
