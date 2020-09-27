package com.yulin.pm;
import java.util.*;
import java.text.*;

public class DateDemo2 {

	/**
	 * SimpleDateFormat:
	 * 练习：员工信息录入系统：
	 * ********欢迎使用员工信息录入系统********
	 * 1.录入员工信息
	 * 		--->请输入员工姓名
	 * 			------->Monty
	 * 2.查询所有员工的入职信息
	 * 		--->姓名：Monty
	 * 			入职时间：2014-11-03  :： 17:21入职
	 * 3.退出系统
	 * 
	 * 将信息用StringBuffer拼接后保存至字符串数组
	 */
	public static void main(String[] args) {
		DateDemo2 dd2 = new DateDemo2();
		dd2.show();
	}

	
	public void show(){
		System.out.println("**********欢迎试用员工信息录入系统***********");
		Scanner scan = new Scanner(System.in);
		String[] emps = new String[0];
		String timeFomat = "yyyy-MM-dd E";	//自定义的时间格式
		SimpleDateFormat sdf = new SimpleDateFormat(timeFomat);	//创建工具类对象
		Date date = new Date();
		while(true){
			System.out.println("请选择您所要的操作：");
			System.out.println("1.录入员工信息");
			System.out.println("2.查询所有员工信息");
			System.out.println("3.退出系统");
			int in = scan.nextInt();
			if(in == 1){
				System.out.println("请输入 员工姓名:");
				String name = scan.next();
				String time = sdf.format(date);	//将时间转化成字符串
				emps = Arrays.copyOf(emps, emps.length + 1);	//扩容
				emps[emps.length - 1] = name + "@" + time;	//拼接保存
				System.out.println("保存成功！");
			}else if(in == 2){
				for(String s : emps){	//forEach循环
					String[] ss = s.split("@");
					System.out.println("员工姓名:" + ss[0]);
					System.out.println("入职时间" + ss[1]);
					String time1 = ss[1].toString();
	//				String time2 = time2.compareTo(time1);
					System.out.println("********************************");
					System.out.println("******************");
				}
			}else if(in == 3){
				System.err.println("***************退出系统***************");
				System.err.println("欢迎下次使用");
				System.exit(0);
			}
		}
	}	
}
