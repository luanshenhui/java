package com.a;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class D {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String s="2015 02 18";
		SimpleDateFormat a=new SimpleDateFormat("yyyy MM dd");
		Date date=new Date();
		Date now=new Date();
		try {
			 date=a.parse(s);
			System.out.println (a.parse(s));
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		date.getTime();
		System.out.println(date.getTime());
		System.out.println(now.getTime());
		
		System.out.println((date.getTime()-now.getTime())/60/60/24/1000);

	}

}
