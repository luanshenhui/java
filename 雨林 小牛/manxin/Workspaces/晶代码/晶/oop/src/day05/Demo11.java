package day05;

import java.util.Timer;
import java.util.TimerTask;

public class Demo11 {
	public static void main(String[] args) {
		TimerTask task = new TimerTask(){
			public void run(){
				System.out.println("HI");
			}
		};
		Timer timer = new Timer();
		timer.schedule(task, 0, 1000);
//		
//		Timer timer = new Timer();
//		timer.schedule(new TimerTask(){
//			public void run(){
//				System.out.println("HI"); 
//			}
//		}, 0, 1000);
	}
}


