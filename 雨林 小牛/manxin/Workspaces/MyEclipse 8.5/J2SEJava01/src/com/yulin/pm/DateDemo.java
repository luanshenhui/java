package com.yulin.pm;

import java.text.SimpleDateFormat;
import java.util.Date;
public class DateDemo {

	/**
	 * 时间函数(API)
	 */
	public static void main(String[] args) {
		Date date = new Date();
		System.out.println("当前的系统时间:" + date);
		
		//时间的格式化标准
		/**
		 * YYYY：年
		 * MM：月
		 * dd：日
		 * day：星期
		 * hh：时
		 * mm：分
		 * ss：秒
		 */
		String timeFomat = "yyyy-MM-dd E hh:mm:ss";
		SimpleDateFormat sdf = new SimpleDateFormat(timeFomat);
		String time = sdf.format(date);
		System.out.println("当前时间:" + time);
		

	}

}
