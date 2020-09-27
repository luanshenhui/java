package day03;
/**
 * 默认构造器现象
 * 抽象类  是类 但是不能创建抽象类的对象  但是也有构造器
 * 只要是类  就一定有构造器   
 * 1) Java 类一定有构造器!
 * 2) 如果类没有声明任何构造器,Java编译器自动添加默认无参数的构造器
 * 3) 如果类声明了构造器, Java编译器就不再添加任何默认构造器   
 * javaBean 规范
 */
public class Demo01 {
	public static void main(String[] args) {
		Foo f = new Foo();//调用的是默认构造器
		//Koo k = new Koo();//编译错, Koo 没有 Koo()构造器
		Koo k1 = new Koo(8);//调用Koo(int) 构造器
	}
}
class Foo{ //Foo(){} 默认构造器
}
class Koo{
	Koo(int a){	System.out.println("Koo(int)"); }
}



