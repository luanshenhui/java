package com.yulin.am;
import java.util.*;
import java.util.Map.Entry;

public class MapDemo {

	/**
	 * Map����
	 */
	public static void main(String[] args) {
		Map<String,String> map = new HashMap<String,String>();
		map.put("001", "Jack");
		map.put("002", "Rose");
		map.put("003", "Bond");
		map.put("004", "Bruce");
		map.put("005", "Tom");
		map.put("005", "Jim");	//��֤�����ԣ���һ���Ḳ��ǰһ��
		/**
		 * ����Map���ϵĲ���
		 * 1.ȡ��Entry��Set����
		 * 2.�������Set����
		 * 3.��Entry�ֱ�ȡ��Key��Value
		 */
		Set<Entry<String,String>> set = map.entrySet();
		/**
		 * 1.��forEach����
		 * 2.��Iterator����
		 */
		System.out.println("forEach������");
		for(Entry<String, String> e : set){
			System.out.println(e);
			System.out.println("Key:" + e.getKey());
			System.out.println("Value:" + e.getValue());
		}
		System.out.println("******************************");
		System.out.println("������Iterator������");
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
