package com.yulin.am;

public class Test {
	public static void main(String[] args) {
		Member member=new Member();
		member.setName("����");
		System.out.println(member.getName());//�̳ɵ�������Ҫ���÷����õ�����
		//System.out.println(member.name);//�����֡���˽�в��ɼ����̳ɺͿɼ���û��ϵ
		
		Member member2=new Member("����");
		System.out.println(member2.getName());
	}

}
