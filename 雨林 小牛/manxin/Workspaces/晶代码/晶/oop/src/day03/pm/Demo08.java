package day03.pm;
/*
 * ���غͲ����й�  ��д�Ͷ����й�
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