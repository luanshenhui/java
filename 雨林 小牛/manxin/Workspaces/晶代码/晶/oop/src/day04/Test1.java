package day04;
/*
 * final 修饰的类不可以被继承
 * final 修饰的变量 初始化不能被再次修改
 * final 修饰的方法 不可以被重写
 * 
 * 如果子类里的方法重写了父类里的方法  那么有一点是必须要记住的
 * 子类的方法的修饰词的作用域要大于等于父类方法的修饰词
 */
public class Test1 {
	public void test(){
		
	}
}
class b extends Test1{
	public void test(){
		
	}
}
