package day02;
/**
 * 取余运算， 取模运算
 *  获取除法结果中的余数
 *  1) 负数取余的结果： 负数和0，工作很少使用，考试可能有！
 *  2) 正数方向，n的余数是周期函数，并且小于n
 *     在工作中, 周期性的运算经常采用 % 实现
 *     
 *     ++i ++在前面先+1  在运算
 *     i++ ++在后面先运算  再+1
 */
public class Demo02 {
  public static void main(String[] args) {
    int n = 5;
    int m = n % 3;
    System.out.println(m);//2
    
    System.out.println(-4%3);//-1
    System.out.println(-3%3);//0
    System.out.println(-2%3);//-2
    System.out.println(-1%3);//-1
    System.out.println(0%3);//0
    System.out.println(1%3);//1
    System.out.println(2%3);//2
    System.out.println(3%3);//0
    System.out.println(4%3);//1
    System.out.println(5%3);//2
    System.out.println(6%3);//0
  }
}
