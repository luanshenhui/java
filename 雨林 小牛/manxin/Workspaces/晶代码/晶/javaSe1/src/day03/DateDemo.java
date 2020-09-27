package day03;

import java.util.Date;

/**
 * java.util.Date  用于描述日期和时间的类
 * @author Administrator
 *
 */
public class DateDemo {
	public static void main(String[] args) {
		//创建一个用于描述当前系统时间的Date对象
		Date date = new Date();
		System.out.println(date);
		
		long now = date.getTime();//获取毫秒值
		System.out.println(now);
		
		now += 1000 * 60 * 60 * 24;
		//设定一个毫秒值，使date对象表示这个时间点
		date.setTime(now);
		System.out.println(date);
	}
}






