package day06;

import java.util.HashMap;
import java.util.Map;

/**
 * 使用Map提供的检查包含内容的方法来
 * 完成统计字符串出现的次数
 * @author Administrator
 *
 */
public class ContainsDemo {
	public static void main(String[] args) {
		String str 
				= "123,456,778,908,123,454,678,234,908,123";
		/**
		 * 统计str字符串中每组数字出现的次数
		 * 思路:
		 *   先将字符串按照","拆分，将每组数字作为key,将
		 *   出现次数作为value存入map.
		 *   这样每当统计一组数字时，我们只需要看这组数字
		 *   作为key是否在map中存在，不存在则是第一次统计
		 *   若存在，则将出现次数累加即可。  
		 */
		//1 将字符串按照","拆分
		String[] array = str.split(",");
		//2 创建用于统计的Map
		Map<String,Integer> map 
					= new HashMap<String,Integer>();
		//3 循环字符串数组，统计每一项
		for(String sub : array){
			//4 判断每组数字是否作为key在Map中存在
			if(map.containsKey(sub)){
				//若已经包含这个key,说明统计过。那么对次数累加
				map.put(sub, map.get(sub) + 1);
				
			}else{
				//不包含说明没统计过，那么放入map,出现次数设置为1
				map.put(sub, 1);
				
			}
		}
		//输出统计结果
		System.out.println(map);
	}
}



