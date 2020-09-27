package day05;
/**
 * Object����Ĺ����̵߳ķ���
 * wait()
 * notify()
 * @author Administrator
 *
 */
public class WaitNotify {
	//ͼƬ�Ƿ����������
	public static boolean finish = false;
	
	public static void main(String[] args) {	
		//����ͼƬ���߳�
		final Thread download = new Thread(){
			
			public void run(){
				System.out.println("��ʼ����ͼƬ");
				try {
					Thread.sleep(5000);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				System.out.println("ͼƬ�������");
				finish = true;
				synchronized (this) {
					this.notify();
				}
			}
		};
		//��ʾͼƬ���߳�
		Thread show = new Thread(){
			public void run(){
				try {
					synchronized (download) {
						download.wait();
					}					
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				if(!finish){
					throw new RuntimeException("��ʾͼƬʧ�ܣ�");
				}
				System.out.println("��ʾͼƬ");
			}
		};
		
		download.start();
		show.start();
	}
}
