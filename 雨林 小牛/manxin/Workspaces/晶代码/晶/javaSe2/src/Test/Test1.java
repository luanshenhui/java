package Test;
/*
 * 局部变量 和 属性 （实例变量  成员变量 ） 问题
 * 成员变量 不需要初始化   局部变量必须初始化后才可以使用  答案
 * 为什么？
 * 因为成员变量是由构造方法初始化的  跟我们自己写代码是无关的。。。
 */
public class Test1 {
	int a;
	public void test(){
		System.out.println(a);
	}
	
	//构造器的作用：初始化成员变量
	public Test1() {
		// TODO Auto-generated constructor stub
	}
}
