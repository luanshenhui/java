package day05;
/**
 * �ж�˯������
 * @author Administrator
 *
 */
public class InterruptExceptionDemo {
	public static void main(String[] args) {
		//������
		/**
		 * һ�������еľֲ��ڲ������������ø÷���������
		 * �ֲ��������������������final��
		 * 
		 * ���ڲ�����ⲿ��ʹ���ڲ���Ķ����ʱ��  ��ô���ڲ���Ķ���ǰ�����final
		 */
		final Thread lin = new Thread(new Runnable(){
			public void run() {
				System.out.println("��:˯����");
				try {
					Thread.sleep(1000000);
				} catch (InterruptedException e) {
					System.out.println("��:�����أ������أ�����������!");
				}
			}
		});
		//�ƺ�
		Thread huang = new Thread(new Runnable(){
			public void run() {
				for(int i =0;i<5;i++){
					System.out.println("��:80!");
					try {
						Thread.sleep(1000);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
				System.out.println("��:�㶨!");
				//�жϵ�һ���߳�
				lin.interrupt();
			}
		});
		
		huang.start();
		lin.start();
		
	}
}
