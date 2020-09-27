package day02;
/**
 * 重载的方法调用规则 
 * Java 根据参数类型，尽可能简单转换的原则 调用重载方法
 *                   （就近原则）
 */
public class Demo02 {
	public static void main(String[] args) {
		Foo foo = new Foo();
		foo.test(5.0);
		foo.test(5);
	}
	public Demo02() {
		// TODO Auto-generated constructor stub
	}
	public Demo02(int a){
		
	}
	
}
class Foo{
//	public void test(int a){
//		System.out.println("test(int)"); 
//	}
	public void test(double a){
		System.out.println("test(double)"); 
	}
	public void test(float a){
		System.out.println("test(float)"); 
	}
	public void test(long a){
		System.out.println("test(long)"); 
	}
}