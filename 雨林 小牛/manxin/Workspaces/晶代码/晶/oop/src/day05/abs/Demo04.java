package day05.abs;

import java.util.Timer;//��
import java.util.TimerTask;//������
/**
 * Timer:��ʱ��
 * TimerTask: ��ʱ������, ������һ��ʱ��ִ�еķ���
 *   TimerTask: �ǳ�����, ������һ�����󷽷�, �������
 *   ���� ����ʱִ�еķ���
 */
public class Demo04 {
	public static void main(String[] args) {
		Timer timer = new Timer();//������һ����ʱ��
		//schedule: �ƻ�, 
		timer.schedule(new MyTask(), 1000, 1000);
		//   ��ִ�е�����, ��һ��ִ���ӳ�ʱ��, ÿ�εļ��ʱ��
		
	}
}
class MyTask extends TimerTask{
	public void run() {
		System.out.println("HI"); 
	}
}




