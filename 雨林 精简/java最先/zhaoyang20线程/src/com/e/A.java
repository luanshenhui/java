package com.e;

public class A {
	public static void main(String[] args) {
		Department department =new Department("������");
		
		Member member=new Member("����",5000);
		
		member.setDepartment(department);
		
		System.out.println(member);
	}

}
