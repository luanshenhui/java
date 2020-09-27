package day05;

import java.util.ArrayList;

import day05.Table.Person;


/**
 * 多线程操作共享数据时产生的线程安全问题
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
	int bean = 20;//20个豆子，用于线程共享	
	public int getBean(){
		synchronized (new ArrayList()) {
			if(bean == 0){
				throw new RuntimeException("没了!");
			}
			Thread.yield();//让当前线程让出CPU时间
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




