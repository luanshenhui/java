package day01;
/*
 * ����1 �� ˵��finally�����return���ִ�������Ժ��ִ�е�.
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