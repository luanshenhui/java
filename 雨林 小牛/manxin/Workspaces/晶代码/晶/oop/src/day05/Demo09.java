package day05;
/*
 * ΪʲôҪ����  ��Ϊϵͳ���Զ���һЩ��  ��Щ��������һЩ
 * ���õķ�����������  ��ʱ������Ҫ��ʹ����Щ������������
 * ����Ҫ����   ��ϵͳ����Ķ������뵽��Ҫ�õ��Ǹ���
 */
import java.util.Timer;
import java.util.TimerTask;

public class Demo09 {
	public static void main(String[] args) {
		Dog dog = new Dog();
		dog.start();
	}
}
// ʹ���ڲ���ʵ�� ��ʱ���ļƻ�����
class Dog{
	String name = "����";
	//����ʼ��
	public void start(){
		Timer timer = new Timer();
		timer.schedule(new RunTask(), 0, 1000);
	}
	// ʹ���ڲ����װ�� �ƻ����������
	private class RunTask extends TimerTask{
		public void run() {
			System.out.println(name+"��һ��"); 
		}
	}
}



