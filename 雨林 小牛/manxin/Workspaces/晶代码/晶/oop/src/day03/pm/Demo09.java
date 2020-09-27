package day03.pm;
/**
 * 重写的方法是根据对象类型调用对应的方法 
 * 私有方法不能被子类重写! 
 * 继承  子类会继承父类的所有的东西  但是因为可见性的原因 有private修饰的
 * 东西就使用不了
 */
public class Demo09 {
	public static void main(String[] args) {
		Foo f = new Koo();
		f.t();
	}
}
//方法的调用者是显示的是引用类型 但是如果有重写的这个形式出现 
//那么会根据对象来操作
class Foo{
	public void t(/*Foo this*/){this.test();this.test2();}
	private void test(){System.out.println("Foo test()");}
	public void test2(){System.out.println("Foo test2()");}
}
class Koo extends Foo{
	public void test(){System.out.println("Koo test()");}
	public void test2(){System.out.println("Koo test2()");}
}

