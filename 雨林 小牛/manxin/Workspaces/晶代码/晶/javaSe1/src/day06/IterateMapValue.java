package day06;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/**
 * ����Map�е�����Value
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
		 * Ϊʲô����Collection��������Set?
		 * ��ΪSet���ϲ��ܴ���ظ�Ԫ�أ���Map��value�ǿ���
		 * �ظ��ģ�������ΪSet���ϣ����ܻᶪʧ��Ϣ��
		 */
		Collection<Integer> values = map.values();
		for(Integer value:values){
			System.out.println("values:"+value);
		}
	}
}






