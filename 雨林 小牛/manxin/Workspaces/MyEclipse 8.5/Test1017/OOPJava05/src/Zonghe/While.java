package Zonghe;
import java.util.*;

public class While {

	/**
	 * 利用while循环从控制台输入任意多个整数，当输入的值为0时，结束输入，输出最大的数。
	 */
	public static void main(String[] args) {
		Scanner scan = new Scanner(System.in);
		int max = 0;
		while(true){
			System.out.println("请输入一个整数:");
			int in = scan.nextInt();
//			max = in;
			if(in == 0){
				System.out.println("输入0时结束！");
				break;
			}
			if(in > max){
				max = in;
//				break;
			}
		}
		System.out.println("最大值为：" + max);

	}

}
