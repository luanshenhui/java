package com.txt;

public class C {
	public static void main(String[] args) {
		Emp emp=new Emp("����",5000,100);
		
		Men men=new Men("����",4000);
		
		Com com=new Com("��������");
		
		com.add(emp);
		com.add(men);
		
		double salary=com.getAllSalary();//���ܹ�����
		System.out.println(salary);
	}

}
