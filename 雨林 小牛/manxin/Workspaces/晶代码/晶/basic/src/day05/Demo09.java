package day05;

import java.util.Arrays;

/**
 * 冒泡排序
 * 算法策略：每轮次比较相邻的元素，大数向后交换 
 *    经过 n-1 的轮次完成排序操作
 *  i 代表每次排序的轮次
 *  j 和 j+1 代表相邻的元素
 */
public class Demo09 {
	public static void main(String[] args) {
		int[] ary = {9, 2, 10, 5, 7, 1};
		Demo09.sort(ary);
		System.out.println(Arrays.toString(ary)); 
	}
	public static void sort(int[] ary){
		for(int i=0; i<ary.length-1; i++){
			for(int j=0; j<ary.length-i-1; j++){
				if(ary[j]>ary[j+1]){
					int t = ary[j];
					ary[j] = ary[j+1];
					ary[j+1] = t;
				}
				
			}
		}
	}
}
