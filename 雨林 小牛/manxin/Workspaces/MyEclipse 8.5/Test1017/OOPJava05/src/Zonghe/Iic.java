package Zonghe;
import java.util.*;

public class Iic {

	/**
	 * 冰淇淋第二杯半价
	 * 库存50
	 * 卖完下班
	 */
	public static void main(String[] args) {
		for(int ku = 50;ku > 0;){
			System.out.println("冰淇淋1个4元，第二杯半价");
			System.out.println("库存还剩：" + ku);			
			System.out.println("需要几个？");
			Scanner scan = new Scanner(System.in);
			int in = scan.nextInt();
			if(in > ku){
				System.out.println("没有那么多！请重新选择：");
			}else{
				int sum = 0;
				sum = in/2*6 + in%2*4;
				ku -= in;
				System.out.println("您一共购买了" + in +"个，一共：" + sum + "元");
			}
		}
		System.out.println("已经卖完了，可以下班了");

	}

}
