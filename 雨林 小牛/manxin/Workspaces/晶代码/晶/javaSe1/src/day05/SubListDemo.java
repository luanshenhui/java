package day05;

import java.util.ArrayList;
import java.util.List;

/**
 * List��ȡ�����Ӽ�
 * @author Administrator
 */
public class SubListDemo {
	public static void main(String[] args) {
		List<Integer> list = new ArrayList<Integer>();
		//�����������10������
		for(int i =0;i<10;i++){
			list.add(i);
		}
		System.out.println(list);//[0,1,2,3,4,5,6,7,8,9]
		/**
		 * ��ȡ�Ӽ�
		 */
		List<Integer> subList = list.subList(3, 8);
		System.out.println(subList);//[3,4,5,6,7]
		/**
		 * �޸��Ӽ���Ӱ��ԭ�����е�Ԫ��
		 */
		for(int i =0;i<subList.size();i++){
			subList.set(i, subList.get(i)*10);
		}
		System.out.println(subList);//[30,40,50,60,70]
		System.out.println(list);//[0,1,2,30,40,50,60,70,8,9]
	}
}










