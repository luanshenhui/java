package day06;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

/**
 * 遍历Map中的所有Key
 * @author Administrator
 *
 */
public class IterateMapKey {
	public static void main(String[] args) {
		/**
		 * LinkedHashMap
		 * 可以保证存放顺序
		 */
		Map<String,String> map 
						= new LinkedHashMap<String,String>();
		map.put("1", "a");
		map.put("2", "b");
		map.put("3", "c");
		map.put("4", "d");
		map.put("5", "e");
		/**
		 * 获取Map中所有的key值
		 * 获取的Set的泛型应与Map中定义的key的泛型一致
		 * 这个方法返回值是map中所有的key
		 */
		Set<String> keySet = map.keySet();
		for(String key:keySet){
			System.out.println("key:"+key);
			/**
			 * 遍历出每一个key就可以用key从map中获取对应的
			 * value
			 */
			System.out.println("value:"+map.get(key));
		}
	}
	
}





