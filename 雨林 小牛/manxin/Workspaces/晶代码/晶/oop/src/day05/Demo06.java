package day05;
/**
 * 接口: 就是一种特殊抽象类, 全部方法都是抽象方法,
 *   全部属性都是常量.
 * 在业务逻辑上表示纯抽象概念.是理想的软件结构描述设计工具.
 * 1) 可以定义变量,引用子类实例
 * 2) 不能直接创建对象
 * 3) 只能被实现(一种继承关系) 
 * 4) 接口之间可以继承
 * 5) 类可以实现多个接口, 实现多继承关系
 * 
 * 
 */
public class Demo06 {
	public static void main(String[] args) {
		Cat tom = new Cat();
		//Hunter hunter = new Hunter();//编译错误,不能创建接口实例
		Hunter hunter = tom;
		Runner r = tom;
		r.run();
		hunter.hunt();
		//r.hunt();//编译错, r的类型Runner上没有定义hunt()方法
	}
}
//implements 实现, 实现接口要实现全部的抽象方法
// 猫实现了猎人, 猫是一种猎人, 也是能够跑的
class Cat implements Hunter, Runner{
	public int getSpeed() {
		return DEFAULT_SPEED;
	}
	public void hunt() {
		System.out.println("拿耗子");
	}
	public void run() {
		System.out.println("跑猫步");
	}
}
/** 可以跑的 */
interface Runner{
	//接口中的属性,只能是常量!
	/*public static final*/ int DEFAULT_SPEED = 100;
	//接口中声明的方法, 只能是抽象方法
	/*public abstract */ int getSpeed();//获取速度
	void run();//跑
}
/** 猎人 是可以跑的 */
interface Hunter extends Runner{
	void hunt();//打猎
}














