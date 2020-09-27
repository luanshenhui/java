package day06;
/*
 * 为什么启动线程步能直接使用run方法
 * 线程的运行需要本机操作系统的支持
 */
class MyThread extends Thread{
	private String name;
	public MyThread(String name) {
		// TODO Auto-generated constructor stub
		this.name = name;
	}
	public void run(){
		for (int i = 0; i < 10; i++) {
			System.out.println(name + "运行, i =" + i);
		}
	}
}
public class ThreadDemo01{
	public static void main(String[] args) {
		MyThread mt1 = new MyThread("线程1");
		MyThread mt2 = new MyThread("线程2");
		mt1.start();
		mt2.start();
	}
}

