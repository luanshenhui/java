package day06;

import java.util.HashMap;
import java.util.Map;

/**
 * ʹ��Map�ṩ�ļ��������ݵķ�����
 * ���ͳ���ַ������ֵĴ���
 * @author Administrator
 *
 */
public class ContainsDemo {
	public static void main(String[] args) {
		String str 
				= "123,456,778,908,123,454,678,234,908,123";
		/**
		 * ͳ��str�ַ�����ÿ�����ֳ��ֵĴ���
		 * ˼·:
		 *   �Ƚ��ַ�������","��֣���ÿ��������Ϊkey,��
		 *   ���ִ�����Ϊvalue����map.
		 *   ����ÿ��ͳ��һ������ʱ������ֻ��Ҫ����������
		 *   ��Ϊkey�Ƿ���map�д��ڣ����������ǵ�һ��ͳ��
		 *   �����ڣ��򽫳��ִ����ۼӼ��ɡ�  
		 */
		//1 ���ַ�������","���
		String[] array = str.split(",");
		//2 ��������ͳ�Ƶ�Map
		Map<String,Integer> map 
					= new HashMap<String,Integer>();
		//3 ѭ���ַ������飬ͳ��ÿһ��
		for(String sub : array){
			//4 �ж�ÿ�������Ƿ���Ϊkey��Map�д���
			if(map.containsKey(sub)){
				//���Ѿ��������key,˵��ͳ�ƹ�����ô�Դ����ۼ�
				map.put(sub, map.get(sub) + 1);
				
			}else{
				//������˵��ûͳ�ƹ�����ô����map,���ִ�������Ϊ1
				map.put(sub, 1);
				
			}
		}
		//���ͳ�ƽ��
		System.out.println(map);
	}
}



