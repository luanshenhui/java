package day03;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 用于将字符串与Date相互转换的类
 * java.text.SimpleDateFormat
 * @author Administrator
 *
 */
public class SimpleDateFormatDemo {
	public static void main(String[] args) throws ParseException {
		/**
		 * 创建SimpleDateFormat实例时，我们需要传入一个
		 * 字符串，这个字符串是用来描述转换的格式的。
		 * 
		 * SimpleDateFormat在对Date与String进行相互转换时是依赖
		 * 于一个格式字符串的。
		 * 日期格式字符串语法:
		 * y : 年     yyyy四位数字的年    yy两位数字的年
		 * M : 月     MM两位数字的月       M:一位数字的月(不用)
		 * d : 日     dd两位数字的日
		 * 
		 * h : 小时  12小时制    hh两位数字的小时
		 * H : 小时  24小时制  
		 * m : 分    
		 * s : 秒
		 * 
		 * a : 上/下午
		 * E : 星期
		 * 
		 * 在日期格式字符串中，没有特殊意义的字符就按照原意输出
		 */
		long a = System.currentTimeMillis();
		DateFormat format = 
			new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		//java.util.Date
		Date now = new Date();//当前系统时间
		
		//将Date转换为字符串
		String nowStr = format.format(now);
		
		System.out.println(nowStr);
		
		//定义一个日期字符串
		String dateStr = "09-20-1999 13:29:30";
		SimpleDateFormat format2 = 
			new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		
		/**
		 * 将字符串以日期格式字符串的要求进行解析，转换为
		 * 对应的Date对象
		 * 将字符串类型转换为date类型
		 */
		Date date = format2.parse(dateStr);
		System.out.println(date);
	}
}









