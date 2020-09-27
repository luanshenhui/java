package com.txt;

public class C {
	public static void main(String[] args) {
		Emp emp=new Emp("张三",5000,100);
		
		Men men=new Men("李四",4000);
		
		Com com=new Com("大连华新");
		
		com.add(emp);
		com.add(men);
		
		double salary=com.getAllSalary();//求总工资数
		System.out.println(salary);
	}

}
