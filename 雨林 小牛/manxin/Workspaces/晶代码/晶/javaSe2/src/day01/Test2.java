package day01;
/*
 * 结论2：这样又说明了一个问题,finally语句块里面的return
 * 把原来的return给覆盖了，变成了新的返回值了.
 * yes  b>25 111  final  100
 */
public class Test2 {
	 public static void main(String[] args) {
	        System.out.print(tt());	
	    }
	 public static int tt() {
	        int b = 23;
	        try {
	            System.out.println("yes");
	            return b += 88;
	        } catch(Exception e) {
	            System.out.println("error:" + e);
	        } finally {
	            if (b > 25) {
	                System.out.println("b>25:" + b);
	            }
	            System.out.println("finally");
	            return 100;
	        }
	    }
}
