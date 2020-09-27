package com.txt;

public class A {
	public static void main(String[] args) {
		int[] arr = { 1, 2, 3, 4, 5, 6, 17, 0, 0, 0, -1, -4, -3 };
		m1(arr);
	}

	private static void m1(int[] arr) {
		int index = 0;
		int ss = 0;
		int jj = 0;
		for (int i = 0; i < arr.length; i++) {
			if (arr[i] > 0) {
				index++;
			}
			if (arr[i] == 0) {
				ss++;
			}
			if (arr[i] < 0) {
				jj++;
			}
		}
		System.out.println("整数" + index + "。" + "0是" + ss + "负数" + jj);
		
		int ws=arr[0];
		double count=0;
		for(int i:arr){
			count=count+i;
			if(i>arr[0]){
				ws=i;
				
			}
		}
		System.out.println("最大值是"+ws);
		System.out.println("平均值"+count/arr.length);
		
		
		
		
		int[]arr1={1, 2, 3, 4, 5, 6, 7, 0, 0, 0, -1, -4, -8};
		int max=method(arr1);
		//System.out.println(max);
	}
		public static int method(int[] arr1){
			int max=arr1[0];
			for(int i=0;i<arr1.length;i++){
				if(arr1[i]>max){
					max=arr1[i];
				}
			}
			
			return max;
			
		}
}
