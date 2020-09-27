package day01;
import java.util.Scanner;
/**
 * 根据距离，计算下落时间 
 */
public class Demo06 {
  public static void main(String[] args) {
    Scanner in = new Scanner(System.in);
    double s;
    double t;
    double g = 9.8;
    System.out.print("输入下落距离：");
    s = in.nextDouble();
    t = Math.sqrt((2*s)/g);
    System.out.println("下落时间："+t); 
  }
}
