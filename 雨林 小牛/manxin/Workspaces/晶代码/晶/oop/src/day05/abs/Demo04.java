package day05.abs;

import java.util.Timer;//类
import java.util.TimerTask;//抽象类
/**
 * Timer:定时器
 * TimerTask: 定时器任务, 就是在一定时刻执行的方法
 *   TimerTask: 是抽象类, 里面有一个抽象方法, 这个方法
 *   就是 被定时执行的方法
 */
public class Demo04 {
	public static void main(String[] args) {
		Timer timer = new Timer();//创建了一个定时器
		//schedule: 计划, 
		timer.schedule(new MyTask(), 1000, 1000);
		//   被执行的任务, 第一次执行延迟时间, 每次的间隔时间
		
	}
}
class MyTask extends TimerTask{
	public void run() {
		System.out.println("HI"); 
	}
}




