package day06;

public class Test2 {
	public static void main(String[] args) {
		MyThread111 mt = new MyThread111();
		Thread t1 = new Thread(mt);
		Thread t2 = new Thread(mt);
		Thread t3 = new Thread(mt);
		t1.start();
		t2.start();
		t3.start();
	}
}
class MyThread111 implements Runnable{
	private int ticket = 5;

	@Override
	public void run() {
		// TODO Auto-generated method stub
		for (int i = 0; i < 100; i++) {
			synchronized(this){
			if(ticket > 0){
				try {
					Thread.sleep(300);
				} catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
				}
				System.out.println("ÂôÆ±£ºticket=" + ticket--);
			}
		}
		}
		
	}
}
