package day05;

import java.util.LinkedList;
import java.util.Queue;

/**
 * ����
 * һ�����ݽṹ
 * ���Դ洢һ��Ԫ�أ����ǶԴ�ȡ��Ҫ��
 * ֻ�ܽ�Ԫ����ӵ�ĩβ������ֻ�ܻ�ȡ����Ԫ�ء�
 * @author Administrator
 *
 */
public class QueueDemo {
	public static void main(String[] args) {
		//java.util.Queue
		Queue<String> queue = new LinkedList<String>();
		/**
		 * ����������Ԫ��
		 */
		queue.offer("A");
		queue.offer("B");
		queue.offer("C");
		
		System.out.println(queue);
		
		//�������Ԫ��
		//peek()������ȡ����Ԫ�أ������Ὣ��Ӷ�����ɾ��
		System.out.println(queue.peek());
		
		System.out.println(queue);
		
		String element;
		while(
				(element = queue.poll()) != null
		){
			System.out.println(element+"sss");		
		}
		System.out.println(queue);
		
	}
}



