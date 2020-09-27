package day01;

import java.util.Scanner;

public class Test3 {
  public static void main(String[] args){
	  Scanner a = new Scanner(System.in);
	  double g = 9.8;
	  double t;
	  System.out.println("输入位移");
	  double s = a.nextDouble();
	  t = Math.sqrt(2*s/g);
	  System.out.println("时间："+t);
  }	
}
