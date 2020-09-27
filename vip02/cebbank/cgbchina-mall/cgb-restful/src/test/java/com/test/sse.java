package com.test;

import java.util.GregorianCalendar;

public class sse {
	public static String getDays() {
		long baseDate = new GregorianCalendar(2000, 1, 1, 0, 0, 0).getTime().getTime();
		long now = new GregorianCalendar().getTime().getTime();
		long interval = (long) ((now - baseDate) / 1000. / 3600. / 24.);
		String curDate = Long.toString(interval);
		// edit by dengzaiyong on 2009-08-12
		// 超过5位取后四位
		if (curDate.length() > 4) {
			curDate = curDate.substring(curDate.length() - 4, curDate.length() - 1);
		}

		// for (; curDate.length() < 5; curDate = '0' + curDate);
		return curDate;
	}

	public static void main(String[] args) {
		System.out.println(getDays());
	}
}
