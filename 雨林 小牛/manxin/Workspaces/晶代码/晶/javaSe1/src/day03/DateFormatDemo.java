package day03;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * DateFormat是SimpleDateFormat的父类
 * 以指定 的日期格式输出    yyyy-MM-dd  yyyy/MM/dd
 * @author Administrator
 *
 */
public class DateFormatDemo {
	public static void main(String[] args) {
		//创建当前系统时间
		Date now = new Date();
		/**
		 * getDateInstance(int format,Locale locale)
		 * 参数1:转换为字符串后的信息格式
		 * 参数2:对应的地区
		 * 
		 * 参数1对应DateFormat的常量
		 *     SHORT:信息量较少
		 *     MEDIUM:信息量中等  通常使用这项
		 *     LONG:信息量多
		 */
		DateFormat df1 
					= DateFormat
					.getDateInstance(DateFormat.MEDIUM,Locale.JAPAN);
		//将日期对象转换为字符串  此方法一定记住
		//通过dateformat对象调用format方法 将日期对象转换为字符串
		//将long类型的对象转换为String类型 怎么做？
		
		String str = df1.format(now);
		System.out.println(str);
		long a = System.currentTimeMillis();
		//将date类型转换为字符串类型  
		/*
		 * 现在有一个long类型   将long类型转换为date  date--》string
		 * 不管将来给你什么类型（关于时间的）让你转换为string那么
		 * 你就的想方设法的将那个类型转换为date
		 */
	}
}










