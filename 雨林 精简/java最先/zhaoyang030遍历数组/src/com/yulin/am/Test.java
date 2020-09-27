package com.yulin.am;

public class Test {
	public static void main(String[] args) {
		Member member=new Member();
		member.setName("张三");
		System.out.println(member.getName());//继成的有名字要用用方法得到名字
		//System.out.println(member.name);//有名字。但私有不可见，继成和可见性没关系
		
		Member member2=new Member("李四");
		System.out.println(member2.getName());
	}

}
