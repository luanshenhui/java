package day06;
/*
 * �����г���runnable�ӿ�   Ϊʲô��  ��������Դ����
 */
public class ThreadDemo04 {
	public static void main(String[] args) {
		MyThread2 mt1 = new MyThread2();
		MyThread2 mt2 = new MyThread2();
		MyThread2 mt3 = new MyThread2();
		mt1.start();
		mt2.start();
		mt3.start();
	}
}

class MyThread2 extends Thread{
	private int ticket = 5;
	public void run(){
		for (int i = 0; i < 100; i++) {
			if(ticket > 0){
				System.out.println("��Ʊ��ticket= "+ ticket--);
			}
		}
	}
}