package com.b;

public class Clert {
	public static void main(String[] args) {
		A a1=new A("张三",3000);
		A a2=new A("李四",4000);
		
		//(姓名,课时,课时费)
		B b1=new B("王五",100,50);
		B b2=new B("赵六",90,40);
		
		S s=new S("北京大学");
		//添加4个员工
		s.add(a1);
		s.add(a2);
		s.add(b1);
		s.add(b2);
		//计算4个员工总工资
		double sum=s.getSumSalary();
		System.out.println(sum);
	
	}
}
