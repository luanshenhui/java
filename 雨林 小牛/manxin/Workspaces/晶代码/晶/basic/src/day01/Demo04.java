package day01;
import java.math.BigDecimal; 
/**
 * Java 中精确小数计算的解决方案 
 *  BigDecimal API类实现了精确的定点小数计算
 *  变量的类型有几种？ 基本数据类型（八种） 引用类型
 *  BigDecimal 是一个引用类型  在java提供了很多类  这个类叫工具类
 *  你怎么去使用这个工具类呢？  你就要将这个工具类引入到你的该.java文件中
 *  
 */
public class Demo04 {
  public static void main(String[] args) {
    BigDecimal x = new BigDecimal("2.6");
    BigDecimal y = new BigDecimal("2");
    //subtract 减法
    BigDecimal z = x.subtract(y);
    System.out.println(z); 
    z = x.add(y);//加
    System.out.println(z);
    z = x.multiply(y);//乘法
    System.out.println(z);
    z = x.divide(y); //除
    System.out.println(z);
  }

}
