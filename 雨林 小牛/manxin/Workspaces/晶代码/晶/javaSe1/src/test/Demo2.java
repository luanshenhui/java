package test;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/*
 * Ҫ������  ����list����
 */
public class Demo2 {
	public static void main(String[] args) {
		List<Integer> list = new ArrayList<Integer>();
		list.add(1);
		list.add(2);
		list.add(3);
		//��ͨ��forѭ��������
		for (int i = 0; i < list.size(); i++) {
			int a = list.get(i);
			System.out.println(a);
		}
		for(Integer a : list){
			System.out.println(a);
		}
		Iterator i = list.iterator();
		while(i.hasNext()){
			int a = (Integer)i.next();
			System.out.println(a);
		}
	}
}
