package day04;
/**
 * final 的方法，不能在子类中重写！
 * 1）阻止了子类重写，也就阻止了子类的修改
 * 2）很少使用，影响动态代理技术（继承并重写所有方法） 
 */
public class Demo05 {
	public static void main(String[] args) {
	}
}
class Super{
	public final void t1(){	}
	public void t2(){}
}
class Sub extends Super{
	//public void t1() {//编译错误，不能重写final方法
	//}
	public void t2() {	}
}



