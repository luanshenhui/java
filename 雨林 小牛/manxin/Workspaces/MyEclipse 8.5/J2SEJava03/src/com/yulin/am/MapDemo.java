package com.yulin.am;
import java.util.*;
import java.util.Map.Entry;

public class MapDemo {

	/**
	 * Map迭代
	 */
	public static void main(String[] args) {
		Map<String,String> map = new HashMap<String,String>();
		map.put("001", "Jack");
		map.put("002", "Rose");
		map.put("003", "Bond");
		map.put("004", "Bruce");
		map.put("005", "Tom");
		map.put("005", "Jim");	//验证无序性，后一个会覆盖前一个
		/**
		 * 迭代Map集合的步骤
		 * 1.取出Entry的Set集合
		 * 2.迭代这个Set集合
		 * 3.从Entry分别取出Key和Value
		 */
		Set<Entry<String,String>> set = map.entrySet();
		/**
		 * 1.用forEach迭代
		 * 2.用Iterator迭代
		 */
		System.out.println("forEach迭代：");
		for(Entry<String, String> e : set){
			System.out.println(e);
			System.out.println("Key:" + e.getKey());
			System.out.println("Value:" + e.getValue());
		}
		System.out.println("******************************");
		System.out.println("迭代器Iterator迭代：");
		Iterator it = set.iterator();
		while(it.hasNext()){
			System.out.println(it.next());
		}
		Iterator<Entry<String,String>> it1 = set.iterator();
		while(it1.hasNext()){
			Entry<String, String> e;
			System.out.println(it1.next());
			
		}
	}

}
