package com.yulin.am;

public class Member extends Person{
	public Member(){
		//隐藏调用父类的
		super("");
	}
	public Member(String name){
		super(name);
	}

}
