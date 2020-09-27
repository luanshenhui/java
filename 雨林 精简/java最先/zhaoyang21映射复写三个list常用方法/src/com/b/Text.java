package com.b;

import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

public class Text {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		Set<Member> set=new HashSet<Member>();
		
		set.add(new Member("张三",30));
		set.add(new Member("李四",40));
		set.add(new Member("张三",30));

		PrintAll(set);
	}

	private static void PrintAll(Set<Member> set) {
		for(Member m:set){
			System.out.println(m);
		}
		
//		Iterator <Member>iter=set.iterator();
//		while(iter.hasNext()){
//			Member s= iter.next();
//			System.out.println(s);
//			
//		}
		
	}

}
