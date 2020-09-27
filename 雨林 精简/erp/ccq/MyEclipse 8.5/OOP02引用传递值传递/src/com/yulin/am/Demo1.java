package com.yulin.am;

public class Demo1 {
public static void main(String[] args){
	Aoo aoo=new Aoo();
	
	//System.out.println(aoo.a);
	//System.out.println(aoo.b);
	Aoo aoo1=aoo;
	//aoo1.a=1;
	//System.out.println(aoo.a);
	//aoo.add(aoo.b);
	aoo.add(aoo);
	System.out.println(aoo.s);
	System.out.println(aoo.b);
}
}
class Aoo{
	int s=0;
	int b=0;
	
	public void add(int i){
		i+=1;
	}
	public void add(Aoo aoo){
		aoo.s+=1;
	}
}
