package day05;
/**
 * ���̲߳�������
 * @author Administrator
 */
public class FirstThreadDemo {
	public static void main(String[] args) {
		/**
		 * �첽 �� ͬ��
		 * �첽:�����ģ��Ҹ��ҵ�
		 * ͬ��:��������ٸ�
		 */
//		for(int i =0;i<1000;i++){
//			System.out.println("����˭��");
//			System.out.println("������ˮ�ܵ�");
//		}
		Thread t1 = new FirstThread();
		Thread t2 = new SecThread();
		/**
		 * �����̣߳����ǲ���ֱ�ӵ���run��������
		 * ����Ҫ���������̵߳�start()����
		 */
		/**
		 * �����̶߳���
		 * ���򲻿ɿص�����:
		 * 1:CPU������̵߳�ʱ��Ƭ�εĳ���
		 * 2:CPU�����̵߳Ĵ���
		 */
		t1.start();
		t2.start();
	}
}
/**
 * ��Ҫ����ִ�е��������ǿ��Զ���һ���߳���(�̳�Thread)��
 * Ȼ����дrun�����������б�д���������߼�
 *
 */
class FirstThread extends Thread{
	public void run(){
		for(int i =0;i<1000;i++){
			System.out.println("����˭ѽ��");
		}
	}
}
class SecThread extends Thread{
	public void run(){
		for(int i =0;i<1000;i++){
			System.out.println("������ˮ�ܵ�");
		}
	}
}



