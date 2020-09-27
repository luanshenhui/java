package day06;

public class TunnableDemo02 {
	public static void main(String[] args) {
		MyThread3 mt1 = new MyThread3();
		new Thread(mt1).start();
		new Thread(mt1).start();
		new Thread(mt1).start();
	}
}
class MyThread3 implements Runnable{
	private int ticket = 5;
	public void run(){
		for (int i = 0; i < 100; i++) {
			if(ticket > 0){
				System.out.println("ÂòÆ±£ºticket= "+ ticket--);
			}
		}
	}
}
