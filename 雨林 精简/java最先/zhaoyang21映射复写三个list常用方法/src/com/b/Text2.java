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
		//LinkedListʵ����
		LinkedList<Member>list=new LinkedList<Member>();//���ƣ����ɾ���죬Ч�ʸ�
		//����ͷ���
		list.addFirst(new Member("����",30));
		list.addLast(new Member("����",40));
		System.out.println(list);
		
		//Vectorʵ���࣬�̰߳�ȫ
		List<Member>list2=new Vector<Member>();
		
		
		
	}

}
