  package day04;

import java.util.ArrayList;
import java.util.List;

/**
 * List������ʾ
 * @author Administrator
 *
 */
public class ListDemo3 {
	public static void main(String[] args) {
		List list1 = new ArrayList();
		List list2 = new ArrayList();
		List list3 = new ArrayList();
		
		
		list1.add("һ");
		list1.add("��");
		list1.add("��");
		
		list2.add("��");
		list2.add("��");
		
		list3.add("һ");
		list3.add("��");
		
		//������2�е�Ԫ�ط��뼯��1
		list1.addAll(list2);//[һ�����������ģ���]
		list1.removeAll(list3);//[�����ģ���]
		/**
		 * ȡ����
		 * ֻ����list1�к�list2����ͬ��Ԫ��
		 */
		list1.retainAll(list2);//[�ģ���]
		/**
		 * ���Ϸ����Ƚ�Ԫ����ͬ����ʹ��equals�����Ƚϵ�
		 */
	}
}



