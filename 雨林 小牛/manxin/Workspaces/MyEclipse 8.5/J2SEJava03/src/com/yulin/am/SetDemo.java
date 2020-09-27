package com.yulin.am;
import java.util.*;

public class SetDemo {

	/**
	 * Set集合
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
/*		Iterator<SetDemo> it = set1.iterator();	//获得集合的迭代器
		while(it.hasNext()){	//判断迭代器中是否还有数据
			SetDemo sd = it.next();	//取出一个数据
			System.out.println(sd);
		}*/
		Iterator<SetDemo> it = set1.iterator();
		while(it.hasNext()){
			System.out.println(it.next());
		}
	}

}
