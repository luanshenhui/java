package day02;

public class Test1 {
	int a = 1;
	public static void main(String[] args) {
		// 在static修饰的方法中 不可以使用非静态的属性
		//a = 2;
	}
	
	public void main1(String[] args){
		a = 2;
	}
}
