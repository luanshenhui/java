package Test;
/*
 * static 静态的  可以修饰方法 可以修饰属性  可以修饰静态的代码快
 * 
 * static 修饰的方法和属性可以直接由类名调用  
 * 
 * 只有一份
 */
public class Test3 {
	static int a = 1;
	public static void main(String[] args) {
		Test3 t = new Test3();
		//t.a = 1;
		Test3.a = 1;
	}
	//作用步在于调用  在与加载
	static{
		//fjklsdjfklsdjfklsdjflk；
	}
}
