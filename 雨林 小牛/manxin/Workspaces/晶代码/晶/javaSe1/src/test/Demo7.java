package test;

public class Demo7 {
	public static void main(String[] args) {
		//现在想调用add这个方法  那么在add前面没有static修饰  所以不可以直接调用
		// 那么现在想调用 怎么办呢？
		//java是一种面向对象的语言  什么叫面向对象  
		/*
		 * 解释面向对象这四个字   面向 朝向 针对   对象 东西 个体
		 * 在java 一切都是由对象发起的  由对象来操作方法
 		 */
		//先创建一个对象  此时 a就是创建的一个对象
		//类名  对象名  = new 类名（）；
		Demo7 a = new Demo7();
		int z = a.add(1, 2);
		System.out.println(z);
		a.fang(2);
	}
	
	public int add(int a,int b){
		int c = a + b;
		return c;
	}
	//方法的返回值为空 void  除了void 那么所有的方法的里面都要有return
	public void fang(int qiu){
		System.out.println("ssss");
		System.out.println(1);
	}
}
