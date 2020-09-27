package day05.abs;
/*
 * 抽象方法一定在抽象类里面
 * 那么你不说接口里都是抽象方法吗？  接口是一种特殊的抽象类
 *   但是抽象类不一定有抽象方法
 *   抽象类里面可以常量 可以有变量  可以抽象方法  可以有普通方法
 *   接口  只能有常量  只能抽象方法
 *   接口是一种特殊的规范
 *   抽象类有构造器 为什么？ 因为抽象类有变量  需要构造器来初始化
 *   接口没有构造器 为什么？接口中都是常量
 *   接口和抽象类都不能实例化  为什么？  因为他们俩里面都有抽象方法
 *   抽象方法没有方法体  这样调用方法没有任何意义
 *   抽象类一定被继承  为什么?   多态：
 *   接口一定被实现
 *   
 *   现在你的感觉是 好像是抽象类包含了接口
 *   为什么要有接口  还定义一个抽象类呢？
 *   为什么要设计接口和抽象类呢？
 *   习近平 接口  李克强 抽象类
 */
public interface Demo {
	public abstract int a();
	public abstract int a1();
	public abstract int a2();
}
interface Demo1{
	
}
abstract class A implements Demo,Demo1{

	@Override
	public int a() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int a1() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int a2() {
		// TODO Auto-generated method stub
		return 0;
	}
	
}
class B extends A{
	
}