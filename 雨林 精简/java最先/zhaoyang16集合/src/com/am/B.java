package com.am;

import java.util.ArrayList;
import java.util.List;

public class B {

	
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		List<Person>list=new ArrayList<Person>();
		list.add(new Person("����",30));
		list.add(new Person("����",40));
		list.add(new Person("����",50));
		
		printAll(list);

	}

	private static void printAll(List<Person> list) {
		// TODO Auto-generated method stub
		System.out.println(list);
		
	}

}
