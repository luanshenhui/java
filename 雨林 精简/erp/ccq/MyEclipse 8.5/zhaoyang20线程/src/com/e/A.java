package com.e;

public class A {
	public static void main(String[] args) {
		Department department =new Department("开发部");
		
		Member member=new Member("张三",5000);
		
		member.setDepartment(department);
		
		System.out.println(member);
	}

}
