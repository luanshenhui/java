package day06;
public class test1 {
	public static void main(String[] args) {
		MyThread11 mt = new MyThread11();
		Thread t1 = new Thread(mt);
		Thread t2 = new Thread(mt);
		Thread t3 = new Thread(mt);
		t1.start();
		t2.start();
		t3.start();
	}
}
/*
 * 1���ж�Ʊ���Ƿ����0������0���ʾ����Ʊ������
 * 2.���Ʊ������0 ��Ʊ����
 */
class MyThread11 implements Runnable{
	private int ticket = 5;
	public void run() {
		// TODO Auto-generated method stub
		for (int i = 0; i < 100; i++) {
			if(ticket > 0){
				try {
					Thread.sleep(300);
				} catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
				}
				System.out.println("��Ʊ��ticket=" + ticket--);
			}
		}
		
	}
}
