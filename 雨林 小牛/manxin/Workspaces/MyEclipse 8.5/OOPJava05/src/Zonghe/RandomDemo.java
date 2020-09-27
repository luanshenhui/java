package Zonghe;
import java.util.*;

public class RandomDemo {

	/**
	 * 随机出1~10中不重复的5个数
	 */
	public static void main(String[] args) {
		// 1.随机出1~10中不重复的5个数
		//不重复
		Random rd = new Random();
		int[] arr = new int[5];
		for(int i = 0; i < arr.length; i++){
			int in = rd.nextInt(10) + 1;
			arr[i] = in;
			for(int j = 0; j < i; j++){
				if(arr[j] == in){
					i--;
				}
			}
		}
		System.out.println("方法1.随机出的数组：" + Arrays.toString(arr));
		
		//2.随机出1~10中不重复的5个数
		Random rd1 = new Random();
		int[] arr1 = new int[5];
		boolean[] bo = new boolean[11];
		for(int i = 0; i < arr1.length; i++){
			int in = rd1.nextInt(10) + 1;
			if(bo[in] == false){
				arr1[i] = in;
				bo[in] = true;
			}else{
				i--;
			}
		}
		System.out.println("方法2.随机出的数组：" + Arrays.toString(arr1));
		//水仙花数 
		// 水仙花数：一个三位数，这个数等于它各个位上的数的立方和
		for(int i = 100; i < 1000; i++){
			int a = i % 10;
			int b = (i / 10) % 10;
			int c = (i / 100) % 10;
			if(i == a*a*a+b*b*b+c*c*c){
				System.out.println("水仙花数：" + i);
			}
		}
	}
	
}
