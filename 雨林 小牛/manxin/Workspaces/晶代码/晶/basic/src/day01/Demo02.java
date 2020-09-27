package day01;
/**
 * double float boolean byte short int long char
 * boolean byte short char int float double long
 * long 类型
 * 1) 使用L后缀的字面量(直接量) 是long类型
 * 2) 计算机时间规定: long类型 从GMT 1970年元旦开始 累计的
 *    毫秒数作为时间, 这个规定:将时间转换为整数long
 * 3) 使用 System.currentTimeMillis() 获得系统时间
 * 4) 时间是一个long整数！
 * 
 * 
 */
public class Demo02 {
  public static void main(String[] args) {
	  
    //current 当前的  Time 时间 Millis 毫秒数
    //获取当前系统(System)的时间毫秒数
	//之前讲过的都是对象调用方法 但是此时此刻  没有使用对象来调用这是为什么？
	//因为currentTimeMillis方法是一个静态方法  由static修饰的方法
	 //由static修饰的方法或者属性  是可以直接由类名调用的  步经过对象
	//方法的返回值是什么  你就应该有什么类型来接收
    long now = System.currentTimeMillis();
    System.out.println(now); 
    long year = now/1000/60/60/24/365 + 1970;
    System.out.println(year); 
  }
}



