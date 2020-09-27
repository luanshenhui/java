package com.a;

public class A {

	/**
	 * 嵌套类：可以在类中定义类
	 *    静态嵌套类static：开发种很少用
	 *    非静态嵌套类：内部类一般指这种
	 *          1：成员内部类
	 *          2：局部内部类：方法里面定义
	 *          3：匿名内部类
	 *          
	 *在一个文件里可以定义多个类，但只能有一个public修饰并和文件名相同          
	 *          
	 */
	
	static class B{
		
	}
	
	class C{
		
	}
	
	public void m(){
		class D{
		}
		D d=new D();//③对象
	}
	public static void main(String[] args) {
		//① 创建静态嵌套类对象
		A.B b=new A.B();//？有类就能创建对象A,静态类调用
		
		
		//②创建非静态套嵌类
		A a=new A();//非晶态要先创建对象
		A.C c=a.new C();
	}

}
