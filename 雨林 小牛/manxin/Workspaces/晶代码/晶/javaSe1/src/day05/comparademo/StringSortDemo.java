package day05.comparademo;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/**
 * 排序字符串
 * @author Administrator
 *
 */
public class StringSortDemo {
	public static void main(String[] args) {
		List<String> list = new ArrayList<String>();
		list.add("mary");
		list.add("Killer");
		list.add("able");
		list.add("big");
		list.add("Allen");
		list.add("Xiloer");
		list.add("Kate");
		/**
		 * 字符串实现了Comparable接口
		 * 所以字符串本身是具备可比较的
		 */
		Collections.sort(list);
		System.out.println(list);
		
		/**
		 * 需求:按照字符串的长短来排序
		 * 字符串的比较规则不能满足这个排序需求时，我们可以
		 * 额外的定义比较规则来满足该排序的需求
		 */
		Comparator<String> comparator = 
			new Comparator<String>(){
				public int compare(String o1, String o2) {					
					return o1.length() - o2.length();
				}		
		};
		
		Collections.sort(list, comparator);
		System.out.println(list);
		
	}
}





