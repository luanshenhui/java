package day01;
/*
 * 类：一些具有共同特征的事物   被抽象成类
 * 在类里面 只有属性和方法
 * 面向对象：属性 有几个其他的名字 分别是？
 * 属性:特征   也叫 实例变量  成员变量
 * 方法：动作  就是你做一件事 你做了什么  eat sleep play 。。。。
 */
public class Person {
	int age;
	int height;
	char sex;
	//方法： 就是动作
	//方法的结构   public 方法的返回值类型  方法名字（）｛｝
	// 方法的返回值类型 一定要和return后的值的类型保持一致
	public int eat(){
		
		return 2;
	}
	public static void main(String[] args){
		//创建对象  实例化一个对象
		//？？ 成员变量并没有初始化  那么为什么可以使用
		//因为系统会为每一个类提供一个默认的无参数的构造器
		//构造器的作用就是初始化成员变量
		Person p = new Person();
		p.age = 1;
		p.eat();
	}
}
