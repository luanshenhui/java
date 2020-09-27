package day04;

import java.util.ArrayList;
import java.util.List;

import day01.Point;

/**
 * List集合演示
 * @author Administrator
 *
 */
public class ListDemo2 {
	public static void main(String[] args) {
		List list = new ArrayList();
		Point point = new Point(1,2);
		list.add(point);
		list.add(point);
		list.add(new Point(3,4));
		list.add(new Point(5,6));
		
		System.out.println(list);
		//单独创建一个对象
		Point p = new Point(1,2);
		/**
		 * 元素的equals方法对集合的很多操作都有影响！
		 * 判断集合是否包含给定的元素时，集合会将这个元素
		 * 与集合中的元素分别进行equals比较，若有返回值为
		 * true的，则认为集合包含给定的元素。
		 */
		System.out.println(point == p);//false 不是同一个对象
		System.out.println(point.equals(p));//内容相同
		System.out.println("p在集合中么："+ list.contains(p));
		/**
		 * remove方法是将给定的元素与集合中每个元素进行
		 * equals比较，删除第一个比较结果为true的元素。
		 * 
		 */
		list.remove(p);
		System.out.println(list);
		
	}

}




