package Zonghe;
import java.util.*;

public class Year {

	/**
	 * 输入一个年份，判断是否是闰年
	 * 闰年：能被4整除，不能被100整除，但是可以被400整除
	 */
	public static void main(String[] args) {
		Scanner scan = new Scanner(System.in);
		while(true){
			System.out.println("请输入一个年份：");
			int year = scan.nextInt();
			if(year % 4 == 0 && year % 100 != 0 || year % 400 == 0){
				System.out.println(year + "是闰年");
			}else{
				System.out.println("不是闰年");
			}
		}
	}

}
