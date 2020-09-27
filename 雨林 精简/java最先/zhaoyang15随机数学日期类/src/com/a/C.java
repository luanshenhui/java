package com.a;

import java.text.SimpleDateFormat;
import java.util.Date;

public class C {
	public static void main(String[] args) {
		//Date的本质；存储的是距离一个历史(1970.0.0.0.0的毫秒数)
		Date date=new Date();
		long time =date.getTime();
		System.out.println("Date存储是是毫秒数"+time);
		
		//由于date存储的是毫秒数，所以在实际开发中主要用于计算而不是存储
		//计算100天以后是几号，何年何月
		
		Date d=new Date();
		d.setTime(date.getTime()+100*24*60*60*1000L);
		SimpleDateFormat s=new SimpleDateFormat("yyyy年MM月dd日");
		System.out.println(s.format(d));
		//System.out.println(d.setTime(date.getTime()+100*24*60*60*1000L));
		//练习，2014，12.19到2015，2.18有多少天
		
		
		
		
	}
}
