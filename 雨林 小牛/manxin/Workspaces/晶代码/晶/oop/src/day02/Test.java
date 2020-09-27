package day02;
/*
 * 构造器是什么时候调用的?
 * 当实例化对象的时候  由系统自己的调用了对应的构造器
 */
public class Test {
	public static void main(String[] args) {
		Test t = new Test();
		Test t1 = new Test(1);
	}
	public Test() {
		// TODO Auto-generated constructor stub
	}
	public Test(int a){
	
	}
}
