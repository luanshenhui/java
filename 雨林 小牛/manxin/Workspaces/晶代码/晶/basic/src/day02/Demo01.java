package day02;
/**
 * 类型转换 
 */
public class Demo01 {
  public static void main(String[] args) {
    //实验目的，观察java自动的将byte转换为int了   
    byte b = -1;
    //隐式数据类型转换，自动类型转换      
    // toHexString 将整数转换为16进制形式的字符串
    System.out.println(Integer.toHexString(b));
    //将-1转换为 “ffffffff” 然后输出到控制台
    //System.out.println(Integer.toHexString((int)b));
    
  }
}
