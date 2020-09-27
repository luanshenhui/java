package day02;
/**
 * String方法
 * @author Administrator
 *
 */
public class StringMethodDemo {
	public static void main(String[] args) {
		//            0123456789012345
		String str = "Thinking in Java";
		/**
		 * 截取字符串。
		 * 切两刀取中间
		 */
		String sub = str.substring(9,11);
		System.out.println("sub:["+sub+"]");
		
		/**
		 * 重载方法
		 * 切一刀取后边
		 */
		String sub2 = str.substring(9);
		System.out.println("sub2:["+sub2+"]");
		
	}
}





