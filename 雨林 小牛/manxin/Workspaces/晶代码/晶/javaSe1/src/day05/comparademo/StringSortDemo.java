package day05.comparademo;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/**
 * �����ַ���
 * @author Administrator
 *
 */
public class StringSortDemo {
	public static void main(String[] args) {
		List<String> list = new ArrayList<String>();
		list.add("mary");
		list.add("Killer");
		list.add("able");
		list.add("big");
		list.add("Allen");
		list.add("Xiloer");
		list.add("Kate");
		/**
		 * �ַ���ʵ����Comparable�ӿ�
		 * �����ַ��������Ǿ߱��ɱȽϵ�
		 */
		Collections.sort(list);
		System.out.println(list);
		
		/**
		 * ����:�����ַ����ĳ���������
		 * �ַ����ıȽϹ��������������������ʱ�����ǿ���
		 * ����Ķ���ȽϹ�������������������
		 */
		Comparator<String> comparator = 
			new Comparator<String>(){
				public int compare(String o1, String o2) {					
					return o1.length() - o2.length();
				}		
		};
		
		Collections.sort(list, comparator);
		System.out.println(list);
		
	}
}





