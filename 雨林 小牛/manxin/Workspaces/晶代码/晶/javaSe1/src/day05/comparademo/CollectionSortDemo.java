package day05.comparademo;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * ���ϵ�����
 * @author Administrator
 *
 */
public class CollectionSortDemo {
	public static void main(String[] args) {
		List<Point> list = new ArrayList<Point>();
		list.add(new Point(1,5));
		list.add(new Point(3,4));
		list.add(new Point(2,2));
		//�������
		System.out.println(list);
		
		/**
		 * ʹ�ü��ϵĹ�����Լ���Ԫ�ؽ�����Ȼ����
		 * ��Ȼ����:��С����
		 */
		Collections.sort(list);
		System.out.println(list);
		
	}
}












