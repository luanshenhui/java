package com.a;

public class Test {
	public static void main(String[] args) {
		// 创建公司对象
		Company com = new Company("IBM");
		Company com1 = new Company("DELL");

		// 创建员工对象
		Member member1 = new Member("张三", 30);
		Member member2 = new Member("李四", 40);
		Member member3 = new Member("王五", 50);

		// 设置员工的公司
		member1.setCompany(com);
		member2.setCompany(com1);
		//member3.setSchool(com);
		// 打印员工姓名，年龄，所在公司
		System.out.println(member1);
		System.out.println(member2);

	}
}
