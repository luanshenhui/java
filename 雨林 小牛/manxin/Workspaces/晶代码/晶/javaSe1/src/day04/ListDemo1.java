package day04;

import java.util.ArrayList;
import java.util.List;
/**
 * ʲô�Ǽ��ϣ������е�Ԫ����ϵ�һ��
 * ���飺�����е�Ԫ����ϵ�һ��
 * 
 * List����
 * �����ҿ��ظ���
 * ʵ����ArrayList
 * @author Administrator
 */
public class ListDemo1 {
	public static void main(String[] args) {
		//java.util.XXX
		List list = new ArrayList();
		//�򼯺������Ԫ��
		/**
		 * ArrayList�ڲ�ʹ�ö���������ʽʵ��
		 * ArrayList���ʼ��һ�����飬��Ҫ��ŵ�Ԫ������
		 * ��������ʱ��ArrayList���Զ��������鳤�ȡ�
		 */
		list.add("һ");
		list.add("��");
		list.add("��");
		/**
		 * ArrayList��д��Object��toString����
		 * ���ص��ַ�����ʽΪ:
		 * 
		 * [Ԫ��1.toString(),Ԫ��2.toString(),....]
		 * 
		 * ��˳����ü�����ÿ��Ԫ�ص�toString��������ƴ����
		 * һ��
		 */
		System.out.println(list);
		//��ȡ����Ԫ������
		System.out.println("size:"+list.size());
		//�����������Ƿ����Ԫ�أ�����������true
		System.out.println("���ϲ�����Ԫ��:"+list.isEmpty());
		//��ռ���Ԫ��
		list.clear();
		System.out.println("size:"+list.size());
		System.out.println("���ϲ�����Ԫ��:"+list.isEmpty());
		/**
		 * ע�� �ж�null��isEmpty������
		 * �ж�nullָ���Ǽ��϶����Ƿ����
		 * isEmpty()ָ���Ǽ��϶����Ǵ��ڵģ�ֻ����û��Ԫ�ء�
		 * 
		 * 
		 */
		System.out.println(list==null);
		System.out.println(list.isEmpty());
	}
}





