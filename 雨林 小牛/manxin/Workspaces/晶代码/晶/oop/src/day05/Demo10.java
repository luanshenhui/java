package day05;
/**
 * 匿名内部类:  
 *开发中不可能用自己定义的类来使用匿名内部类的结构 
 *而是有的系统提供的工具类来使用匿名内部类
 */
public class Demo10 {
	public static void main(String[] args) {
		Xoo xoo = new Xoo();//创建Xoo的实例，“创建对象”
		Xoo x1 = new Xoo(){};//创建Xoo的“匿名子类实例”
		//new Xoo(){}是继承Xoo，并立即创建了子类实例
		//其中 {} 是子类的类体，{}中可以使用类的语法
		//匿名内部类的优点：创建子类的语法非常紧凑！简洁！
		//如果你想使用匿名内部类 那么你new后面只能是父类或者接口
		Xoo x2 = new Xoo(){
			public void test(){//重写父类的方法
				System.out.println("x2 test"); 
			}
		};
		x2.test();//输出重写以后的结果
		//Yoo yoo = new Yoo();//编译错误，不能创建接口实例
		Yoo yoo = new Yoo(){};// 木有问题，这是创建匿名类实例
		//Woo woo = new Woo(){};//编译错。没有实现抽象方法
		Woo woo = new Woo(){
			public void test() {//是声明方法，并执行
				System.out.println("woo test");
			}
		};
		woo.test();//调用了test方法
	}
}
interface Yoo{
}
interface Woo{
	void test();
}

class Xoo{
	public void test(){
		System.out.println("Xoo test()");
	}
}


