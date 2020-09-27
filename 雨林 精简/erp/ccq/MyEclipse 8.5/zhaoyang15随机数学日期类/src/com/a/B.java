package com.a;
import java.util.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;;
public class B {
	public static void main(String[] args) {
		//1创建当前日期对象
		Date date= new Date();
		System.err.println(date);
		
		//2将date转换成指定格式的字符串String
		
		//Date表示日期的类
		//SimpleDateFormat能实现date和String的相互转换
		SimpleDateFormat format=new SimpleDateFormat("hh时mm分ss秒dd日yyyy年MM月dd日");
		//SimpleDateFormat format=new SimpleDateFormat("yyyy年MM月dd日hh时mm分ss秒");
		//date>string
		System.out.println(format.format(date));
		
		//String >Date
		String s="12192014 11点08分";
		SimpleDateFormat f=new SimpleDateFormat("MMddyyyy hh点mm分");
		try {
			System.out.println(f.parse(s));
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
}
