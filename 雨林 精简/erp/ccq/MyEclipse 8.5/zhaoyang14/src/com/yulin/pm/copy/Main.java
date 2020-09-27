package com.yulin.pm.copy;

import com.yulin.pu.Member;
import com.yulin.pu.Student;



public class Main {

	public static void main(String[] args) {
		 
		
		Student stu=new Student("ÕÅÈı",20);
		stu.print();

		Member member =new Member("Andy",30,3000);
		member.print();
		
		MyUtil.write(stu);
		MyUtil.write(member);

	}
}
