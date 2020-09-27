package com.a;

public class Text {

	public static void main(String[] args) {
		//客户端
		
	//	Car/*Audi*/ car=new Audi();
//		car.driver();
		
		//1类型转换(父类和子类之间的类型转换)
		
	//身份/类型	 变量/标示符=new
		/*   Audi audi=new Audi();
		
		//子类转父类
		Car car=audi;//子类型赋给父类型，一定时安全的
		//父类往子类转，需要强制类型转换
		Audi a=(Audi)car;    */
	//	Benz b=(Benz)car;//这个报错
		//为了防止类型转换异常，需要使用instanceof运算符号
		//如果car是Audi的对象则为true，否则是false
		Car car=new Audi();
		if(car instanceof Audi){
			Audi audi=(Audi)car;
		}
		//继承关系下的初始化顺序//
		//一个类是，静态》非静态》构造方法
		//继承关系则是。父类静态》子类静态》父类非静态》父类构造》子类非晶态》子类构造
	}
//final修饰变量表示常量(声明的同时，必须初始化)
	//final 修饰类表示恒定不变的类，不能派生子类被继成
	//final 修饰的方法不能被复写
}
