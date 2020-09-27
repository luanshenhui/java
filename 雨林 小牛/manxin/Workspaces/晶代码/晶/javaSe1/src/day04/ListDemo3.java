  package day04;

import java.util.ArrayList;
import java.util.List;

/**
 * List集合演示
 * @author Administrator
 *
 */
public class ListDemo3 {
	public static void main(String[] args) {
		List list1 = new ArrayList();
		List list2 = new ArrayList();
		List list3 = new ArrayList();
		
		
		list1.add("一");
		list1.add("二");
		list1.add("三");
		
		list2.add("四");
		list2.add("五");
		
		list3.add("一");
		list3.add("二");
		
		//将集合2中的元素放入集合1
		list1.addAll(list2);//[一，二，三，四，五]
		list1.removeAll(list3);//[三，四，五]
		/**
		 * 取交集
		 * 只保留list1中和list2中相同的元素
		 */
		list1.retainAll(list2);//[四，五]
		/**
		 * 以上方法比较元素相同都是使用equals方法比较的
		 */
	}
}



