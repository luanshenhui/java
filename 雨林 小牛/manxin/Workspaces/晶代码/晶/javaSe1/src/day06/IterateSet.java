package day06;

import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

/**
 * ����Set��
 * ֻ��ʹ�õ������ķ�ʽ����
 * @author Administrator
 *
 */
public class IterateSet {
	public static void main(String[] args) {
		Set<String> set = new HashSet<String>();		
		/**
		 * Ԫ�ش�ŵ�˳����ȡ������˳��һ��
		 * 
		 * ������Ԫ�ز��޸ĵ�ǰ���£�������ʲô˳����
		 * ��Set�����е�˳����һ���ġ�
		 * 
		 * ����ֻ��ע���˳����ȡ����˳��һ�¼��ɡ�
		 * 
		 */
		set.add("two");
		set.add("three");
		set.add("one");
		
		for (String string : set) {
			System.out.println(string);
		}
		//����������
		Iterator<String> it = set.iterator();
		while(it.hasNext()){
			String str = it.next();
			System.out.println(str);
		}
		
		/**
		 * ��ǿforѭ��ͬ�����Ա���Set����
		 * ���ڱ��������ԣ���ǿforѭ���ڱ�����ת��Ϊiterator
		 * ���Կ�������ǿѭ������
		 */
		for(String str : set){
			System.out.println(str);
		}
	}
}







