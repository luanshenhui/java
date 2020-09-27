package com.c;

import java.util.ArrayList;
import java.util.List;

public class Main {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Member m1=new Member("张三",30);
		Member m2=new Member("李四",40);
		Member m3=new Member("王五",50);
		Member m4=new Member("赵六",60);
		
		List<Member>list=new ArrayList<Member>();
		
		list.add(m1);
		list.add(m2);
		list.add(m3);
		list.add(m4);
		
		T.method(list,new MemberFilter(){

			@Override
			public boolean method(Member m) {
				// TODO Auto-generated method stub
				return m.getAge()>=30;
				//return m.getName().startsWith("李");
			}
		//输出40岁以上员工信息
		});

	}

	
}
