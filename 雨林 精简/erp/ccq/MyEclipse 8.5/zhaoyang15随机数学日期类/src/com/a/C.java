package com.a;

import java.text.SimpleDateFormat;
import java.util.Date;

public class C {
	public static void main(String[] args) {
		//Date�ı��ʣ��洢���Ǿ���һ����ʷ(1970.0.0.0.0�ĺ�����)
		Date date=new Date();
		long time =date.getTime();
		System.out.println("Date�洢���Ǻ�����"+time);
		
		//����date�洢���Ǻ�������������ʵ�ʿ�������Ҫ���ڼ�������Ǵ洢
		//����100���Ժ��Ǽ��ţ��������
		
		Date d=new Date();
		d.setTime(date.getTime()+100*24*60*60*1000L);
		SimpleDateFormat s=new SimpleDateFormat("yyyy��MM��dd��");
		System.out.println(s.format(d));
		//System.out.println(d.setTime(date.getTime()+100*24*60*60*1000L));
		//��ϰ��2014��12.19��2015��2.18�ж�����
		
		
		
		
	}
}
