package day05;

import java.util.Deque;
import java.util.LinkedList;

/**
 * 栈结构
 * 存取本着先进后出原则
 * @author Administrator
 * LinkedList 双向链表
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
		 * 遍历栈结构
		 */
		while(deque.peek() != null){
			String element = deque.pop();
			System.out.println(element);
		}
		System.out.println(deque);
	}
}





