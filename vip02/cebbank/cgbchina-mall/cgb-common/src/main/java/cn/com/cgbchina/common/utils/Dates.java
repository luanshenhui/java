package cn.com.cgbchina.common.utils;

import org.joda.time.DateTime;

import java.util.Date;

/**
 * Created by 11140721050130 on 2016/5/16.
 */
public class Dates {

	public static Date startOfDay(Date date) {
		if (date == null)
			return null;
		return new DateTime(date).withTimeAtStartOfDay().toDate();
	}

	public static Date endOfDay(Date date) {
		if (date == null)
			return null;
		return new DateTime(date).withTimeAtStartOfDay().plusDays(1).toDate();
	}
}
