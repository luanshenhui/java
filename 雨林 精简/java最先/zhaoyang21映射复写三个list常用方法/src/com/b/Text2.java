package com.b;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Vector;

public class Text2 {
	public static void main(String[] args) {
		//List<Member> list = new ArrayList<Member>();
		//ArrayList,LinkedList,Vector
		//HashSet,LinkedHashSet,TreeSet
		//LinkedList实现类
		LinkedList<Member>list=new LinkedList<Member>();//优势，添加删除快，效率高
		//链表头添加
		list.addFirst(new Member("张三",30));
		list.addLast(new Member("李四",40));
		System.out.println(list);
		
		//Vector实现类，线程安全
		List<Member>list2=new Vector<Member>();
		
		
		
	}

}
