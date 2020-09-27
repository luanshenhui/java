package day05;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import day01.Point;

/**
 * 集合对泛型的支持
 * @author Administrator
 *
 */
public class ListDemo {
	public static void main(String[] args) {
		/**
		 * 集合中的泛型指定的是存放的元素是什么类型的。
		 */
		List<String> list = new ArrayList<String>();
		list.add("123");
		list.add("456");
		list.add("789");
//		list.add(123);//参数类型不匹配！
		
		for(int i =0;i<list.size();i++){
			/**
			 * get方法获取元素时直接是泛型指定的类型
			 * 无需再进行造型了
			 */
			String element = list.get(i);
			System.out.println(element);
		}
		/**
		 * 迭代器也支持泛型
		 * 但要注意！迭代器指定的泛型类型一定要和
		 * 遍历的集合的泛型类型一致！
		 */
		Iterator<String> it = list.iterator();
		while(it.hasNext()){
			/**
			 * 使用迭代器获取元素时也不再需要造型
			 */
			String element = it.next();
			System.out.println(element);
		}
		
		List<Point> list2 = new ArrayList<Point>();
		list2.add(new Point(1,2));
//		list2.add("123");
	}
}







