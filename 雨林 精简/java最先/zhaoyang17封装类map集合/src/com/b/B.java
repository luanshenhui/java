package com.b;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;

public class B {

	
	public static void main(String[] args) {
	//Map�ӿڣ��洢�ṹ�Ǽ�ֵ��(key����>value)
		//SortedMap�ӿڣ�..................��key����TreeMapʵ����
		
		Map<Integer,String> map=new HashMap<Integer,String>();//�������ϵĴ���
		
		map.put(101, "����");//���(ע�⣬key�����ظ�����Ψһ)
		map.put(102, "����");
		map.put(103, "����");
		//System.out.println(map);
		
//		//3(�޸�)
//		map.put(101,"����");
//		System.out.println(map);
		
//		//4(ɾ��)
//		map.remove(101);
//		System.out.println(map);
		
		//5(ע�⣺����Ч�����)
		String name=map.get(102);
		System.out.println(name);
		
		//6(����)����1��
		//��ȡkey�ļ���
		Set<Integer> set0=map.keySet();
		for(int key:set0){
			String ma=map.get(key);
			System.out.println(ma);
			//System.out.println(key);
		}
		//����Entryʵ�������Set����(������)
		Set<Entry<Integer,String>> set=map.entrySet();
		for(Entry<Integer,String> e:set){
			int key=e.getKey();
			String value=e.getValue();
			System.out.println(key+"-"+value);
		}
		
		//ʹ�õ���������
		Set<Entry<Integer,String>> set1=map.entrySet();
		Iterator<Entry<Integer,String>> iter=set1.iterator();
		while(iter.hasNext()){
			Entry<Integer,String> ss=iter.next();
//			int a=ss.getKey();
//			String bb=ss.getValue();
			System.out.println(ss);
			
		
		}
	
		
	}

}
