package day05;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 睡眠阻塞
 * @author Administrator
 *
 */
public class SleepBlockDemo {
	public static void main(String[] args) throws InterruptedException {
		/**
		 * 使用睡眠阻塞实现电子表
		 */
		SimpleDateFormat format = 
			new SimpleDateFormat("HH:mm:ss");
		
		while(true){
			//输出一次当前系统时间
			System.out.println(format.format(new Date()));
			for(int i =0;i<4;i++){
				System.out.println();
			}
			//停一秒钟
			/**
			 * 这里阻塞的是jvm创建的用于执行当前类的main方法
			 * 的线程。
			 */
			Thread.sleep(1000);
		}
		
	}
}










