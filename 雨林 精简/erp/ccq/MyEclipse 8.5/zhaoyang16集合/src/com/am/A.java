package com.am;

import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.ArrayList;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;

public class A {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		/*
		 * ���飺���Դ洢�����������ͺ������ͣ�����Ҫָ������
		 * 0
		 * java���ϡ���ܡ���6���ӿں�1��������
		 * 
		 * Collection�ӿڣ����ϵĶ����ӿڣ������˼��ϵĻ�������
		 *        ->List
		 *        ->Set
		 *            ->SortedSet//���ǽӿڣ�ȫ�Ǽ̳�
		 * list�ӿڣ�����(��Ӻͱ�����˳������)--��������Ҫ���ڱ���,ʵ�������磺ArrList��
		 * Set�ӿڣ����ظ�����һ����������HashSet��
		 * SortedSet�ӿڣ����ظ�����������.ʵ����TreeSet��
		 
		 * Map�ӿڣ��洢�ṹ�Ǽ�ֵ��(key value)SortedMap�ӿڣ�(Ҳ��key value)���Ƕ�key���� 
		 * Collections�� �����ϵĹ�����
		 * 
		 * 
		 * List���Ͻӿڣ����� List list=new ArrayList();
		 */
		// List <String>list=new ArrayList<String>();
		SortedSet<String> list = new TreeSet<String>();
		// 1,�ᴴ������(����ʹ�ü���ʱʹ�á����͡���ָ������Ԫ���д洢�����ͣ�java���ڱ����ڼ��)
		// �ڽӿ�List��ʵ�ֵķ���ArrayList���<ָ������>
		list.add("a");// 2�����Ԫ��
		list.add("b");
		list.add("c");
		list.add("b");
		list.add("e");
		list.add("7");
		

		System.out.println(list);
		/*
		 * //3ɾ��Ԫ�� Listһ�㲻����ɾ������ΪЧ�ʵ�
		 *  list.remove("b");
		 *   System.out.println(list);
		 * //4�޸�Ԫ�� ͬ�� list.set(0,"aaa");
		 *  System.out.println(list);
		 */

		// ���������ַ���
		/*
		 * 1������ArrayListԭ��ı������� size();������ʾ������Ԫ�صĸ���
		 */
		// for(int i=0;i<list.size();i++){
		// //get(i)���������±��ȡԪ��
		// String str=list.get(i);
		// System.out.println(list.get(i));
		// }
		// ��2�ֱ�������
		// for(String s:list){
		// System.out.println(s);
		// }
		// ��3�ֱ���������(����Ҫ����ͨ��!!!)������
		Iterator<String> iterator = list.iterator();
		while (iterator.hasNext()) {// has.next�ҵ��������Ƿ�����һ��Ԫ��
			String str = iterator.next();// next()ȡ����Ӧ��Ԫ��
			System.out.println(str);
		}
		
		
		
		
	}

}
