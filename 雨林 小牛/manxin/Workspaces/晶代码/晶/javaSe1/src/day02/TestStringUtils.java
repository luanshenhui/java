package day02;

import org.apache.commons.lang3.StringUtils;

/**
 * 使用commons-lang.jar中的StringUtils
 * 
 * @author Administrator
 *
 */
public class TestStringUtils {
	public static void main(String[] args) {
		String str = "hello";
		/**
		 * String repeat(String str,int repeat)
		 * 将给定的str字符串重复指定次后返回
		 */
		String repeat = StringUtils.repeat(str, 10);
		System.out.println(repeat);
		
		
		/**
		 * String join(Object[] array,String separator)
		 * 将给定的数组中的每个对象的toString返回值用给定的
		 * separator连接成一个字符串后返回
		 * 
		 * join方法和String提供的split是个反向操作
		 */
		String[] arrays = {"abc","def","ghi"};
		String join = StringUtils.join(arrays,",");
		System.out.println(join);
		
		
		/**
		 * String leftPad(String str,int size,char padChar)
		 * 将给定的字符串左面补充padChar字符，直到字符串达到size
		 * 长度为止。
		 */
		String leftPad 
							= StringUtils.leftPad("hello", 10,'*');
		System.out.println(leftPad);
		
		/**
		 * String rightPad(String str,int size,char padChar)
		 * 
		 */
		String rightPad 
							= StringUtils.rightPad("hello",10,'*');
		System.out.println(rightPad);
	}
}







