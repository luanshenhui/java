package com.c;

import java.util.List;

public class T {

	public static void method(List<Member> list,MemberFilter filter) {
		
		for(Member m:list){
			if(filter.method(m)){
		//	if(m.getAge()>30&&m.getName().charAt(index)){
		System.out.println(m);
		}
		}
		

	}

}
