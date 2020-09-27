package day06;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/**
 * 遍历Map中的所有Value
 * 
 * @author Administrator
 * 
 */
public class IterateMapValue {
	public static void main(String[] args) {
		Map<String, Integer> map 
								= new HashMap<String, Integer>();
		map.put("a", 1);
		map.put("b", 2);
		map.put("c", 3);
		map.put("d", 4);
		map.put("e", 5);
		/**
		 * 为什么返回Collection而不返回Set?
		 * 因为Set集合不能存放重复元素，而Map中value是可以
		 * 重复的，若返回为Set集合，可能会丢失信息。
		 */
		Collection<Integer> values = map.values();
		for(Integer value:values){
			System.out.println("values:"+value);
		}
	}
}






