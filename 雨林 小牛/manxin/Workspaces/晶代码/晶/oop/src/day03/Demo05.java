package day03;
/**
 * 继承时候, java 对象的初始化过程
 * 1) 递归加载类
 * 2) 递归分配空间
 * 3) 递归调用构造器
 * 4) 返回对象的引用
 * 顺序执行顺序  
 * 构造器是什么时候调用的？ 当实例化对象的时候  系统自动的调用了对应的构造器
 */
public class Demo05 {
	public static void main(String[] args) {
		Zoo z = new Zoo();
		System.out.println(z.a+","+z.b+","+z.c); 
		//10 6 6 
	}
}
class Xoo{
	int a = 0;
	public Xoo() { a = 10; }
}
class Yoo extends Xoo{
	int b = 2;
	public Yoo() {super(); a=5;b=6;}
}
class Zoo extends Yoo{
	int c = 5;
	public Zoo() { super(); a=8;b=9;c=6;}
}





