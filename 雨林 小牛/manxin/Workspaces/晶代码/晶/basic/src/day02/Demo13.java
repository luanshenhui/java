package day02;
import java.util.Scanner;
/**
 * ����3�������е����ֵ
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
		System.out.print("����a b c(�ո�ָ�)��");
		//12 348 230
		a = in.nextInt();//12
		b = in.nextInt();//348
		c = in.nextInt();//230
		int max = a>b ? a : b;//348
		max = max > c ? max : c;//348
		System.out.println("���ֵ��"+max);//348
	}
}




