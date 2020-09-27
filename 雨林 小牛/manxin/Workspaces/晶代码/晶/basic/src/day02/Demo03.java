package day02;
/**
 * 自增(减)运算 ++ -- 
 *   作用是将变量的值自身增加1(减少1)
 */
public class Demo03 {
  public static void main(String[] args) {
    int a = 1;
    a++;
    System.out.println(a);//2
    ++a;
    System.out.println(a);//3
    int b;
    a = 1;
    //a++: 后++, 先取a值,然后增加 
    b = (a++);//两个运算, 现在执行++ 运算, 然后执行赋值=运算
    //执行顺序参考: b = (a++) 
    // ++运算  1) 先取"a"的值1 作为"a++表达式"的值1
    // ++运算  2) 然后将a的值增加1, a为2
    // = 运算  3) 将"a++ 表达式"的值1 赋值给 b为1
    System.out.println(a+","+b); //2,1
    a = 1;
    a = a++;//两个运算, 现在执行++ 运算, 然后执行赋值=运算
    // ++运算  1) 先取a的值1 作为"a++表达式"的值1
    // ++运算  2) 然后将a的值增加1, a为2
    // = 运算  3) 将"a++ 表达式"的值1 赋值给 a为1
    System.out.println(a);//1
    a = 1;
    System.out.println(a++); //1
    System.out.println(a); //2
    
    
    
  }
}







