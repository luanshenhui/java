package day05;
/*
 * 为什么要导包  因为系统会自定义一些类  这些类里面有一些
 * 常用的方法或者属性  这时候我们要想使用这些方法或者属性
 * 就需要导包   把系统定义的东西引入到你要用的那个类
 */
import java.util.Timer;
import java.util.TimerTask;

public class Demo09 {
	public static void main(String[] args) {
		Dog dog = new Dog();
		dog.start();
	}
}
// 使用内部类实现 定时器的计划任务
class Dog{
	String name = "旺财";
	//狗开始走
	public void start(){
		Timer timer = new Timer();
		timer.schedule(new RunTask(), 0, 1000);
	}
	// 使用内部类封装了 计划任务的声明
	private class RunTask extends TimerTask{
		public void run() {
			System.out.println(name+"走一步"); 
		}
	}
}



