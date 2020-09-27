package day05;

import java.util.ArrayList;
import java.util.List;

/**
 * 新循环
 * @author Administrator
 *
 */
public class NewForDemo {
	public static void main(String[] args) {
		int[] array = {1,2,3,4,5,6,7};
		
		for(int i=0;i<array.length;i++){
			int n = array[i];
			System.out.println("第"+i+"项:"+n);
		}
		
		for(int i : array){
			System.out.println(i);
		}
		
		/**
		 * 新循环遍历集合
		 */
		List<String> list = new ArrayList<String>();
		list.add("one");
		list.add("two");
		list.add("three");
		/**
		 * 使用新循环注意两点
		 * 1:新循环是在编译时动态将新循环转化为迭代器方式遍历
		 * 
		 * 2:因为新循环使用迭代器方式遍历，所以在遍历集合时，
		 *   不能通过集合删除元素。
		 * 
		 */
		for(String str : list){
			System.out.println(str);
		}
	}
}






