package day06;

import java.util.HashMap;
import java.util.Map;

/**
 * Map
 * ��key-value�Ե���ʽ�������
 * ����ʵ����
 * HashMap
 * ��ɢ���㷨ʵ�ֵ�Map
 * @author Administrator
 *
 */
public class MapDemo {
	public static void main(String[] args) {
		/**
		 * MapҪ��ķ���������
		 * ��һ��ΪKey������
		 * �ڶ���ΪValue������
		 */
		Map<String,String> map 
						= new HashMap<String,String>();
		//��map�д������
		map.put("name", "boss");
		map.put("sex", "man");
		map.put("phone", "13810000000");
		
		
		//��ȡ����  ͨ��key��ȡvalue
		String name = map.get("name");
		System.out.println(name);
		
		//��key�Ѿ�����ʱ�������滻value����
		String old = map.put("name", "kate");
		
		name = map.get("name");
		System.out.println(name);
		System.out.println("���滻��value:"+old);
		
		//mapҲ��д��toString����  [key1=value1,key2=value2]
		System.out.println(map);
		
		
	}
}






