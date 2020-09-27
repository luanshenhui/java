package com.a;

public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		Member m3 = new Member("王五", 5000);
		Member m1 = new Member("张三", 3000);
		Member m2 = new Member("李四", 4000);

		Member[] arr = { m1, m2, m3 };

		double avg = Company.avg(arr);
		System.out.println(avg);

		Company com = new Company();
		Member member = com.maxSalary(arr);
		System.out.println(member);
	}

}
