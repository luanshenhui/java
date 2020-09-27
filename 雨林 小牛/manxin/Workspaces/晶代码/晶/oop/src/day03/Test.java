package day03;
/**
 * 实例化了子类对象  但是输出了父类构造器里的东西
 * 子类中无参数的构造器一定调用父类的无参数的构造器
 * @author Administrator
 *
 */
public class Test {
	public static void main(String[] args) {
		test1111 t = new test1111();
	}
}
class test111{
	public test111(int a) {
		// TODO Auto-generated constructor stub
	System.out.println("test");
	}
}
class test1111 extends test111{
	//子类中有无参数的构造器  但是父类中有一个有参数的构造器 但是
	//没有无参数的构造器的情况下报错了?怎么办呢？
	//1 在父类中写一个无参数的构造器
	//2 在子类中的无参数的构造器中的super方法 里传参数   
	//参数：要和你想调用父类中的哪个有参数的构造器的想对应
	public test1111() {
		// TODO Auto-generated constructor stub
		//调用父类的构造器
		super(5);
	}
}
