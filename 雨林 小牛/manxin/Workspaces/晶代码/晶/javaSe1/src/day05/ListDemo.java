package day05;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import day01.Point;

/**
 * ���϶Է��͵�֧��
 * @author Administrator
 *
 */
public class ListDemo {
	public static void main(String[] args) {
		/**
		 * �����еķ���ָ�����Ǵ�ŵ�Ԫ����ʲô���͵ġ�
		 */
		List<String> list = new ArrayList<String>();
		list.add("123");
		list.add("456");
		list.add("789");
//		list.add(123);//�������Ͳ�ƥ�䣡
		
		for(int i =0;i<list.size();i++){
			/**
			 * get������ȡԪ��ʱֱ���Ƿ���ָ��������
			 * �����ٽ���������
			 */
			String element = list.get(i);
			System.out.println(element);
		}
		/**
		 * ������Ҳ֧�ַ���
		 * ��Ҫע�⣡������ָ���ķ�������һ��Ҫ��
		 * �����ļ��ϵķ�������һ�£�
		 */
		Iterator<String> it = list.iterator();
		while(it.hasNext()){
			/**
			 * ʹ�õ�������ȡԪ��ʱҲ������Ҫ����
			 */
			String element = it.next();
			System.out.println(element);
		}
		
		List<Point> list2 = new ArrayList<Point>();
		list2.add(new Point(1,2));
//		list2.add("123");
	}
}







