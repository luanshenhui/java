package day01;
/**
 * 字符串常用方法2
 * @author Administrator
 *
 */
public class TestStringMethod2 {
	public static void main(String[] args) {
		/**
		 * 一本好书《java编程思想》
		 */
		//            0123456789012345
		String str = "Thinking in Java";
		//返回Java在str中的位置
		int index = str.indexOf("in");
		System.out.println(index);
		
		//从str第6个字符开始检索第一次出现in的位置
		index = str.indexOf("in",5);
		System.out.println("index=" + index);
		
		//从str中检索最后一次出现in的位置
		int last = str.lastIndexOf("in");
		System.out.println("last=" + last);
	
		//获取字符串中指定位置的字符
		char chr = str.charAt(5);
		System.out.println("chr:" + chr);
		
	}	

	
}








