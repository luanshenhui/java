package day04;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * List���е�add��remove����
 * @author Administrator
 *
 */
public class ListDemo6 {
	public static void main(String[] args) {
		List list = new ArrayList();
		list.add("one");
		list.add("two");
		list.add("three");
		
		System.out.println(list);//[one,two,three]
		
		list.add(2,"��");
		System.out.println(list);//[one,two,��,three]
		/**
		 * Object remove(int index)
		 * ɾ��ָ����������Ԫ��
		 * ����ֵΪ��ɾ����Ԫ��
		 */
		Object old = list.remove(1);//ɾ���ڶ���Ԫ��
		System.out.println(list);//[one,��,three]
		System.out.println("��ɾ������:" + old);
		
		/**
		 * ��ѯָ��Ԫ���ڼ����е�λ��
		 * int indexOf(Object obj)
		 * �ڼ����в�ѯ����Ԫ�ص�һ�γ��ֵ�λ��
		 * ����Ҳ��ʹ�ø���Ԫ���뼯��Ԫ�ؽ���equals�ıȽϷ�ʽ
		 */
		System.out.println(
				"three��λ��:"+list.indexOf("three")
		);
		
		System.out.println(
				"three�����ֵ�λ��:"+list.lastIndexOf("three")
		);
		
		/**
		 * ������ת��Ϊ����
		 * ע��:
		 *  Ҫȷ�������д�ŵ�Ԫ��������һ�µģ�
		 *  ��Ҫת����Ŀ����������Ҫ��Ԫ������һ�¡�
		 *  
		 * toArray()����
		 * ���ڽ�����ת��Ϊ����
		 * toArray������Collection����ķ��������м��϶��߱� 
		 * 
		 * 
		 * ��ת��ʲô���͵����飬toArray���������ʹ�ʲô����
		 * �����ʵ��
		 * ���Ǹ���������ʵ������Ҫ�����ȣ���Ϊ����ʹ�ã�
		 * toArray����ֻ�ǽ�������Ǵ��������������͡�
		 */
		
		String[] array 
				= (String[])list.toArray(new String[0]);
		
		System.out.println("����:"+Arrays.toString(array));
	}
}





