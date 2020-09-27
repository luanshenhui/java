package day01;
/*
 * 结论1 ： 说明finally语句在return语句执行完了以后才执行的.
 * yes  b>25 111 finaly  111
 */
public class Test1 {
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
        }
        return 1;
    }
}