package com.a;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class C {
	//方法的实现者
	public static void m()throws NullPointerException{
		System.out.println("方法");
			//抛出空指针异常
		//throw new NullPointerException();//=有红线，就是没处理//没处理的错误//自己起的异常
		//throw new 钱不足//自己做的异常==红线报错；
		
	}
	
	public static void m1() throws ParseException{
		//Date date=new Date();
		String str="2014-10-10";
		SimpleDateFormat s=new SimpleDateFormat("yyyy-MM-dd");
		//String str=s.format(date);
		Date date=s.parse(str);
	}

	
	public static void main(String[] args) {
		//方法调用者
		try{
		m();
		}catch(NullPointerException e){
			System.out.println("有异常");
			
		}
		
		
		try {
			m1();
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
