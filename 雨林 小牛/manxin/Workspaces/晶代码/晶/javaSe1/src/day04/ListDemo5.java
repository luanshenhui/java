package day04;

import java.util.ArrayList;
import java.util.List;

import day01.Point;

/**
 * List������get��set����
 * 
 * @author Administrator
 *
 */
public class ListDemo5 {
	public static void main(String[] args) {
		List list = new ArrayList();
		list.add("one");
		list.add("two");
		list.add("three");
		
		for(int i = 0;i<list.size();i++){
			String str =(String)list.get(i);
			System.out.println(str);
		}
		/**
		 * set���������滻������ָ��λ���ϵ�Ԫ��
		 * set�����ķ���ֵΪ���滻��Ԫ��
		 * 
		 * set����ָ��������λ�ò��ܴ��������Ԫ������
		 * ���������±�Խ���쳣
		 */
		Object old = list.set(2, "��");
		System.out.println(list);
		System.out.println("���滻��Ԫ��:"+old);
	}
}




