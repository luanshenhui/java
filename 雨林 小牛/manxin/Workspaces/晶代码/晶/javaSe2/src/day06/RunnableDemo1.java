package day06;

public class RunnableDemo1{
	public static void main(String[] args) {
		MyThread1 my1 = new MyThread1("线程1");
		MyThread1 my2 = new MyThread1("线程1");
		Thread t1 = new Thread(my1);
		Thread t2 = new Thread(my2);
		t1.start();
		t2.start();
	}

}

class MyThread1 implements Runnable{
	private String name;
	public MyThread1(String name) {
		// TODO Auto-generated constructor stub
		this.name = name;
	}
	public void run(){
		for (int i = 0; i < 10; i++) {
			System.out.println(name + "运行, i =" + i);
		}
	}
}