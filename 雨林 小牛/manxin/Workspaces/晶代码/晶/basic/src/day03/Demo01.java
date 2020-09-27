package day03;

import java.util.Scanner;
/**
 * if(){
 * 
 * }else if(){
 * 
 * }
 */
public class Demo01 {
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		System.out.print("ÊäÈë·ÖÊý£º");
		int score = in.nextInt();
		if(score>=90){
			System.out.println("A");
		}else if(score>=80){
			System.out.println("B"); 
		}else if(score>=70){
			System.out.println("C");
		}else if(score>=60){
			System.out.println("D");
		}else{
			System.out.println("E"); 
		}
	}
}
