package day01;
/**
 * 详细的float double 的计算规则参考 IEEE 754 标准
 * 1) 由于float 精度比较差，很少使用,大多使用double
 *
 * 精度：尾数长度决定
 * 大小范围：指数（小数点位置）决定
 *  a = 3.1415926535897932384626433832
 *  b = 3.1415926535897 * 100
 *  
 *  float 的精度 没有 int 高，但是float的大小范围比int大！
 * 2) 浮点数字面量默认是double 类型
 *   D为后缀是double  f 后缀是float 
 */
public class Demo03 {
  public static void main(String[] args) {
    float fa = 5;
    float fb = 5;
    float fc = fa + fb;
    System.out.println(fc);//10.0
    int a = 0x7fffffff;
    int b = 0x7ffffff0;
    System.out.println(a-b);//15
    fa = a;//损失精度，舍入误差
    fb = b;
    System.out.println(a+"aaaaaaaaa");
    System.out.println(b);
    System.out.println(fa);
    System.out.println(fb);
    System.out.println(fa-fb+"bbbbbb");//说明float精度不高，有误差
    System.out.println(a+b);//超过int范围发生溢出了
    System.out.println(fa+fb);//float 范围比int大
    
    double da = a;
    double db = b;
    System.out.println(da-db);
    System.out.println(da+db);
    
    
    //IEEE 754、、
    //默认的浮点数字面量是double 类型
    double pi = 3.1415926535897932384;
    //float f = 3.1415926535897932384;//编译错误。
    //double 字面量不能赋值给float
    float f = 3.1415926535897932384F;
    System.out.println(pi);
    System.out.println(f);
    
    //注意区别： 1 1L 1.0 1D 1F 
    //浮点数运算的不精确性, 避免使用浮点数进行精确计算
    
    double x = 2.6;
    double y = x - 2;
    System.out.println(y); 
    
  }
}








