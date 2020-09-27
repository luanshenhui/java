package day04;

import java.util.ArrayList;
import java.util.List;

import day01.Point;

/**
 * List方法的get与set方法
 * 
 * @author Administrator
 *
 */
public class ListDemo5 {
	public static void main(String[] args) {
		List list = new ArrayList();
		list.add("one");
		list.add("two");
		list.add("three");
		
		for(int i = 0;i<list.size();i++){
			String str =(String)list.get(i);
			System.out.println(str);
		}
		/**
		 * set方法用于替换集合中指定位置上的元素
		 * set方法的返回值为被替换的元素
		 * 
		 * set方法指定的索引位置不能大于数组的元素数量
		 * 否则会出现下标越界异常
		 */
		Object old = list.set(2, "二");
		System.out.println(list);
		System.out.println("被替换的元素:"+old);
	}
}




