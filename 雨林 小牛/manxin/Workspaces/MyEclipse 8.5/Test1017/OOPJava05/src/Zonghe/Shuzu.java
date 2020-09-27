package Zonghe;
import java.util.*;

public class Shuzu {

	/**
	 * 输入的数字不能重复
	 */
	public static void main(String[] args) {
		Scanner scan = new Scanner(System.in);
		int arr[] = new int[5];
		int in;
		for(int i = 0;i < arr.length; i++){
			System.out.println("请输入5个整数：");
			in = scan.nextInt();
			arr[i] = in;
			for(int j = 0;j < i; j++){
				if(arr[j] == in){
					i--;
					System.out.println("输入的整数不能重复，请重新输入！");
				}
			}
		}
		
		System.out.println(Arrays.toString(arr));
	}

}
