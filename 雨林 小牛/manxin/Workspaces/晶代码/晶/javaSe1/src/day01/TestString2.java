package day01;
/**
 * String缓存字面量
 * 重复字面量是不会创建新对象的。
 * @author Administrator
 *
 */
public class TestString2 {
	public static void main(String[] args) {
		String str1 = "HelloWorld";
		String str2 = "HelloWorld";
		String str3 = new String("HelloWorld");
		/**
		 * jvm在编译源程序时，会在编译过程中，
		 * 对字面量计算的表达式先行计算，将结果替换表达式。
		 * 这样可以节省运行时的开销。
		 */
		String str4 = "Hello" + "World";
		/**
		 * 只要表达式有一方不是字面量，就不会再编译过程中计算
		 */
		String str5 = "Hello";
		String str6 = "World";
		String str7 = str5 + str6;
		System.out.println(str1 == str2);//引用同一对象		
		System.out.println(str1 == str3);//不是同一个对象
		System.out.println(str1.equals(str3));
		System.out.println(str1 == str4);//true
		System.out.println(str1 == str7);//false
		String str8 = "helloworld";
		//String的length和数组的length有什么区别？
		//string的length是方法  而数组的length是属性
		System.out.println(str8.length());
		System.out.println(str1 == str8);//false 不是同一对象
	  //false 内容不同，区分大小写
		System.out.println(str1.equals(str8));
		/**
		 * String自己独有的比较内容的方法
		 * 该方法比较字符串内容时忽略大小写
		 */
		System.out.println(str1.equalsIgnoreCase(str8));
		
	}
}
