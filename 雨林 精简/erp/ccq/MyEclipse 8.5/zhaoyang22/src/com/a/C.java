package com.a;

import java.util.HashSet;
import java.util.Set;

public class C {
	public static void main(String[] args) {
		//3)�����࣬���ϵ�Ӧ��
		Com <Men>com=new Com<Men>("IBM");
		com.add(new Men("����"));
		com.add(new Men("����"));
		
		Com <Person>com1=new Com<Person>("IBM");
		com1.add(new Person("����",30));
		com1.add(new Person("����",30));
		
		com.printALl();
	}

}
