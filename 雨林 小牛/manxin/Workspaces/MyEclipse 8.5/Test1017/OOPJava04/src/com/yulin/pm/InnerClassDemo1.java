package com.yulin.pm;
import com.yulin.pm.Wo.No;	//外部类相当于内部类的一个包
import com.yulin.pm.Wo.Sno;
public class InnerClassDemo1 {

	/**
	 *内部类和外部类的应用
	 */
	public static void main(String[] args) {
//		No no = new No();	//在其他类中无法直接创建内部类的实例
		Wo wo = new Wo();
		No no = wo.new No();	//内部类需要通过外部类的对象来创建对象
		no.no();	//可以通过引用来调用内部类的方法
		
		Sno sno = new Sno();	//静态内部类可以直接创建实例
		sno.sno();
	}

}
class Wo{
	int a = 0;
	No no = new No();	//在外部类中创建一个内部类的实例，用来使用其中的方法
	
	public void wo(){
		no.no();
		System.out.println("我是外部类的方法");
	}
	class No{
		public void no(){
			System.out.println(a);
//			wo();	//成员内部类可以访问外部类中的方法和属性
		}
	}
	static int sa = 0;
	static class Sno{
		public void sno(){
			System.out.println(sa);		//静态内部类只能调用静态的属性和方法
		}
	}
}

