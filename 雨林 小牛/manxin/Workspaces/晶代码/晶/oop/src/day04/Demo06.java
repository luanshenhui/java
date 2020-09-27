package day04;
/**
 * final 的变量
 * 1) final的变量，只能初始化，不能"再"修改的变量
 */
public class Demo06 {
	public static void main(String[] args) {
		final int a;//声明/定义 局部变量 
		int b;
		a = 5;//初始化
		b = 5;
		//a = 8;//编译错误，不能再修改！
		b = 8;
		test(6,8);
	}
	public static void test(final int a, int b){
		//a = 5;//编译错 
		b = 6;
		System.out.println(a+","+b);
	}
}









