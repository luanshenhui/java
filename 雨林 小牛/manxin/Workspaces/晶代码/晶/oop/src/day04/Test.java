package day04;
//static修饰属性的时候 可以直接由类名调用
//static修饰方法的时候 可以直接由类名调用  在本来中如果想调用
//那么可以直接写方法的名字  因为前面的类名可以省略
//static 不能修饰类
public class Test {
	static int a = 1;
	public static void test(){
		
	}
	public static void main(String[] args) {
		Test.a = 2;
		Test.test();
		test();
	}
}
class test11{
	public void test1(){
		//test();
	}
}
