package com.yulin.am;
import java.util.*;

public class SetDemo {

	/**
	 * Set����
	 */
	public static void main(String[] args) {
		Set<String> set = new HashSet<String>();
		set.add("A");
		set.add("B");
		set.add("C");
		set.add("D");
		for(String s : set){
			System.out.println(s);
		}
		
		Set<SetDemo> set1 = new HashSet<SetDemo>();
		set1.add(new SetDemo());
		set1.add(new SetDemo());
		set1.add(new SetDemo());
		set1.add(new SetDemo());
		for(SetDemo sd : set1){
			System.out.println(sd);
		}
/*		Iterator<SetDemo> it = set1.iterator();	//��ü��ϵĵ�����
		while(it.hasNext()){	//�жϵ��������Ƿ�������
			SetDemo sd = it.next();	//ȡ��һ������
			System.out.println(sd);
		}*/
		Iterator<SetDemo> it = set1.iterator();
		while(it.hasNext()){
			System.out.println(it.next());
		}
	}

}
