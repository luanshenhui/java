package day05;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * ���ϵ�������ʹ��
 * @author Administrator
 *
 */
public class IteratorDemo {
	public static void main(String[] args) {
		List list = new ArrayList();
		list.add("one");
		list.add("#");
		list.add("two");
		list.add("#");
		list.add("three");
		list.add("#");
		/**
		 * java.util.Iterator
		 * ��������ר��Ϊwhileѭ����Ƶ�
		 */
		Iterator it = list.iterator();
		while(it.hasNext()){
			/**
			 * next������ȡ��������һ��Ԫ��
			 * ��get����һ������ŵ�ʱ����Object���
			 * ȡ��ʱ��Ҳ����Object���صģ�����Ҫ����
			 */
			String element = (String)it.next();
			/**
			 * ʹ�õ������ڱ�������Ԫ�ع������ǿ���ɾ��
			 * �����е�Ԫ�صģ�ʹ�õ��ǵ�������remove����
			 * ɾ������������#
			 */
			if("#".equals(element)){
				//������ͨ��next������ȡ��Ԫ�شӼ�����ɾ��
				it.remove();
				/**
				 * �������ڵ��������У�����ͨ��ʹ�ü��϶����
				 * ɾ������ȥɾ������Ԫ�أ�һ��Ҫʹ�õ�������
				 * ɾ��������������������л�����쳣��
				 */
//				list.remove(element);
			}
			
			
			System.out.println(element);
		}
		
		System.out.println(list);
	}
}

















