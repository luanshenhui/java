package day05;
/**
 * ���������߳��壬ʹ���߳�������ֿ���
 * �̱߳��͸ù��Ĳ������У������ľ����ʲô
 * �ͺñȻ������ù�����ʲô��һ����
 * 
 * @author Administrator
 *
 */
public class RunnableDemo {
	public static void main(String[] args) {
		//ʵ����Ҫ����ִ�е�����
		FirstRunnable r1 = new FirstRunnable();
		SecRunnable r2 = new SecRunnable();
		
		Runnable r3 = new Runnable(){
			public void run() {
				for(int i =0;i<1000;i++){
					System.out.println("���Ǵ��͵�");
				}
			}	
		};
		
		//ʵ�����̣߳���ָ������
		Thread t1 = new Thread(r1);
		Thread t2 = new Thread(r2);
		Thread t3 = new Thread(r3);
		t1.start();
		t2.start();
		t3.start();
	}
}
/**
 * ����һ����ʵ��Runnable�ӿ�
 * ��дrun�������岢��Ҫִ�е������߼�
 */
class FirstRunnable implements Runnable{
	public void run() {
		for(int i =0;i<1000;i++){
			System.out.println("����˭ѽ");
		}
	}
}
class SecRunnable implements Runnable{
	public void run() {
		for(int i =0;i<1000;i++){
			System.out.println("������ˮ�ܵ�");
		}
	}
}


