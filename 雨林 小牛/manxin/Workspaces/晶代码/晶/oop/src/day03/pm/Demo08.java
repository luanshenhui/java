package day03.pm;
/*
 * 重载和参数有关  重写和对象有关
 */
public class Demo08 {
	public static void main(String[] args) {
		Goo goo = new Goo();
		Super obj = new Sub();
		goo.test(obj);
 	}
}
class Super{	
	public void t(){System.out.println("Super t()");}
}
class Sub extends Super{
	public void t(){System.out.println("Sub t");}
}
class Goo{
	public void test(Super obj){
		System.out.println("test(Super)"); obj.t();
	}
	public void test(Sub obj){
		System.out.println("test(Sub)"); obj.t();
	}
}