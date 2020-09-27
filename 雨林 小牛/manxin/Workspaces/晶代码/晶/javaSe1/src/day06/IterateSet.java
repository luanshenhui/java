package day06;

import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

/**
 * 遍历Set集
 * 只能使用迭代器的方式遍历
 * @author Administrator
 *
 */
public class IterateSet {
	public static void main(String[] args) {
		Set<String> set = new HashSet<String>();		
		/**
		 * 元素存放的顺序与取出来的顺序不一致
		 * 
		 * 但是在元素不修改的前提下，如论以什么顺序存放
		 * 在Set集合中的顺序都是一定的。
		 * 
		 * 我们只关注存放顺序与取出的顺序不一致即可。
		 * 
		 */
		set.add("two");
		set.add("three");
		set.add("one");
		
		for (String string : set) {
			System.out.println(string);
		}
		//创建迭代器
		Iterator<String> it = set.iterator();
		while(it.hasNext()){
			String str = it.next();
			System.out.println(str);
		}
		
		/**
		 * 增强for循环同样可以遍历Set集合
		 * 对于编译器而言，增强for循环在编译后会转换为iterator
		 * 所以可以用增强循环遍历
		 */
		for(String str : set){
			System.out.println(str);
		}
	}
}







