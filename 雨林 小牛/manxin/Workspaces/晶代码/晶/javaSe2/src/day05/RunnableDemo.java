package day05;
/**
 * 独立定义线程体，使得线程与任务分开。
 * 线程本就该关心并发运行，不关心具体干什么
 * 就好比货车不该关心拉什么货一样。
 * 
 * @author Administrator
 *
 */
public class RunnableDemo {
	public static void main(String[] args) {
		//实例化要并发执行的任务
		FirstRunnable r1 = new FirstRunnable();
		SecRunnable r2 = new SecRunnable();
		
		Runnable r3 = new Runnable(){
			public void run() {
				for(int i =0;i<1000;i++){
					System.out.println("我是打酱油的");
				}
			}	
		};
		
		//实例化线程，并指派任务
		Thread t1 = new Thread(r1);
		Thread t2 = new Thread(r2);
		Thread t3 = new Thread(r3);
		t1.start();
		t2.start();
		t3.start();
	}
}
/**
 * 定义一个类实现Runnable接口
 * 重写run方法定义并发要执行的任务逻辑
 */
class FirstRunnable implements Runnable{
	public void run() {
		for(int i =0;i<1000;i++){
			System.out.println("你是谁呀");
		}
	}
}
class SecRunnable implements Runnable{
	public void run() {
		for(int i =0;i<1000;i++){
			System.out.println("我是修水管的");
		}
	}
}


