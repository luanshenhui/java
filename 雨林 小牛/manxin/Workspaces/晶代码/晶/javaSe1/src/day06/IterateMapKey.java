package day06;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

/**
 * ����Map�е�����Key
 * @author Administrator
 *
 */
public class IterateMapKey {
	public static void main(String[] args) {
		/**
		 * LinkedHashMap
		 * ���Ա�֤���˳��
		 */
		Map<String,String> map 
						= new LinkedHashMap<String,String>();
		map.put("1", "a");
		map.put("2", "b");
		map.put("3", "c");
		map.put("4", "d");
		map.put("5", "e");
		/**
		 * ��ȡMap�����е�keyֵ
		 * ��ȡ��Set�ķ���Ӧ��Map�ж����key�ķ���һ��
		 * �����������ֵ��map�����е�key
		 */
		Set<String> keySet = map.keySet();
		for(String key:keySet){
			System.out.println("key:"+key);
			/**
			 * ������ÿһ��key�Ϳ�����key��map�л�ȡ��Ӧ��
			 * value
			 */
			System.out.println("value:"+map.get(key));
		}
	}
	
}





