package day06;

import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

/**
 * ����Map�ļ�ֵ��
 * Map����һ���ڲ���Entry����ÿһ��ʵ������һ���ֵ��
 * �����ǵ���put�����������ʱ��Map�ᴴ��һ��Entryʵ��
 * ����key,value����ö���󱣴浽Map��
 * ���ԣ�ɢ�������У�ÿһ���LinkedList�б���Ķ���Entry
 * @author Administrator
 *
 */
public class IterateMapEntry {
	public static void main(String[] args) {
		Map<String,Integer> map 
					= new HashMap<String,Integer>();
		map.put("a", 1);
		map.put("b", 2);
		map.put("c", 3);
		map.put("d", 4);
		map.put("e", 5);
		/**
		 * java.util.Map.Entry
		 * Entry<String,Integer>
		 */
		//��map���ϱ����entryset����   entrySet��������map��key  �� value
		Set<Entry<String,Integer>> entrySet 
							= map.entrySet();
		//����ÿһ���ֵ��
		for(Entry<String,Integer> entry : entrySet ){
			/**
			 * ͨ��Entry��ȡ�����ֵ���е�key��value
			 */
			String key = entry.getKey();
			int value = entry.getValue();
			System.out.println(key + ":" + value);
		}
	}
}





