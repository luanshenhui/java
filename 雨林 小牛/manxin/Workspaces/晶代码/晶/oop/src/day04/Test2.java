package day04;
/*
 * abstract是抽象的意思  与抽象类对应的是什么接口
 * 抽象类 有构造器  但是不能实例化抽象类的对象 为啥？--
 * 因为抽象类可能有抽象方法  这样实例化对象之后调用抽象方法就没有意义
 * 因为抽象方法没有方法体
 * 抽象类一定被继承（他一定有子类）  为啥---
 * 因为不能实例化抽象类的对象 这样 方法的定义就没意义 所以要在子类
 * 中去完成方法的实现
 * 子类一定实现抽象类中所有的抽象方法
 * 抽象类中可有普通的变量  可以有常量
 * 可以有普通方法  可以有抽象方法
 * 
 */
public abstract class Test2 {
	public Test2() {
		// TODO Auto-generated constructor stub
	}
	public static void main(String[] args) {
		//Test2 t = new Test2();
	}
	int a =1;
	//常量  系统规定的或者自己定义的  常量的命名 必须全是大写
	public static final int A = 2;
	public static final double PI = 3.141592628;
	//普通方法
	public void test(){}
	//抽象方法  相当于人家给下了一个命令 但是需要子类去实现
	//抽象方法没有方法体  由abstract修饰
	public abstract void test1();
}
//要是继承了抽象类  那么你就必须实现抽象类中所有的抽象方法
//子类是小兵  父类的抽象方法相当于命令  一旦继承了抽象类 那么
//小兵 就必须得实现抽象方法
class b2 extends Test2{

	@Override
	public void test1() {
		// TODO Auto-generated method stub
		
	}
	
}

