package day05;

import java.util.LinkedList;
import java.util.Queue;

/**
 * 队列
 * 一种数据结构
 * 可以存储一组元素，但是对存取有要求
 * 只能将元素添加到末尾，并且只能获取队首元素。
 * @author Administrator
 *
 */
public class QueueDemo {
	public static void main(String[] args) {
		//java.util.Queue
		Queue<String> queue = new LinkedList<String>();
		/**
		 * 向队列中添加元素
		 */
		queue.offer("A");
		queue.offer("B");
		queue.offer("C");
		
		System.out.println(queue);
		
		//输出队首元素
		//peek()方法获取队首元素，但不会将其从队列中删除
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



