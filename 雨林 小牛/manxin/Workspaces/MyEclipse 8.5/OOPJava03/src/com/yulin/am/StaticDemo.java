package com.yulin.am;

public class StaticDemo {
	public static void main(String[] args){
		Aoo a1 = new Aoo();
		Aoo a2 = new Aoo();
		System.out.println("a1.a="+a1.a+"; a2.a="+a2.a+"; a1.b="+a1.b+"; a2.b="+a2.b);
		
		a1.a=1;
		a1.b=1;
		System.out.println("a1.a="+a1.a+"; a2.a="+a2.a+"; a1.b="+a1.b+"; a2.b="+a2.b);
		
		System.out.println(Aoo.b);	//静态变量可以通过类名直接访问
		
		Aoo.add2();	//静态调用
		a1.add2();	//引用调用
	}

}

class Aoo{
	int a;
	static int b;
	
	public Aoo(){
		a=0;
	}
	
	public void add(){
		a++;
	}
	
	public static void add2(){
//		a++;	//静态方法中只能访问静态的成员变量
		b++;
//		add();	//静态方法中只能调用其他的静态方法
	}
}

