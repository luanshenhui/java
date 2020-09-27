package day05;

import java.util.ArrayList;

import day05.Table.Person;


/**
 * ���̲߳�����������ʱ�������̰߳�ȫ����
 * @author Administrator
 *
 */
public class SyncDemo {
	public static void main(String[] args) {
		Table table = new Table();
		Person p1 = table.new Person();
		Person p2 = table.new Person();
		p1.start();
		p2.start();
	}
}

class Table{
	int bean = 20;//20�����ӣ������̹߳���	
	public int getBean(){
		synchronized (new ArrayList()) {
			if(bean == 0){
				throw new RuntimeException("û��!");
			}
			Thread.yield();//�õ�ǰ�߳��ó�CPUʱ��
			return bean--;
		}		
	}
	
	class Person extends Thread{
		public void run(){
			while(true){
				int b = getBean();
				System.out.println(getName()+":"+b);
				Thread.yield();
			}
		}
	}
	
}




