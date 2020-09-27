package com.am;

import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.ArrayList;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;

public class A {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		/*
		 * 数组：可以存储基本数据类型和类类型，必须要指定长度
		 * 0
		 * java集合“框架”：6个接口和1个工具类
		 * 
		 * Collection接口：集合的顶级接口，定义了集合的基本方法
		 *        ->List
		 *        ->Set
		 *            ->SortedSet//都是接口，全是继成
		 * list接口：有序(添加和便利的顺序有序)--开发中主要用于便利,实现类例如：ArrList等
		 * Set接口：不重复，不一定有序，例如HashSet等
		 * SortedSet接口：不重复，而且排序.实现类TreeSet等
		 
		 * Map接口：存储结构是键值对(key value)SortedMap接口：(也是key value)但是对key排序 
		 * Collections类 ：集合的工具类
		 * 
		 * 
		 * List集合接口：有序 List list=new ArrayList();
		 */
		// List <String>list=new ArrayList<String>();
		SortedSet<String> list = new TreeSet<String>();
		// 1,会创建集合(建议使用集合时使用“泛型”来指定集合元素中存储的类型，java会在编译期检查)
		// 在接口List和实现的方法ArrayList后加<指定类型>
		list.add("a");// 2会添加元素
		list.add("b");
		list.add("c");
		list.add("b");
		list.add("e");
		list.add("7");
		

		System.out.println(list);
		/*
		 * //3删除元素 List一般不用与删除，因为效率低
		 *  list.remove("b");
		 *   System.out.println(list);
		 * //4修改元素 同上 list.set(0,"aaa");
		 *  System.out.println(list);
		 */

		// 便利的三种方法
		/*
		 * 1，基于ArrayList原理的遍历方法 size();方法表示集合种元素的个数
		 */
		// for(int i=0;i<list.size();i++){
		// //get(i)方法根据下标获取元素
		// String str=list.get(i);
		// System.out.println(list.get(i));
		// }
		// 第2种遍历方法
		// for(String s:list){
		// System.out.println(s);
		// }
		// 第3种遍历方法：(最重要，做通用!!!)迭代器
		Iterator<String> iterator = list.iterator();
		while (iterator.hasNext()) {// has.next找迭代器中是否有下一个元素
			String str = iterator.next();// next()取出对应的元素
			System.out.println(str);
		}
		
		
		
		
	}

}
