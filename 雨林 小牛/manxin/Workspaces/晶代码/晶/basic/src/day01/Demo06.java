package day01;
import java.util.Scanner;
/**
 * ���ݾ��룬��������ʱ�� 
 */
public class Demo06 {
  public static void main(String[] args) {
    Scanner in = new Scanner(System.in);
    double s;
    double t;
    double g = 9.8;
    System.out.print("����������룺");
    s = in.nextDouble();
    t = Math.sqrt((2*s)/g);
    System.out.println("����ʱ�䣺"+t); 
  }
}
