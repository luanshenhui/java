package day02;

import java.io.UnsupportedEncodingException;
import java.util.Arrays;
/**
 * 字符串编码
 * 将字符串按照指定的字符集进行编码。
 * @author Administrator
 * 在gbk编码中 一个汉字占两个字节 
 * 在utf-8中一个汉字占三个字节
 * 一个字母占一个字节
 */
public class StringEnCoding {
	public static void main(String[] args) 
	throws UnsupportedEncodingException {
		String str = "我爱java";
		/**
		 * 该方法要求调用者必须捕获一个异常
		 * 这个异常是：没有这个字符集
		 * 当我们字符串中写的字符集名称错误时会报这个错误
		 */
		byte[] data = str.getBytes("gbk");
		System.out.println(Arrays.toString(data));
		byte[] utfdata = str.getBytes("utf-8");
		System.out.println(Arrays.toString(utfdata));
		/**
		 * 将2进制数据转换为字符串
		 * 字符集名称不区分大小写
		 */
		
		String decodeStr = new String(utfdata,"UTF-8");
		
		System.out.println("解码后:"+decodeStr);
		String s = "jss";
		String s1 = new String(s.getBytes("iso8859-1"), "utf-8");
		
	}
}







