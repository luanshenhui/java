package day04;

import java.util.ArrayList;
import java.util.List;

import day01.Point;

/**
 * List������ʾ
 * @author Administrator
 *
 */
public class ListDemo2 {
	public static void main(String[] args) {
		List list = new ArrayList();
		Point point = new Point(1,2);
		list.add(point);
		list.add(point);
		list.add(new Point(3,4));
		list.add(new Point(5,6));
		
		System.out.println(list);
		//��������һ������
		Point p = new Point(1,2);
		/**
		 * Ԫ�ص�equals�����Լ��ϵĺܶ��������Ӱ�죡
		 * �жϼ����Ƿ����������Ԫ��ʱ�����ϻὫ���Ԫ��
		 * �뼯���е�Ԫ�طֱ����equals�Ƚϣ����з���ֵΪ
		 * true�ģ�����Ϊ���ϰ���������Ԫ�ء�
		 */
		System.out.println(point == p);//false ����ͬһ������
		System.out.println(point.equals(p));//������ͬ
		System.out.println("p�ڼ�����ô��"+ list.contains(p));
		/**
		 * remove�����ǽ�������Ԫ���뼯����ÿ��Ԫ�ؽ���
		 * equals�Ƚϣ�ɾ����һ���ȽϽ��Ϊtrue��Ԫ�ء�
		 * 
		 */
		list.remove(p);
		System.out.println(list);
		
	}

}




