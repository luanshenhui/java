package day05;
/**
 * 内部类： 定义在类内部或者方法中 的类。
 *   内部类的主要目的是封装，限制类的定义范围
 *  内部类可以共享访问外部类的属性和方法
 */
public class Demo08 {
	public static void main(String[] args) {
		Koo k = new Koo();
		k.t();
	}
}
class Koo{
	int a = 8;
	public void t(){
		Foo f = new Foo();	f.test();
	}
	//内部类, 内部类可以共享外部类的属性 a
	class Foo{
		public void test(){
			System.out.println(Koo.this.a);//就是 Koo的a属性
		}
	}
}
