package com.b;

public class Clert {
	public static void main(String[] args) {
		A a1=new A("����",3000);
		A a2=new A("����",4000);
		
		//(����,��ʱ,��ʱ��)
		B b1=new B("����",100,50);
		B b2=new B("����",90,40);
		
		S s=new S("������ѧ");
		//���4��Ա��
		s.add(a1);
		s.add(a2);
		s.add(b1);
		s.add(b2);
		//����4��Ա���ܹ���
		double sum=s.getSumSalary();
		System.out.println(sum);
	
	}
}
