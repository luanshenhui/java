package test;

public class Demo11{
	public Demo11() {
		System.out.println("demo11");
	}
	public static void main(String[] args) {
		b b =new b();
	}
	//������ֻ�ܵݹ����
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
