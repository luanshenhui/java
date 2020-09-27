package day03;
/**
 * 栈  里面存储的是基本数据类型和引用变量  内存相对于堆来说较小 有序的 
 * 先进后出 后进先出的原则 
 * 堆  无序 且内存很大  存储对象
 * 
 * 重写的方法是动态绑定到对象类型的方法
 * 重写: 子类中声明与父类同名,同参数的方法(一样的方法)
 *   目的是子类修改父类的行为(功能) ! 
 *   修改以后,执行的是子类对象的方法! 父类的方法失效了
 *   对象类型是父类行, 执行的是父类的方法
 */
public class Demo07 {
	public static void main(String[] args) {
		Super obj = new Sub();
		obj.test(5);
		obj = new Super();
		obj.test(5);
	}
}
class Super{//鸟
	public void test(int a){//飞翔
		System.out.println("Super test(int)");
	}
}
class Sub extends Super{//企鹅
	public void test(int a) {//飞翔被重写为游泳
		System.out.println("Sub test(int)"); 
	}
}
