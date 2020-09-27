package com.b;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;

public class B {

	
	public static void main(String[] args) {
	//Map接口：存储结构是键值对(key——>value)
		//SortedMap接口：..................对key排序。TreeMap实现类
		
		Map<Integer,String> map=new HashMap<Integer,String>();//创建集合的代码
		
		map.put(101, "张三");//添加(注意，key不能重复必须唯一)
		map.put(102, "李四");
		map.put(103, "王五");
		//System.out.println(map);
		
//		//3(修改)
//		map.put(101,"赵六");
//		System.out.println(map);
		
//		//4(删除)
//		map.remove(101);
//		System.out.println(map);
		
		//5(注意：查找效率最高)
		String name=map.get(102);
		System.out.println(name);
		
		//6(遍历)方法1：
		//获取key的集合
		Set<Integer> set0=map.keySet();
		for(int key:set0){
			String ma=map.get(key);
			System.out.println(ma);
			//System.out.println(key);
		}
		//根据Entry实体对象获得Set集合(泛型类)
		Set<Entry<Integer,String>> set=map.entrySet();
		for(Entry<Integer,String> e:set){
			int key=e.getKey();
			String value=e.getValue();
			System.out.println(key+"-"+value);
		}
		
		//使用迭代器遍历
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
