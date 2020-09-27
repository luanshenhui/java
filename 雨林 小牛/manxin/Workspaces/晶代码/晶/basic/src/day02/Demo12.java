package day02;
/**
 * 字符串连接运算 +  
 * Java 中唯一"重载"的运算符是“+”：同名，但实际是两种功能
 *  类似于： 打车   打酱油    打扑克 
 *  + 两端数值，就进行 加法运算 
 *  + 两端是字符串，就进行 字符串连接
 *  只要是+两端中的一端有字符串 那么结果就是字符串
 */
public class Demo12 {
	public static void main(String[] args) {
		System.out.println(1 + '0');//49
		System.out.println(1 + "0");//10
		System.out.println(1 + "0" +'0');//490
	}
}
