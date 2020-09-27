package day05;
/**
 * 中断睡眠阻塞
 * @author Administrator
 *
 */
public class InterruptExceptionDemo {
	public static void main(String[] args) {
		//林永健
		/**
		 * 一个方法中的局部内部类中若想引用该方法的其他
		 * 局部变量，这个变量必须是final的
		 * 
		 * 在内部类的外部想使用内部类的对象的时候  那么在内部类的对象前必须加final
		 */
		final Thread lin = new Thread(new Runnable(){
			public void run() {
				System.out.println("林:睡觉了");
				try {
					Thread.sleep(1000000);
				} catch (InterruptedException e) {
					System.out.println("林:干嘛呢！干嘛呢！都破了相了!");
				}
			}
		});
		//黄宏
		Thread huang = new Thread(new Runnable(){
			public void run() {
				for(int i =0;i<5;i++){
					System.out.println("黄:80!");
					try {
						Thread.sleep(1000);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
				System.out.println("黄:搞定!");
				//中断第一个线程
				lin.interrupt();
			}
		});
		
		huang.start();
		lin.start();
		
	}
}
