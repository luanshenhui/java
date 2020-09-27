package day01;
/*
 * 总结:
碰到try语句中的return,那么先把return的值放在某个池中,
然后执行finally里面的代码块,
如果有返回值覆盖语句，就改变先前放在池中的那个值；
如果没有,就把那个池中的东西取出来返回出去。

简单来说就是
---------对待try、finally内有return语句的情况，
只有在finally覆盖return，才会改变返回值。
否则即使在最外层return新值，也不会改变原有的return值。
 * 
 * 
 * 结论4 ： 如果try、finally内已经有return，
 * 则外部的return不会起作用。
 */
public class Test4 {
	public static void main(String[] args) {
        System.out.print(tt());	
    }
	public static int tt() {
	    int b = 23;
	    try {
	        System.out.println("yes");
	        return b = 88;
	    } catch(Exception e) {
	        System.out.println("error : " + e);
	    } finally {
	        if (b > 25) {
	            System.out.println("b>25 : " + b);
	        }
	        System.out.println("finally");
	    }
	    return 100;
	}
}
