package com.a;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class C {
	//������ʵ����
	public static void m()throws NullPointerException{
		System.out.println("����");
			//�׳���ָ���쳣
		//throw new NullPointerException();//=�к��ߣ�����û����//û����Ĵ���//�Լ�����쳣
		//throw new Ǯ����//�Լ������쳣==���߱���
		
	}
	
	public static void m1() throws ParseException{
		//Date date=new Date();
		String str="2014-10-10";
		SimpleDateFormat s=new SimpleDateFormat("yyyy-MM-dd");
		//String str=s.format(date);
		Date date=s.parse(str);
	}

	
	public static void main(String[] args) {
		//����������
		try{
		m();
		}catch(NullPointerException e){
			System.out.println("���쳣");
			
		}
		
		
		try {
			m1();
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
