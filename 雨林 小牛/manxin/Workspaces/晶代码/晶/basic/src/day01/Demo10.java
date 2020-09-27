package day01;
import java.util.Random;//Java 随机数API
/**
 * 随机生成 A ~ Z 的某个字符 
 * 1）如何使用随机数 API
 * 2）整数是可以参与运算的
 */
public class Demo10 {
  public static void main(String[] args) {
    Random random = new Random();
    //random.nextInt(26)可以生成范围 [0,26)随机数 
    //()代表的是范围或者个数   + 后面代表的是从哪开始
    int n = random.nextInt(26)+0;
    System.out.println(n);
    //'A' + n , n 范围 [0,26)  
    char c = (char)('A'+n);
    System.out.println(c); 
    //System.out.println('中'*'国'); 
  }
}


