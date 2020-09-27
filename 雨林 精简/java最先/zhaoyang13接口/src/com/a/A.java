package com.a;

public interface A extends B,C {
	/*1被interface修饰叫接口
	 *2成员变量 ；默认天生就是 public static final修饰
	 *3没有构造方法，不能创建对象
	 *4方法全是抽象的方法，不能实现，默认天生为public abstract修饰
	 /*//*5不能继承因为final XX
	 *6类和抽象类的关系，继成(每个类只能有一个直接父类)(“同类的可以相互继成”)
	 *7接口和接口的关系；继成(接口可以同时继成多个父类)(“为了解决java不能多继成的问题”)
	 *8类(包括抽象)和接口之间的关系implements
	 *9开发中常见的模式：“类”继成“抽象类”再实现多个“接口”
	 *10首先面向接口做开发，再面向抽象类(父类)做开发，最后再面向类做开发。
	 *11面向对象语言的三大特征：封装，继成，多态。
	 *多态
	 *1类内部多态(重载)；在一个类的内部，如果有多个方法名相同，参数列表不同，叫做重载。(例如构造方法，)
	 *2继成中的多态(复写)；在父类和子类中，如果有2个方法的方法签名完全相同，则会自动调用子类的方法叫~~(例如tostring())
	 *开发中最常见的复写指的是接口的应用。!!!!
	 */
	
	public static final int a=2;
	int b=3;

	public abstract boolean ma(int a,int b);
	
	void m();

	boolean ma();

}
