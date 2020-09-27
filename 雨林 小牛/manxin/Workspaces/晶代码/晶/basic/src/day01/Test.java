package day01;
// boolean byte short char int float double long
//当小于int类型的整数类型 ，如果进行了运算  那么就是相当于进栈元算了
//此时此刻 返回的数据类型都是int类型
public class Test {
	public static void main(String[] args){
		int a1 = 1;
		int b1 = 2;
		int c1 = a1 + b1;
		byte a = 1;
		byte b = 2;
		//强制类型转换
		//大的类型转换成小的类型
		byte c =(byte)(a + b);
		char a2 = 1;
		char b2 = 2;
		char c2 = (char)(a1 + b2);
		short a3 = 1;
		short b3 = 2;
		short c3 = (short)(a3 + b3);
		
	}
}
