package day06;
/*
 * Ϊʲô�����̲߳���ֱ��ʹ��run����
 * �̵߳�������Ҫ��������ϵͳ��֧��
 */
class MyThread extends Thread{
	private String name;
	public MyThread(String name) {
		// TODO Auto-generated constructor stub
		this.name = name;
	}
	public void run(){
		for (int i = 0; i < 10; i++) {
			System.out.println(name + "����, i =" + i);
		}
	}
}
public class ThreadDemo01{
	public static void main(String[] args) {
		MyThread mt1 = new MyThread("�߳�1");
		MyThread mt2 = new MyThread("�߳�2");
		mt1.start();
		mt2.start();
	}
}

