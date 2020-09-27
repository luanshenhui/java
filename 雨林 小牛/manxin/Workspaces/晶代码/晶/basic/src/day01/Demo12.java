package day01;
/**
 * 1) java 中 字面量（直接量）之间的运算，在编译期间，
 *   优化为运算结果了。
 * 2) Java 中int类型的“字面量”，在不超过小类型范围情况下
 *   可以给小类型变量赋值
 * 3）由于Java编译器，不能确定变量表达式的结果，不允许直接
 *   将大类型变量给小类型赋值  
 */
public class Demo12 {
  public static void main(String[] args) {
    int n = 2;
    char c;
    c = 'A'+2;// int  67
    //c = 'A'+n;//编译错误，不能转换int到char
    c = (char)('A'+n);
    //c = 'A'+65530;//编译错误，超过char范围
    
    byte b;
    b = 4+6;
    //b = 4+n;//编译错误
    //b = 4+126;//编译错误
    b = 4 + 0xffffffff;  
  }
}



