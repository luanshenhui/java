package day01;
/*
 * 结论3： 如果finally语句中没有返回语句覆盖的话，
 * 那么原来的返回值就不会变,不管你是不是改变了要返回的那个变量.
 * yes  finally 23
 */
public class Test3 {
	 public static void main(String[] args) {
	        System.out.print(tt());	
	    }
	public static int tt() {
		int b = 23;
		try {
			System.out.println("yes");
			return b;
		} catch (Exception e) {
			System.out.println("error:" + e);
		} finally {
			if (b > 25) {
				System.out.println("b>25:" + b);
			}
			System.out.println("finally");
			b = 100;
		}
		return b;
	}
}
