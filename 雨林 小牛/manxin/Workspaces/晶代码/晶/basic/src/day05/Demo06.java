package day05;

import java.util.Arrays;

/**
 * 赋值  复制
 * 
 * 数组的复制 
 * 栈内存：相对于堆内存 比较小   有序的  先进后出 后进先出的原则 
 * 存储的是基本数据类型和引用变量  
 * 堆内存：比较大   无序     存储的是对象
 * 
 * 
 * 最常见用途：数组扩容算法
 */
public class Demo06 {
	public static void main(String[] args) {
//数组变量的赋值, 但是数组还是同一个。ary1 ary2 相互影响
		int[] ary1 = {4,5,6};
		int[] ary2 = ary1;
		ary2[1]++;
		System.out.println(Arrays.toString(ary1));
		System.out.println(Arrays.toString(ary2));
//数组的复制  1）使用for循环实现， 2）使用API
		//将ary1引用的数组进行复制
		int[] ary3 = new int[ary1.length];
		for(int i=0; i<ary1.length; i++){
			ary3[i] = ary1[i];
		}
		ary3[1]++;
		System.out.println(Arrays.toString(ary1));
		System.out.println(Arrays.toString(ary3));
		//使用API System.arraycopy() 实现复制
		//复制 ary1 为 ary4
		int[] ary4 = new int[ary1.length];
		//(源数组，源数组起始位置，目标数组，目标数组起始位置，个数)
		System.arraycopy(ary1, 0, ary4, 0, ary1.length);
		//ary1 = [4, 6, 6] 
		//ary4 = [4, 6, 6] 
		System.out.println(Arrays.toString(ary1));
		System.out.println(Arrays.toString(ary4));
		//使用 Arrays.copyOf() 方法，底层就是arraycopy 
		//复制ary1 到 ary5 , copyOf() Java5 的新API
		int[] ary5 = Arrays.copyOf(ary1, ary1.length);
		System.out.println(Arrays.toString(ary1));
		System.out.println(Arrays.toString(ary5));
	}
}




