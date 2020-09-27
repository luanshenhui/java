package day03;
/*
 * 构造器的本类调用
 */
public class Test4 {
	public Test4() {
		// TODO Auto-generated constructor stub
		//this 调用的是本类其他的构造器  也是必须放在第一行 
		//不能和super同时存在
		this(1,2);
	}
	
	public Test4(int a, int b){
		System.out.println("我也孟了");
	}
	public Test4(int a){
		System.out.println("我是本类构造器");
	}
	public static void main(String[] args) {
		Test4 t = new Test4();
	}
}
