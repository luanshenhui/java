package day03.pm.sub;

public class Koo {
	
	public int a = 5;//公有的
	private int b = 6;//私有的
	int c = 8;//默认访问修饰,在当前包(package)中有效
	protected int d = 10;//保护的属性: 当前包,和子类中 
	
	public int getB(){
		return b;
	}
}
