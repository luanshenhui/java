package test;
/*
 * 在一个。java的文件中   主方法一定在public的类中
 * 面向对象  
 * 类 在一个类里面只有两种东西   属性（成员变量  实例变量）   方法
 * 属性  能描述一个东西的特征
 */
public class Person {
	//属性
	int eye;
	static int lege;
	//方法  对象能干啥
	public void eat(){
		
	}
	public int add(int a,int b){
		int c  = a + b;
		return c;
	}
	public static void drink(){
		
	}
	public static void main(String[] args) {
		//对象调用方法或者属性
		Person yujiawen = new Person();
		yujiawen.eat();
		yujiawen.add(1, 2);
		yujiawen.eye = 32;
		yujiawen.lege = 2;
		//由static修饰的属性或者方法  直接由类名调用  否则由对象调用
		Person.drink();
		Person.lege = 3;
	}
}
