package day03;
/**
 * 构造器是不可继承的   其实是继承了的 但是呢 有一个可见性的问题  导致
 * 了继承的时候发生了编译错误
 */
public class Demo02 {
	public static void main(String[] args) {
		Hoo h1 = new Hoo();//调用的是 Hoo类的默认构造器
		//Hoo h2 = new Hoo(8);//编译错, Hoo类中没有Hoo(int) 
		//说明 Hoo 没有继承 Goo(int) 构造器
	}
}
class Goo{
	int a;
	Goo(){}
	Goo(int a){	System.out.println("Goo(int)");	}
}
class Hoo extends Goo{
	
}