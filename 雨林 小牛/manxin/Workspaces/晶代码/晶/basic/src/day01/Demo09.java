package day01;
/**
 *  * 7) 特殊字符，可以使用转义字符书写
 *   '\n' new line 换行
 *   '\r' return 回车
 *   '\t' tab 字符
 *   '\\' \ 字符
 *   '\'' 单引号
 *   '\"' 双引号
 *   '\u4e2d' unicode 16进制编码  
 * 8) 控制字符也是字符，如：回车，换行，退格等，
 *    但是控制字符输出显示效果不明显
 */
public class Demo09 {
  public static void main(String[] args) {
    char c = '\'';
    System.out.println(c);//'
    c = '\u4e2d';
    System.out.println(c);//中
    c = '\b';
    System.out.println(c);
  }
}




