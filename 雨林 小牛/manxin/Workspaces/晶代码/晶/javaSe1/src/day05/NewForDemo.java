package day05;

import java.util.ArrayList;
import java.util.List;

/**
 * ��ѭ��
 * @author Administrator
 *
 */
public class NewForDemo {
	public static void main(String[] args) {
		int[] array = {1,2,3,4,5,6,7};
		
		for(int i=0;i<array.length;i++){
			int n = array[i];
			System.out.println("��"+i+"��:"+n);
		}
		
		for(int i : array){
			System.out.println(i);
		}
		
		/**
		 * ��ѭ����������
		 */
		List<String> list = new ArrayList<String>();
		list.add("one");
		list.add("two");
		list.add("three");
		/**
		 * ʹ����ѭ��ע������
		 * 1:��ѭ�����ڱ���ʱ��̬����ѭ��ת��Ϊ��������ʽ����
		 * 
		 * 2:��Ϊ��ѭ��ʹ�õ�������ʽ�����������ڱ�������ʱ��
		 *   ����ͨ������ɾ��Ԫ�ء�
		 * 
		 */
		for(String str : list){
			System.out.println(str);
		}
	}
}






