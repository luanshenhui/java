package day01;
/**
 * 测试String类
 * 该类实例为不变对象
 * @author Administrator
 * String是一个非标准的经过优化的类
 * String 是一个final类 不可以被继承  底层维护的是字符数组
 *
 */
public class TestString {
	public static void main(String[] args) {
		String str1 = "Hello";
		String str2 = str1;
		String str3 = "World";
		str1 += str3;
		System.out.println(str1);
		System.out.println(str2);
		System.out.println(str3);
	}
}




