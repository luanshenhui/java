package day01;
/**
 * 1）字符是一个16位无符号"整数"！
 *    字符的数值是unicode编码值
 *    整数范围：0 ~ 65535
 * 2) unicode 8万多字 
 *   规定：'中' 编码数字 20013
 *         '田' 编码数字 30000
 *         'A' 编码数值 65
 *   unicode英文编码与ASCII编码一致
 * 3) Java char 类型支持了 i18n(国际化), 就是支持全球文字
 * 4) 在中文本地系统中，字库（字模）只能显示20000+文字！
 * 5） 字符字面量 就是一个char整数字面量 '中' 
 * 6）字符可以参与数学运算
 *   
 *   'A' 的编码 65  
 *   'B' 66
 *    ...
 *    'Z' 90
 *   '0' 48
 *   '1' 49
 *   ...
 *   '9' 57
 *    
 * 7) 特殊字符，可以使用转义字符书写
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
public class Demo08 {
  public static void main(String[] args) {
    char c = 20013;//字符是一个数！
    System.out.println(c);//中
    c = 45666;//65535
    System.out.println(c);//不可显示
    // a  97  A  65  0  48
    c = 'A'+2;
    System.out.println(c+"sss");//'C'
    System.out.println((int)'A'); //'A'是10进制编码
    System.out.println((int)'B');
    System.out.println((int)'C');
    //...
    System.out.println((int)'Z');
    // '0' ~ '9'  'a' ~ 'z'  每个人 姓名的编码
    System.out.println((int)'晶');
  }
}






