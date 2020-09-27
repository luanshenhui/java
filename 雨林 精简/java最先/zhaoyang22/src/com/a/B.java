package com.a;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class B {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Person p1=new Person("abc",30);
		Person p2=new Person("aac",80);
		Person p3=new Person("aca",70);
			
		List<Person>list=new ArrayList<Person>();
		
		list.add(p1);
		list.add(p2);
		list.add(p3);
		
//		Collections.sort(list,new Comparator() {
//
//			@Override
//			public int compare(Object o1, Object o2) {
//				// TODO Auto-generated method stub
//				Person p1=(Person)o1;
//				Person p2=(Person)o2;
//				return p1.getName().compareTo(p2.getName());
//			}
//		});
		
		//Collections.sort(list);
		for(Person p:list){
			System.out.println(p);
		}
	}

}
