package day05;

import java.util.Arrays;
/**
 * final 修饰的变量不能再修改了
 * final引用类型的引用值（地址值）不能再改变，也就是
 * 不能改变引用关系了。但是被引用的对象属性可以更改 
 */
public class Demo01 {
	public static void main(String[] args) {
	  final int a = 5;//变量a的值不能再次修改
	  //ary 是引用变量，值是地址值，通过地址间接引用了 数组
	  final int[] ary = {5,6};//变量ary的值不能再改了
	  //ary = new int[3];//编译错误
	  ary[0]+=3;
	  System.out.println(Arrays.toString(ary));//8 6
	  final Foo f = new Foo();
	  //f = null;//编译错误
	  f.a = 9;
	}
}
class Foo{
	int a = 8;//final a = 8;
}





