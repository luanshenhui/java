package com.c;

public class Main {
	public static void main(String[] args) {
		Person per3=new Person("张三",30);
		Person per1=new Person("张三",30);
		Person per2=new Person("李四",40);
		
		boolean boo= per1.equals(per2);
		System.out.println(boo);
	}

}
