package com.yulin.am;

public class StaticDemo2 {
	public static void main(String[] args){
		new Soo();
	}

}
class Foo{
	{
		System.out.println("Foo.ono-static...");
	}
	static{
		System.out.println("Foo.static...");
	}
	
	public Foo(){
		System.out.println("Foo...");
	}
}
class Soo extends Foo{
	{
		System.out.println("Soo.non-static...");
	}
	static{
		System.out.println("Soo.static...");
	}
	public Soo(){
		System.out.println("Soo...");
	}
}