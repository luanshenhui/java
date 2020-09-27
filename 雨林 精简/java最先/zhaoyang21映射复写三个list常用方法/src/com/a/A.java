package com.a;

import java.lang.reflect.*;
import java.lang.Class;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Constructor;

public class A {

	public static void main(String[] args) {
		/*
		 * 反射：一种看透java的技术 java中一切皆对象，(类也是对象，成员变量也是对象，成员方法也是对象，构造方法也是对象。
		 * 反射都再java.lang.reflect.*)下 
		 * 1)类(java.lang.Class)
		 * 2)成员变量(java.lang.reflect.Field)
		 * 3)成员方法(java.lang.reflect.Method)
		 * 4)构造方法(java.lang.reflect.Constructor)
		 * 
		 * 应用场景：IDE开发工具：例如myeclipse，框架实现例如：Struts，Spring，Hiberbate。
		 * 
		 */

		try {
			// 通过包名+类名获取Class对象
			Class c = Class.forName("com.a.Person");
			// 获取成员变量的数组
			Field[] fr = c.getDeclaredFields();
			for (Field f : fr) {
				System.out.println(f);
			}
			Method[]mrr=c.getDeclaredMethods();
			for(Method m:mrr){
				System.out.println("     "+m);
			}
			//直接通过反射找构造方法
			Constructor[]carr=c.getDeclaredConstructors();
			for(Constructor cc:carr){
				System.out.println(cc);
			}
			//获取父类
			Class farther=c.getSuperclass();
			System.out.println(farther);
			
			Field[]f1= c.getSuperclass().getDeclaredFields();
			for(Field f:f1){
				System.out.println(f);
			}
			//获取接口
			Class[]cs=c.getInterfaces();
			for(Class cc:cs){
				System.out.println(cc.getConstructors());
			}
			

		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
