package day05;

import java.util.Deque;
import java.util.LinkedList;

/**
 * ջ�ṹ
 * ��ȡ�����Ƚ����ԭ��
 * @author Administrator
 * LinkedList ˫������
 *
 */
public class DequeDemo{
	public static void main(String[] args) {
		//java.util.Deque
		Deque<String> deque = new LinkedList<String>();
		
		deque.push("A");
		deque.push("B");
		deque.push("C");
		deque.push("D");
		deque.push("E");
		
		System.out.println(deque);//[E,D,C,B,A]
		
		/**
		 * ����ջ�ṹ
		 */
		while(deque.peek() != null){
			String element = deque.pop();
			System.out.println(element);
		}
		System.out.println(deque);
	}
}





