package com.a;

public class Test {
	public static void main(String[] args) {
		// ������˾����
		Company com = new Company("IBM");
		Company com1 = new Company("DELL");

		// ����Ա������
		Member member1 = new Member("����", 30);
		Member member2 = new Member("����", 40);
		Member member3 = new Member("����", 50);

		// ����Ա���Ĺ�˾
		member1.setCompany(com);
		member2.setCompany(com1);
		//member3.setSchool(com);
		// ��ӡԱ�����������䣬���ڹ�˾
		System.out.println(member1);
		System.out.println(member2);

	}
}
