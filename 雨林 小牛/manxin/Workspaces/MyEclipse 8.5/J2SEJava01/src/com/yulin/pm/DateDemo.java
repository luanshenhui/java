package com.yulin.pm;

import java.text.SimpleDateFormat;
import java.util.Date;
public class DateDemo {

	/**
	 * ʱ�亯��(API)
	 */
	public static void main(String[] args) {
		Date date = new Date();
		System.out.println("��ǰ��ϵͳʱ��:" + date);
		
		//ʱ��ĸ�ʽ����׼
		/**
		 * YYYY����
		 * MM����
		 * dd����
		 * day������
		 * hh��ʱ
		 * mm����
		 * ss����
		 */
		String timeFomat = "yyyy-MM-dd E hh:mm:ss";
		SimpleDateFormat sdf = new SimpleDateFormat(timeFomat);
		String time = sdf.format(date);
		System.out.println("��ǰʱ��:" + time);
		

	}

}
