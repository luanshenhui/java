package day03;
/**
 * 构造器之间的调用的 有两种情况   1：子类和父类之间调用 
 * 						   2：本类之间的构造器的调用
 * 子类一定调用父类构造器!  
 * 1) 默认情况下, 子类构造器调用父类无参数构造器
 * 2) 如果父类没有无参数构造器,子类必须使用super() 调用
 *  父类的构造器.
 *  super:超级, Super Man,  
 *  super() 在子类构造器的第一行使用, 调用父类构造器
 *  默认时编译自动添加!    
 */
public class Demo03 {
	public static void main(String[] args) {
		//为什么会输出Noo 
		/*
		 * 当子类继承父类的时候  那么子类的无参数的构造器里有一行
		 * 代码 是super（） 这个方法的作用是什么呢？  调用
		 * 父类的无参数的构造器
		 */
		Moo moo = new Moo();
		// 输出结果: A.编译错   B.运行异常   C.无   D.Noo()
	}
}
//构造器方法不能被继承 构造器的方法名字与类名一样
//Moo继承Noo 
class Noo{
//	public Noo() {
//		// TODO Auto-generated constructor stub
//	}
	//public Noo() {System.out.println("Noo()");	}
	public Noo(int a){
		
	}
}
//我现在实例化了moo的对象  可以 那么证明 moo是有一个无参数的构造器
class Moo extends Noo{
	public Moo() {
		// TODO Auto-generated constructor stub
		//他的作用是调用父类的无参数的构造器
		/*
		 * 选择super代码错了 他在父类没有找到无参数的构造器
		 * 解决的办法有两个
		 * 1 在父类添加一个无参数的构造器
		 * 2 在super这个方法里 添加父类已经有的构造器参数
		 * super这个方法  很叼  必须放在构造器的第一行
		 */
		super(5);
	}
	//Moo(){/*super();*/}
}





