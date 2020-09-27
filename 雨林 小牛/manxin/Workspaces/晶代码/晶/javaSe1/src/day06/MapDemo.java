package day06;

import java.util.HashMap;
import java.util.Map;

/**
 * Map
 * 以key-value对的形式存放数据
 * 常用实现类
 * HashMap
 * 以散列算法实现的Map
 * @author Administrator
 *
 */
public class MapDemo {
	public static void main(String[] args) {
		/**
		 * Map要求的泛型有两个
		 * 第一个为Key的类型
		 * 第二个为Value的类型
		 */
		Map<String,String> map 
						= new HashMap<String,String>();
		//向map中存放数据
		map.put("name", "boss");
		map.put("sex", "man");
		map.put("phone", "13810000000");
		
		
		//获取数据  通过key获取value
		String name = map.get("name");
		System.out.println(name);
		
		//当key已经存在时，则是替换value操作
		String old = map.put("name", "kate");
		
		name = map.get("name");
		System.out.println(name);
		System.out.println("被替换的value:"+old);
		
		//map也重写了toString方法  [key1=value1,key2=value2]
		System.out.println(map);
		
		
	}
}






