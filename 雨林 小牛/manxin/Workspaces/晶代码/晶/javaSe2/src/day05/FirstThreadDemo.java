package day05;
/**
 * 多线程并发操作
 * @author Administrator
 */
public class FirstThreadDemo {
	public static void main(String[] args) {
		/**
		 * 异步 与 同步
		 * 异步:你干你的，我干我的
		 * 同步:你干完我再干
		 */
//		for(int i =0;i<1000;i++){
//			System.out.println("你是谁啊");
//			System.out.println("我是修水管的");
//		}
		Thread t1 = new FirstThread();
		Thread t2 = new SecThread();
		/**
		 * 启动线程，我们不能直接调用run方法！！
		 * 而是要调用启动线程的start()方法
		 */
		/**
		 * 对于线程而言
		 * 程序不可控的因素:
		 * 1:CPU分配给线程的时间片段的长短
		 * 2:CPU运行线程的次数
		 */
		t1.start();
		t2.start();
	}
}
/**
 * 需要并发执行的任务，我们可以定义一个线程类(继承Thread)，
 * 然后重写run方法。在其中编写并发任务逻辑
 *
 */
class FirstThread extends Thread{
	public void run(){
		for(int i =0;i<1000;i++){
			System.out.println("你是谁呀？");
		}
	}
}
class SecThread extends Thread{
	public void run(){
		for(int i =0;i<1000;i++){
			System.out.println("我是修水管的");
		}
	}
}



