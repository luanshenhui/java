package day05;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * ˯������
 * @author Administrator
 *
 */
public class SleepBlockDemo {
	public static void main(String[] args) throws InterruptedException {
		/**
		 * ʹ��˯������ʵ�ֵ��ӱ�
		 */
		SimpleDateFormat format = 
			new SimpleDateFormat("HH:mm:ss");
		
		while(true){
			//���һ�ε�ǰϵͳʱ��
			System.out.println(format.format(new Date()));
			for(int i =0;i<4;i++){
				System.out.println();
			}
			//ͣһ����
			/**
			 * ������������jvm����������ִ�е�ǰ���main����
			 * ���̡߳�
			 */
			Thread.sleep(1000);
		}
		
	}
}










