package day03.pm;

import day03.pm.sub.Koo;

/**
 *             类内     包内    子类      其他
 * public       v 	  v    v     v
 * protected    v     v    v 
 * default      v     v     
 * private      v
 * 访问修饰词
 * Java 建议私有属性公有的属性访问方法 
 * 类的属性必须使用private  实体类   就是和表一一对应的那个类
 * 这个类里面必须的使用private  并且添加get set 方法
 */
public class Demo11 {
	public static void main(String[] args) {
		Noo noo = new Noo();
		System.out.println(noo.a);//5, 公有可见 
		//System.out.println(noo.b);//编译错误, b 不可见
		System.out.println(noo.getB());//6
		System.out.println(noo.c);//8, 同package 可见
		System.out.println(noo.d);//10  同package 可见
		
		Koo koo = new Koo();
		//day03.pm.sub.Koo k = new day03.pm.sub.Koo();
		System.out.println(koo.a);//5 可以
		//System.out.println(koo.b);//私有 不可见
		//System.out.println(koo.c);//默认的, 不同包不可见
		//System.out.println(koo.d);//保护的, 不同包不可见
		Xoo xoo = new Xoo();
		xoo.test();
	}
}
class Xoo extends Koo{//Koo 类声明在 day03.pm.sub包中
	public void test(){
		//super 是对父类型对象的引用, 可以访问父类型属性/方法
		//一般情况下可以省略, 也可以不省略
		System.out.println(super.a);//a   
		//System.out.println(b);//私有,子类不可见
		//System.out.println(c);//默认的, 不同包 不可见
		System.out.println(d);//保护的, 子类中可见
	}
}

class Noo{
	public int a = 5;//公有的
	private int b = 6;//私有的
	int c = 8;//默认访问修饰,在当前包(package)中有效
	protected int d = 10;//保护的属性: 当前包,和子类中 
	public int getB(){
		return b;
	}
}