package day05;

import java.util.Arrays;

/**
 * 插入式排序 
 * 算法：将数组元素分为两组，前组是已经排序的，后组是未排序
 *   将后组的每个元素插入到前组的合适位置
 * 其中：i 代表后组每个待插入元素位置
 *      j 代表前组每个被比较元素位置
 *      k 代表待插入的元素 
 */
public class Demo08 {
	public static void main(String[] args) {
		int[] ary = {10, 6, 2, 9, 2, 1};
		Demo08.sort(ary);//Arrays.sort(ary)
		System.out.println(Arrays.toString(ary)); 
	}
	public static void sort(int[] ary){
		int i,j,k;
		for(i=1; i<ary.length; i++){
			k = ary[i];//取出
			//移动
			for(j=i-1; j>=0 && k<ary[j]; j--){
				ary[j+1] = ary[j];//元素[j]向后移动
			}
			ary[j+1] = k;//插入
		}
	}
}
