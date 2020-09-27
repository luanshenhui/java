package day06;
/**
 * 单例模式
 * 单例步骤:
 * 1:私有化构造方法
 * 2:定义静态的获取当前类型实例的方法
 * 3:定义私有的静态的当前类型实例并初始化
 * 单例模式就是为了每次调用方法都会返回同一个对象
 * 
 * 现在的单例模式  基本都用工厂类来代替     
 * 一些框架 已经实现了单例模式  所以很少自己去写单例模式
 * @author Administrator
 *
 */
public class Singleton {
	//private修饰的东西 作用域在本类中
	//static修饰的  可以由类名直接调用  在本类中可以直接  类名可以省略
	private static Singleton singleton = new Singleton();
	//私有化构造方法
	private Singleton(){
		
	}
	//定义一个静态的可以获取当前类型实例的方法
	public static Singleton getSingleton(){
		return singleton;
	}
}


