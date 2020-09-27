package test;

public class Demo11{
	public Demo11() {
		System.out.println("demo11");
	}
	public static void main(String[] args) {
		b b =new b();
	}
	//构造器只能递归调用
}
class a extends Demo11{
	public a() {
		System.out.println("a");
	}
}
class b extends a{
	public b() {

	}
}
