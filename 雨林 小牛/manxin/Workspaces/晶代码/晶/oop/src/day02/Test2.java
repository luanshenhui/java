package day02;
public class Test2 {
	//要想使用变量  那么变量必须得 声明并且初始化才能使用
	int a = 0;
	public void test(){
		System.out.println(a);
	}
	public static void main(String[] args) {
		Test2 t = new Test2();
	}
	public Test2(){}
	//构造器  小名构造方法
	/*
	 * 构造器的格式  public 类名（）｛｝
	 * 作用：初始化成员变量
	 * 当你看到这个方法的时候 那么你会诧异  方法没有返回值? 因为他的作用
	 * 只是初始化  并没有其他多余的代码了
	 * 我也没有看到你写构造器啊  那咋就初始化a了呢？
	 * 因为系统提供了一个默认的无参数的构造器  
	 * 那么你说构造器初始化了成员变量  那么他是什么时候执行的呢？
	 * 
	 */

}
