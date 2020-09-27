package day01;
/**
 * TeX 
 */
public class Demo11 {
  public static void main(String[] args) {
  //自动类型转换 也称为 隐式类型转换
    int i = -1;//i 是32位数
    long l = i;//l 是64位数, 发生符号位扩展现象
    System.out.println(l);//-1
    System.out.println(Integer.toBinaryString(i));
    System.out.println(Long.toBinaryString(l));
    //Long.toBinaryString方法的参数是long类型 
    //在i向long 类型参数传递时候发生了自动类型转换！
    System.out.println(Long.toBinaryString(i));
    byte b = -1;
    System.out.println(Long.toBinaryString(b));
    System.out.println(Integer.toBinaryString(b));
    b = 5;
    System.out.println(Long.toBinaryString(b));
   //强制类型转换： 大类型到小类型的转换 
    l = 5;
    i = (int)l;//范围之内的情形，没有问题
    System.out.println(i);//5
    l = 0x8ff00000005L;
    System.out.println(l); 
    i = (int)l;//超过整数范围，发生高位溢出现象
    System.out.println(i); 
    //强制类型转换也会发生精度损失
    double pi = 3.1415926535897932384 * 10000;
    float f = (float)pi;
    l = (long)pi;
    System.out.println(pi);
    System.out.println(f);
    System.out.println(l);
    l = (long)(pi+0.5);//利用强制类型转换实现 4舍5入
    System.out.println(l); //4舍5入
  }
}













