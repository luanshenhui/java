package day03;

public class Test2 {
//	public Test2() {
//		// TODO Auto-generated constructor stub
//	}
	public Test2() {
		// TODO Auto-generated constructor stub
	}
	public Test2(int a){
		
	}
	public Test2(int a,int b){
		
	}
	public static void main(String[] args) {
		Test2 t = new Test2(2);
		Test2 t2 = new Test2(2,2);
		//当写了一个有参数的构造器的时候 那么系统提供无参数的构造器就没了
		Test2 t1 = new Test2();
	}
}
