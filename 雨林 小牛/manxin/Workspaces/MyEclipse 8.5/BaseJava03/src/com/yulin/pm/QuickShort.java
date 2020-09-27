package com.yulin.pm;

import java.util.Arrays;

public class QuickShort {

	/**
	 * 数组的快速排序和插入排序
	 */
	public static int Partition(int[] a,int p,int r){
		int x=a[r-1];
		int i=p-1;
		int temp;
		for(int j=p;j<=r-1;j++){
			if(a[j-1]<=x){
				//swap(a[j-1],a[i-1]);
				i++;
				temp=a[j-1];
				a[j-1]=a[i-1];
				a[i-1]=temp;
			}
		}
		//swap(a[r-1,a[i+1-1]);
		temp=a[r-1];
		a[r-1]=a[i+1-1];
		a[i+1-1]=temp;
		return i+1;
	}
	
	public static void QuickShort(int[] a,int p,int r){
		if(p<r){
			int q=Partition(a,p,r);
			QuickShort(a,p,q-1);
			QuickShort(a,q+1,r);
		}
	}
	
	//插入排序
/*	public static void QuickShort(int[] number){
		for(int j=1;j<number.length;j++){
			int temp=number[j];	//抓到的数，放到变量temp中，用以和之前的比较
			int i=j-1;	//前一个的下标
			while(i>=0 && number[i]>temp){
				//逐一跟前面的去比较，如果已经比前一个数大，就不需要比了
				number[i+1]=number[i];
				i--;
			}	
				number[i+1]=temp;		//如果while循环不成立，这个数已经是最大了，直接放在当前位置
										//i+1实际上=j
		}
	}*/
	public static void main(String[] args) {
		/*快速排序
		int[] a={23,53,77,36,84,76,93,13,45,24};
		QuickShort(a,1,10);*/
		
		//插入排序
		int[] number={3,46,26,67,2,35};
		QuickShort(number,1,6);
//		QuickShort(number);
		System.out.println(Arrays.toString(number));
	}

}
