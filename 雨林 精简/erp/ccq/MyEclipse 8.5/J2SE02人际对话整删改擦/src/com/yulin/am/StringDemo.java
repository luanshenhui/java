package com.yulin.am;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.Scanner;

public class StringDemo {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		System.out.println("请输入你");
		String[]emps=new String[0]; 
		Scanner sc=new Scanner(System.in);
		while(2>1){
		System.out.println("请输入你的操作");
		System.out.println("1的操作2擦训3突出");
		int in=sc.nextInt();
		Date date = new Date();
		if(in==1){
			System.out.println("情操组");
			String name =sc.next();
			String timeFomat1="yyyy-星期 day hh:mm:ss";
			SimpleDateFormat sos=new SimpleDateFormat(timeFomat1);
			String time=sos.format(date);//将时间转化承字符
			emps=Arrays.copyOf(emps,emps.length+1);//扩容
			emps[emps.length-1]=name+"@"+time;//拼接保存
			System.out.println("保存成功");
			System.out.println(name+"@"+time);
		}else if(in==2){
			for(String s :emps){//foreach循环
				String[]ss=s.split("@");
				System.out.println("员工姓名"+ss[0]);
				System.out.println("如只是间"+ss[1]);
				System.out.println("-----------------");
				
			}
		}else if(in==3){
			System.out.println("hangying下次使用");
			System.exit(0);
			
		}
		
		}
	}

}
