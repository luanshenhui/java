package day05;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * 集合迭代器的使用
 * @author Administrator
 *
 */
public class IteratorDemo {
	public static void main(String[] args) {
		List list = new ArrayList();
		list.add("one");
		list.add("#");
		list.add("two");
		list.add("#");
		list.add("three");
		list.add("#");
		/**
		 * java.util.Iterator
		 * 迭代器是专门为while循环设计的
		 */
		Iterator it = list.iterator();
		while(it.hasNext()){
			/**
			 * next方法获取集合中下一个元素
			 * 与get方法一样，存放的时候以Object存的
			 * 取的时候也是以Object返回的，所以要造型
			 */
			String element = (String)it.next();
			/**
			 * 使用迭代器在遍历集合元素过程中是可以删除
			 * 集合中的元素的，使用的是迭代器的remove方法
			 * 删除集合中所有#
			 */
			if("#".equals(element)){
				//将上面通过next方法获取的元素从集合中删除
				it.remove();
				/**
				 * 迭代器在迭代过程中，不能通过使用集合定义的
				 * 删除方法去删除集合元素，一定要使用迭代器的
				 * 删除方法，否则迭代过程中会产生异常！
				 */
//				list.remove(element);
			}
			
			
			System.out.println(element);
		}
		
		System.out.println(list);
	}
}

















