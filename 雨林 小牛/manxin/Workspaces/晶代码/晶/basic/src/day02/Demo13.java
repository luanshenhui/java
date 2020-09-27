package day02;
import java.util.Scanner;
/**
 * 计算3个数字中的最大值
 *  
 *   a   b   c
 *     max
 *        max 
 *         
 */
public class Demo13 {
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		int a,b,c;
		System.out.print("输入a b c(空格分隔)：");
		//12 348 230
		a = in.nextInt();//12
		b = in.nextInt();//348
		c = in.nextInt();//230
		int max = a>b ? a : b;//348
		max = max > c ? max : c;//348
		System.out.println("最大值："+max);//348
	}
}




