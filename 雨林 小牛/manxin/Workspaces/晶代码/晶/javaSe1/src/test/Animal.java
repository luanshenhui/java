package test;
/*
 * java有很多特点  多线程  面向对象  跨平台 ，，，，
 * 面向对象：针对于    对象来操作  一切的起点  都是由对象来开始的
 * 假如你想去吃饭  那么必须有一个你这个人   这个人才可以吃饭
 * 
 * 类：什么叫类   具有一些特征的事物 放到了一起
 * 类里面有什么？  只有两种  属性 和 方法
 * 属性：能描述一个或者一类事物特征的词语  (成员变量 实例变量)
 * 方法：就是动作   也就是说 属性组成的对象来调用方法  （属性组成了个体 然后个体能干什么）
 */
public class Animal {
	int big;
	int small;
	int eye;
	public void eat(){
	}
	public static void sleep(){
	}
	public static void main(String[] args) {
		//这个人怎么去创建呢？
		Animal huahua = new Animal();
		huahua.eat();
		huahua.big = 1;
		//由static修饰的方法或者属性我们步需要使用对象来调用  我们要使用的是类名。属性或者方法
		Animal.sleep();
	}
}
