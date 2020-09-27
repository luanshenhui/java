package com.a;

import java.lang.reflect.*;
import java.lang.Class;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Constructor;

public class A {

	public static void main(String[] args) {
		/*
		 * ���䣺һ�ֿ�͸java�ļ��� java��һ�нԶ���(��Ҳ�Ƕ��󣬳�Ա����Ҳ�Ƕ��󣬳�Ա����Ҳ�Ƕ��󣬹��췽��Ҳ�Ƕ���
		 * ���䶼��java.lang.reflect.*)�� 
		 * 1)��(java.lang.Class)
		 * 2)��Ա����(java.lang.reflect.Field)
		 * 3)��Ա����(java.lang.reflect.Method)
		 * 4)���췽��(java.lang.reflect.Constructor)
		 * 
		 * Ӧ�ó�����IDE�������ߣ�����myeclipse�����ʵ�����磺Struts��Spring��Hiberbate��
		 * 
		 */

		try {
			// ͨ������+������ȡClass����
			Class c = Class.forName("com.a.Person");
			// ��ȡ��Ա����������
			Field[] fr = c.getDeclaredFields();
			for (Field f : fr) {
				System.out.println(f);
			}
			Method[]mrr=c.getDeclaredMethods();
			for(Method m:mrr){
				System.out.println("     "+m);
			}
			//ֱ��ͨ�������ҹ��췽��
			Constructor[]carr=c.getDeclaredConstructors();
			for(Constructor cc:carr){
				System.out.println(cc);
			}
			//��ȡ����
			Class farther=c.getSuperclass();
			System.out.println(farther);
			
			Field[]f1= c.getSuperclass().getDeclaredFields();
			for(Field f:f1){
				System.out.println(f);
			}
			//��ȡ�ӿ�
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
