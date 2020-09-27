package com.a;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		String s1 = "20141219";
		String s2 = "20141208";

		boolean boo = Main.m1(s1, s2);
		System.out.println(boo);

	}

	private static boolean m1(String s1, String s2) {

		SimpleDateFormat f = new SimpleDateFormat("yyyyMMdd");
		SimpleDateFormat f2 = new SimpleDateFormat("yyyyMMdd");

		Date d = new Date();
		Date d1 = new Date();
		System.out.println(d);

		try {
			d = f.parse(s1);
			d1 = f2.parse(s2);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
//		if (d1.getTime() > d.getTime()) {
//			return true;
//		}
	if(d1.after(d)){
		return true;
	}

		return false;
	}

}
