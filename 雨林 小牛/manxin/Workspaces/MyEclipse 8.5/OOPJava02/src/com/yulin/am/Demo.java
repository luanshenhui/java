package com.yulin.am;

public class Demo {
	public static void main(String[] args){
		Aoo aoo = new Aoo();		
		System.out.println("a:"+aoo.a);
		System.out.println("b:"+aoo.b);
		
		aoo.add(aoo);
		aoo.add(aoo.b);		
		System.out.println("a:"+aoo.a);
		System.out.println("b:"+aoo.b);
	}
	
}

class Aoo{
	int a=0;
	int b=0;
	
	public void add(int i){
		i += 1;
	}
	
	public void add(Aoo aoo){
		aoo.a += 1;
	}
}
