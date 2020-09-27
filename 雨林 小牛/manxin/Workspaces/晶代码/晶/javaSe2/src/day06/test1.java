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
 * 1。判断票数是否大于0，大于0则表示还有票可以卖
 * 2.如果票数大于0 则将票卖出
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
				System.out.println("卖票：ticket=" + ticket--);
			}
		}
		
	}
}
