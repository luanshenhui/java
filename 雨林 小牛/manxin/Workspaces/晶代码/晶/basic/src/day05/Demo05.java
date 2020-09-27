package day05;

import java.util.Arrays;

/**
 * 二分查找算法 
 * 找 Tom 返回 位置
 * 
 *   Andy Jerry John Tom Wang
 *
 * 找 Tom 返回 负数 表示找不到
 *
 *  Tom  Andy  Jerry  John  Wang  
 *  
 * 找 Wang 返回 位置
 *
 *  Tom  Andy  Jerry  John  Wang  
 * 
 */
public class Demo05 {
	public static void main(String[] args) {
		String[] names={"Tom","Andy","Jerry","John","Wang"};
		//binary 二进制 Search 查找 ，binarySearch 二分查找
		int index = Arrays.binarySearch(names,"Jerry");
		System.out.println(index);//2 找到
		index = Arrays.binarySearch(names,"Wang");
		System.out.println(index);//4 找到
		index = Arrays.binarySearch(names,"Tom");
		System.out.println(index);//负数 找不到！
		//二分查找，在未排序的数组上二分查找结果是不稳定的！
		Arrays.sort(names);
		index = Arrays.binarySearch(names,"Tom");
		System.out.println(index);//3 找到Tom！
		index = Arrays.binarySearch(names,"Lee");
		System.out.println(index);//负数 找不到！
	}
}






