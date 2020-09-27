package com.yulin.am1;


	/*类：被class修饰的就是类，表示是图纸，模板
	 * 抽象类被abstract 修饰就是抽象类，描述的是一个抽象概念，比如图形类，动物类
	 * 
	 * 
	 */
	public abstract class A{
		
	//成员变量；抽象类中成员变量和类中抽象变量没有区别
		private String name;
	//成员方法；抽象类中实现的方法和类中没有区别
		public void m() {
			System.out.println();
		}
		//抽象方法；被abstract修饰并且没有方法体的方法叫抽象方法
		public abstract void m2();
		//类与抽象方法的关系；抽象类中不一定有抽象方法。包含抽象方法的类一定是抽象类
		
	//构造方法；抽象类中有构造方法
		public A(){
			
		}
public static void main(String[] args) {
	//A a=new A();//构造方法虽然有，但不能创造对象(因为抽象类表示的是一个概念)
	//作用，初始化(初始化子类成员)
}
}
