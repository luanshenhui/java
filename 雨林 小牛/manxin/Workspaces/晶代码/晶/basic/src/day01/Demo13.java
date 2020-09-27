package day01;
/**
 * 封闭性原则
 *  1）同种类型参与运算，等到同种类型结果
 *  2）小于32位数（byte, short, char）按照32位计算 
 *  3）注意，整数的除法是整除
 */
public class Demo13 {
  public static void main(String[] args) {
    int a = 3;
    int b = 4;
    int c = a+b;
    System.out.println(c);//7
    long l = 5L + a;
    System.out.println(l); //8
    a = 0x7fffffff;
    c = a + 1;
    System.out.println(c);//溢出，为最小值！
    l = a + 1;
    System.out.println(l);//溢出，为最小值！
    l = (long)a + 1;//先转换在相加
    System.out.println(l);//正常！

    byte b1 = 5;
    byte b2 = 6;
    //byte b3 = b1+b2;//编译错误
    byte b3 = (byte)(b1+b2);
    
    System.out.println(5/2);// 得 2 余 1
    System.out.println(5.0/2);
    System.out.println(5D/2);
    System.out.println((double)5/2);
    
    double price = 59.99;
    System.out.println(price * (80/100)); //整除
    System.out.println(price * (80.0/100)); //浮点除法
  }
  
}













