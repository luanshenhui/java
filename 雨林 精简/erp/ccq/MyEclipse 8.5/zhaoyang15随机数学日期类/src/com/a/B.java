package com.a;
import java.util.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;;
public class B {
	public static void main(String[] args) {
		//1������ǰ���ڶ���
		Date date= new Date();
		System.err.println(date);
		
		//2��dateת����ָ����ʽ���ַ���String
		
		//Date��ʾ���ڵ���
		//SimpleDateFormat��ʵ��date��String���໥ת��
		SimpleDateFormat format=new SimpleDateFormat("hhʱmm��ss��dd��yyyy��MM��dd��");
		//SimpleDateFormat format=new SimpleDateFormat("yyyy��MM��dd��hhʱmm��ss��");
		//date>string
		System.out.println(format.format(date));
		
		//String >Date
		String s="12192014 11��08��";
		SimpleDateFormat f=new SimpleDateFormat("MMddyyyy hh��mm��");
		try {
			System.out.println(f.parse(s));
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
}
