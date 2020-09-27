package day01;
import java.util.Scanner;
/**
 * 根据下落时间，计算自由落体运动的位移
 *  数据：时间 t 单位 秒， 类型：浮点数
 *       重力加速度：g = 9.8  类型：浮点数
 *       位移：s 单位米，类型浮点数
 *   公式： s = (g * t * t) /2 
 *   
 *   公式：t = Math.sqrt((2*s)/g);
 *   Math.sqrt() 是Java API 提供的开平方函数
 */
public class Demo05 {
  public static void main(String[] args) {
	  //控制台输入  在控制台上可以输入一个数
    Scanner console = new Scanner(System.in);
    System.out.print("输入下落时间：");
    double t = console.nextDouble();//从控制台读取double数据
    double g = 9.8;
    double s;
    s = (g*t*t)/2;
    System.out.println("位移："+s);
  }
}





