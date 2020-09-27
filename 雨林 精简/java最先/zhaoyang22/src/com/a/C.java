package com.a;

import java.util.HashSet;
import java.util.Set;

public class C {
	public static void main(String[] args) {
		//3)泛型类，集合的应用
		Com <Men>com=new Com<Men>("IBM");
		com.add(new Men("张三"));
		com.add(new Men("李四"));
		
		Com <Person>com1=new Com<Person>("IBM");
		com1.add(new Person("张三",30));
		com1.add(new Person("李四",30));
		
		com.printALl();
	}

}
