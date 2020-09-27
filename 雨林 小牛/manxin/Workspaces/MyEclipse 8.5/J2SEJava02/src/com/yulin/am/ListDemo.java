package com.yulin.am;
import java.util.*;

public class ListDemo {

	/**
	 * ArrayList集合
	 */
	public static void main(String[] args) {
		ArrayList list = new ArrayList();
		list.add(100);	//增加数据
		list.add(true);
		list.add(2.2);
		list.add("Hello");
		list.add(new ListDemo());
		
		for(int i = 0; i < list.size(); i++){
			System.out.println(list.get(i));
		}
		
		for(Object o : list){
			System.out.println(o);
		}
		
		ArrayList<String> list1 = new ArrayList<String>();
		list1.add("Hello");
		list1.add("Word");
		
		for(String s : list1){
			System.out.println(s);
		}
	}

}
